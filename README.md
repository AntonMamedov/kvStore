На плтформе tarantool с помощью lua модуля http было реализовано kv хранилище,
предоставляющее следующие методы.

- POST /kv body: {key: "test", "value": {SOME ARBITRARY JSON}}
- PUT kv/{id} body: {"value": {SOME ARBITRARY JSON}}
- GET kv/{id}
- DELETE kv/{id} 

Уникальными индексами в данном хранилище яввляются ключи key.

В заголовке "Location" метод POST возвращает расплоложение нового объекта.
