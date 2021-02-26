box.cfg{}
kv = box.schema.create_space('kv', { 
    if_not_exists = true
})
kv:format({ 
    {name = 'key'; type = 'string'}, 
    {name = 'value';   type = 'string'}, 
})
box.schema.user.grant('guest', 'read,write,execute', 'universe')
kv:create_index('primary', { type = 'HASH', parts = {'key'}, })
os.exit()