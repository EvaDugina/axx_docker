#!/bin/bash

echo "*************************************"
echo "Создание дампа..." 

# Загрузка переменных из .env файла
set -a
# source /.env
while IFS= read -r line; do
    echo "$line" | sed 's/[[:space:]]*$//'  # Удаляем пробелы в конце строки
done < /.env > temp_env && source temp_env
set +a

# Параметры подключения к базе данных
DB_HOST=$POSTGRES_HOST
DB_PORT=$POSTGRES_INNER_PORT
DB_USER=$POSTGRES_USER
DB_NAME=$POSTGRES_DB
DB_PASSWORD=$POSTGRES_PASSWORD
BACKUP_DIR=$POSTGRES_BACKUP_DIR

# Устанавливаем пароль для psql
export PGPASSWORD=$DB_PASSWORD

# Дата и время для имени файла дампа
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DUMP_FILE="$BACKUP_DIR/dump_$TIMESTAMP.sql"

# echo "DUMP_FILE: $DUMP_FILE" 

# echo "Скрипт ДАМПА: pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -F c -b -v -f $DUMP_FILE"

# Создаем дамп всех таблиц
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -C -W -E UTF8 -d $DB_NAME -f "$DUMP_FILE"
# pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -F c -b -v --encoding=UTF8 -f "$DUMP_FILE"
# pg_dump -h <ВАШ_ХОСТ> -U accelerator -C -W -E UTF8 -d <ВАША_БД> -f schemas.dump
# pg_dump -U $DB_USER -d $DB_NAME -F c -b -v -f "$DUMP_FILE"

echo "Дамп базы данных создан: $DUMP_FILE"
echo "==================================="