#!/bin/bash

echo "*************************************"
echo "Создание дампа..." 

# Загрузка переменных из .env файла
set -a
while IFS= read -r line; do
    echo "$line" | sed 's/[[:space:]]*$//'  # Удаляем пробелы в конце строки
done < /.env > tmp_env && source tmp_env
set +a

# Параметры подключения к базе данных
DB_HOST=$POSTGRES_HOST
DB_PORT=$POSTGRES_INNER_PORT
DB_USER=$POSTGRES_USER
DB_NAME=$POSTGRES_DB
DB_PASSWORD=$POSTGRES_PASSWORD
BACKUP_DIR=/backups

# Устанавливаем пароль для psql
export PGPASSWORD=$DB_PASSWORD

# Дата и время для имени файла дампа
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DUMP_FILE="$BACKUP_DIR/dump_$TIMESTAMP.sql"

# Создаем дамп всех таблиц
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -C -W -E UTF8 -d $DB_NAME -f "$DUMP_FILE"

echo "Дамп базы данных создан: $DUMP_FILE"


# # ОЧИСТКА лишних дампов 
# while true; do

#     # Получаем количество файлов в директории
#     FILE_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type f | wc -l)

#     # Проверяем, меньше ли количество файлов 5
#     if [ "$FILE_COUNT" -le 5 ]; then
#         break
#         exit 1
#     fi

#     # Получаем первый файл по времени модификации
#     EARLIEST_FILE=$(ls -1t "$BACKUP_DIR" | tail -n 1)

#     # Удаляем файл
#     rm "$BACKUP_DIR/$EARLIEST_FILE"

#     # Проверяем, успешно ли удален файл
#     if [ $? -eq 0 ]; then
#         echo "Файл $EARLIEST_FILE успешно удален."
#     else
#         echo "Ошибка при удалении файла $EARLIEST_FILE."
#     fi

# done