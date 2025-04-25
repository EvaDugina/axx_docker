# Accelerator
Онлайн редактор кода доступен по адресу: [http://localhost:8080/editor.php?assignment=-1](http://localhost:8080/editor.php?assignment=-1)

## Пользователи
Админ:  
**Логин:** `admin`  
**Пароль:** `7136644`  

Студент:  
**Логин:** `sergeyiva`  
**Пароль:** `7136644`  

---

# Инструкция по развертыванию

## Git
в корне: git submodule update --init
в ./nitori_base: git submodule update --init

## Accelerator

1. Подменить auth_ssh
2. Изменить параметры подключения в env.php и dbparams.php

## Docker
1. Проверить занятость используемых портов
2. Из корня: docker-compose build, docker-compose up

---

# Дополнительная информация

### Размер максимального загружаемого файла
`= 10мб`, чтобы изменить: 
- https://stackoverflow.com/questions/24306335/413-request-entity-too-large-file-upload-issue
- for_docker/nginx/nginx.conf: client_max_body_size
- for_docker/php/php.ini: upload_max_filesize
- accelerator/config.json: MAX_FILE_SIZE
