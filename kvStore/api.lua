function ParseCommandArgs()
    local commandArgs = {}
    for index, value in pairs(arg) do
        if (index > 0) then
            local agrument = string.split(value, "=", 2)
            local key = agrument[1]
            local value = agrument[2]
            if key and value then
                commandArgs[key] = value
            end
        end
    end
    return commandArgs
end

local argTable = {
    ['-addr'] = '0.0.0.0',
    ['-port'] = '80',
    ['-log_format'] = 'json',
    ['-log_path'] = 'kv_logs.json',
    ['-listen'] = 3000,
}

local commandArgs = ParseCommandArgs()

for key, value in pairs(commandArgs)do
    argTable[key] = value
end


local work = pcall(function ()
    box.cfg{
        log_format = argTable['-log_format'],
        log = argTable['-log_path'],
        listen = argTable['-listen']
    } 
    end)

if not work then
    print("Один из следующих аргументов некорректен:\n-listen\n-log_path\n-log_format\nПередайте корреткное значение.")
    os.exit()
end

local http_router = require('http.router')
local http_server = require('http.server')
local json = require('json')
local console = require('console')
local port = tonumber(argTable['-port'])
local httpd = http_server.new(argTable['-addr'], tonumber(argTable['-port']), {
    log_requests = true,
    log_errors = true
})

local router = http_router.new()


router:route({method = 'GET', path = '/kv/.*'},
        function(request)
            local target = request['PATH_INFO']:split('/')[3]
            local data = box.space.kv:select{target}[1]
            if data then
                return{status = 200, body = data[2], headers = {
                    ['content-type'] = 'application/json; charset=utf8' },
                }
            else
                return{status = 404}
            end
        end
)

router:route({method = 'DELETE', path = '/kv/.*'},
        function(request)
            local target = request['PATH_INFO']:split('/')[3]
            if target == nil or not box.space.kv:delete{target} then
                return{status = 404}
            else
                return{status = 204}
            end
        end
)

function PostRequestValidation(body)
    local key = type(body['key'])
    local value = body['value']
    if key == 'string' or key == 'number' and value then
        return true
    else
        return false
    end
end

router:route({method = 'POST', path = '/kv'},
        function(request)
            local body = nil
            pcall(function ()
                body = request:json()
            end)

            if not body or not PostRequestValidation(body) then
                return{status = 400}
            else
                local key = tostring(body['key'])
                local keyInserted = pcall(
                        function() 
                            box.space.kv:insert{key, json.encode(body['value'])}
                        end
                )
                if keyInserted then
                    return{status = 202,  headers = {
                        ['Location'] = '/kv/' .. key},
                    }
                else
                    return{status = 409}
                end
            end
        end
)

function PutRequestValidation(body)
    local value = body['value']
    if value then
        return true
    else
        return false
    end
end

router:route({method = 'PUT', path = '/kv/.*'},
        function(request)
            local body = nil
            pcall(function ()
                body = request:json()
            end)
            if not body or not PutRequestValidation(body) then
                return{status = 400}
            else
                local target = request['PATH_INFO']:split('/')[3]
                local val = json.encode(body['value'])
                local updatedTuple =  box.space.kv:update(target,{ { '=', 2, val}})
                if updatedTuple then
                    return {status = 204}
                else
                    return {status = 404}
                end
            end
        end
)


httpd:set_router(router)
httpd:start()
console.start()