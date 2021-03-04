#!/bin/bash

echo "Проверка корректного POST"
curl -D - -X 'POST' -d '{"key" : "1", "value": "test1"}' 178.154.250.164/kv

echo "Проверка POST с отсутствием ключа key"
curl -D - -X 'POST' -d '"value": "test1"}' 178.154.250.164/kv

echo "Проверка POST с ошибкой в теле запроса"
curl -D - -X 'POST' -d '{"key"фы : "1", "value": "test1"}' 178.154.250.164/kv

echo "Проверка POST с существующим ключем"
curl -D - -X 'POST' -d '{"key" : "1", "value": "test1"}' 178.154.250.164/kv

echo "Проверка POST с ключем - таблицей"
curl -D - -X 'POST' -d '{"key" : {"a" : 2}, "value": "test1"}' 178.154.250.164/kv

echo "Проверка POST с ключем - массивом"
curl -D - -X 'POST' -d '{"key" : ["a", "b", "c"], "value": "test1"}' 178.154.250.164/kv

echo "Проверка корректного GET"
curl -D - 178.154.250.164/kv/1

echo ' '

echo "Проверка GET с несуществующим ключем"
curl -D - 178.154.250.164/kv/2

echo ' '

echo "Проверка корректного PUT"
curl -D - -X 'PUT' -d '{"value": {"a" : 2, "b" : ["d", "e"]}}' 178.154.250.164/kv/1

curl -D - 178.154.250.164/kv/1

echo ' '
echo "Проверка PUT с некорректным телом"
curl -D - -X 'PUT' -d '{value: {"a" : 2, "b" : ["d", "e"]}}' 178.154.250.164/kv/1

echo "Проверка PUT с несуществующим ключем"
curl -D - -X 'PUT' -d '{"value": {"a" : 2, "b" : ["d", "e"]}}' 178.154.250.164/kv/2

echo "Проверка корреткного DELETE"
curl -D - -X 'DELETE' 178.154.250.164/kv/1

echo "Проверка наличия ключа после DELETE"
curl -D - 178.154.250.164/kv/1

echo "Проверка DELETE с отсутствующим ключем"
curl -D - -X 'DELETE' 178.154.250.164/kv/2
