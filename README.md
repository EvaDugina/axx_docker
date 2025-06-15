# Accelerator
Доступен по адресу: http://localhost:8080/login.php

---

# Инструкция по развертыванию

## Git

1. Pull
```bash
git pull --recurse-submodules
```

2. Обновление submodules рекурсивно вглубь
```bash
git submodule update --init --recursive
```

## Accelerator

1. Переместить с заменой все файлы из папки ```./for_accelerator``` в ```./accelerator```
файлы в ```./for_accelerator```: auth_ssh.class.php, auth.php
2. Добавить бэкап для БД (при необходимости) в папку ```./backups```
формате бэкапа: ```dump_2025-06-15_19-21-40.sql``` 

## Nitori Base

1. Сборка nitori_sandbox (~10 минут)
```bash
cd ./nitori_base/sandbox 
docker build . -t nitori_sandbox
```

## Docker

1. Проверить не занятость внешних портов из ```./docker-compose.yml```
2. Собрать образ (~11 минут)
```bash
docker-compose build
```
3. Поднять контейнер (~10 минут)
```bash
docker-compose up
```

---

# Xdebug для отладки Php

1. Раскомментировать строчку в ```docker-compose.yml``` #Для отладки (XDEBUG)
2. Раскомментировать в ```Dockerfile.php``` #ДЛЯ ОТЛАДКИ (XDEBUG)
3. Применить конфигурацию для ```launch.json``` в VSCode:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}/accelerator"
            }
        },
    ]
}
```

---

# Дополнительная информация

### Размер максимального загружаемого файла
`= 10мб`, чтобы изменить: 
- https://stackoverflow.com/questions/24306335/413-request-entity-too-large-file-upload-issue
- for_docker/nginx/nginx.conf: client_max_body_size
- for_docker/php/php.ini: upload_max_filesize
- accelerator/config.json: MAX_FILE_SIZE
