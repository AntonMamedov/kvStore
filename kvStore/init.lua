box.cfg{}
kv = box.schema.create_space('kv', { if_not_exists = true})


kv:format({ {name = 'key';   type = 'string'}, {name = 'value';   type = 'string'}, })

kv:create_index('primary', { type = 'HASH', parts = {'key'}, })

os.exit()