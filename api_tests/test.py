import requests


addr = 'http://178.154.250.164'

def test_correct_post_request():
    req_body = {'key' : '1',
                'value' : '2'}
    resp = requests.post(url=addr + '/kv', json=req_body)
    assert resp.status_code == 202, "Код ответа не 202"

def test_incorrect_body_post_request():
    req_body = '{"key : "2", "value" : 3}'
    resp = requests.post(url=addr + '/kv', json=req_body)
    assert resp.status_code == 400, "Код ответа не 400"

def test_keyless_post_request():
    req_body = '{"value" : 3}'
    resp = requests.post(url=addr + '/kv', json=req_body)
    assert resp.status_code == 400, "Код ответа не 400"

def test_with_existing_key_post_request():
    req_body = {'key' : '1',
                'value' : '2'}
    resp = requests.post(url=addr + '/kv', json=req_body)
    assert resp.status_code == 409, "Код ответа не 409"

def test_key_table_post_request():
    req_body = {'key' : {'a' : 3},
                'value' : '2'}
    resp = requests.post(url=addr + '/kv', json=req_body)
    assert resp.status_code == 400, "Код ответа не 400"

def test_key_array_post_request():
    req_body = {'key' : ['a', 'b'],
                'value' : '2'}
    resp = requests.post(url=addr + '/kv', json=req_body)
    assert resp.status_code == 400, "Код ответа не 400"

def test_correct_get_request():
    resp = requests.get(url=addr + '/kv' + '/1')
    assert resp.status_code == 200, "Код ответа не 200"
    assert resp.text == '"2"', "Не верное тело ответа"

def test_incorrect_get_request():
    resp = requests.get(url=addr + '/kv' + '/2')
    assert resp.status_code == 404, "Код ответа не 404"

def test_correct_put_request():
    req_body = {"value" : {"a" : 1, "b" : "dfg"}}
    resp = requests.put(url=addr + '/kv' + '/1', json=req_body)
    assert resp.status_code == 204, "Код ответа не 204"

def test_incorrect_key_put_request():
    req_body = {"value": {"a": 1, "b": "dfg"}}
    resp = requests.put(url=addr + '/kv' + '/2', json=req_body)
    assert resp.status_code == 404, "Код ответа не 404"

def test_incorrect_body_put_request():
    req_body = '{ "value" : asd3 }'
    resp = requests.put(url=addr + '/kv' + '/1', json=req_body)
    assert resp.status_code == 400, "Код ответа не 400"

def test_correct_delete_request():
    resp = requests.delete(url=addr + '/kv' + '/1')
    assert resp.status_code == 204, "Код ответа не 204"

def test_incorrect_key_delete_request():
    resp = requests.delete(url=addr + '/kv' + '/2')
    assert resp.status_code == 404, "Код ответа не 404"

test_correct_post_request()
test_incorrect_body_post_request()
test_keyless_post_request()
test_with_existing_key_post_request()
test_key_table_post_request()
test_key_array_post_request()
test_correct_get_request()
test_incorrect_get_request()
test_correct_put_request()
test_incorrect_key_put_request()
test_incorrect_body_put_request()
test_correct_delete_request()