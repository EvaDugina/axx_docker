# Accelerator
Админ:  
**Логин:** `admin`  
**Пароль:** `7136644`  

Студент:  
**Логин:** `sergeyiva`  
**Пароль:** `7136644`  


Онлайн редактор кода доступен по адресу: [http://localhost:8080/editor.php?assignment=-1](http://localhost:8080/editor.php?assignment=-1)

## Как запустить Accelerator

### При необходимости измените следующие файлы:

- **`env.php`** — для хранения общих параметров окружения.  
- **`dbparams.php`** — для настройки подключения к базе данных в PHP.  


### Запуск

Перейдите в директорию с проектом и выполните команду:

```bash
docker-compose up
```

# Инструкция по развертыванию

## Git
git submodule update --init

## Accelerator

1. Подменить auth_ssh
2. Изменить параметры подключения в env.php

## Докер
1. Изменить внешний порт psql (при необходимости)
2. docker-compose build
3. docker-compose up

---

# Дополнительная информация

### Размер максимального загружаемого файла
`= 10мб`, чтобы изменить: 
- https://stackoverflow.com/questions/24306335/413-request-entity-too-large-file-upload-issue
- for_docker/nginx/nginx.conf: client_max_body_size
- for_docker/php/php.ini: upload_max_filesize
- accelerator/config.json: MAX_FILE_SIZE
