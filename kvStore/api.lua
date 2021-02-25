box.cfg{
    log_format='json',
    log='tarantool.txt'
}

local http_router = require('http.router')
local http_server = require('http.server')
local json = require('json')


local httpd = http_server.new('127.0.0.1', 80, {
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
            if target == nil or not box.space.kv:delete{target}[1] then
                return{status = 404}
            else
                return{status = 204}
            end
        end
)

function PostRequestValidation(body)
    local key = body['key']
    local value = body['value']
    if key and value then
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
                local keyInserted = pcall(
                        function()
                            box.space.kv:insert{body['key'], json.encode(body['value'])}
                        end
                )
                if keyInserted then
                    return{status = 202,  headers = {
                        ['Location'] = '/kv/' .. body['key'] },
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