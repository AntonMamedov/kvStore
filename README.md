- POST /kv body: {key: "test", "value": {SOME ARBITRARY JSON}}
- PUT kv/{id} body: {"value": {SOME ARBITRARY JSON}}
- GET kv/{id}
- DELETE kv/{id} 

Уникальными индексами в данном хранилище яввляются ключи key.

В заголовке "Location" метод POST возвращает расплоложение нового объекта.

В методах PUT и POST, в соответствии с правилами REST, лишние json поля игнорируются.
