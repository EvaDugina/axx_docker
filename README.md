# Accelerator
Доступен по адресу: http://localhost:8080/login.php

---

# Инструкция по развертыванию

## Git

1. Clone / Pull
```bash
git clone --recurse-submodules
ИЛИ:
git pull --recurse-submodules && \
```
2. Обновление submodules рекурсивно вглубь
```bash
git submodule update --init --recursive
```

## Accelerator

1. Скопировать все файлы из папки ```./for_accelerator``` в ```./accelerator```
файлы в ```./for_accelerator```: auth_ssh.class.php, auth.php

## Nitori Base
2. Обновление подмодулей
```bash
git submodule update --recursive
ИЛИ:
git submodule update --remote --merge --recursive
```
3. Сборка nitori_sandbox
```bash
cd ./nitori_sandbox/sandbox
docker build . -t nitori_sandbox
```

## Docker
1. Проверить не занятость внешних портов из ```./docker-compose.yml```
2. Запустить контейнер
```bash
docker-compose build, docker-compose up
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
