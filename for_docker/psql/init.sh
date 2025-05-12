#!/bin/bash
set -e 

echo "------------------------------------------------------------"
echo "------------------------------------------------------------"

# Функция для разделения строки и склеивания
split_and_join() {
    local input_string="$1"
    local delimiter="$2"
    local join_delimiter="$3"
    
    # Разбиваем строку в массив
    IFS="$delimiter" read -ra array <<< "$input_string"
    
    # Склеиваем массив обратно в строку
    local result=""
    for element in "${array[@]}"; do
        if [ -z "$result" ]; then
            result="$element"
        else
            result+="$join_delimiter$element"
        fi
    done
    
    echo "$result"
}

# Функция для извлечения элемента по индексу после разделения
split_and_get_element_by_index() {
    local input_string="$1"
    local delimiter="$2"
    local index="$3"
    
    # Разбиваем строку в массив
    IFS="$delimiter" read -ra array <<< "$input_string"
    
    # Проверяем существование индекса
    if [ "$index" -ge 0 ] && [ "$index" -lt "${#array[@]}" ]; then
        echo "${array[$index]}"
    else
        echo "Ошибка: индекс $index вне границ массива (0-$(( ${#array[@]} - 1 )))" >&2
        return 1
    fi
}

apply_updates() {
    local integer_date_last_backup=$1

    if [ $# -eq 0 ]; then
        for sql in /sql_dump/update_*.sql; 
        do
            echo "$sql"
            psql -U postgres -d accelerator -f "$sql"
            echo "------------------------------------------------------------"
        done
        return 0
    fi

    for sql in /sql_dump/update_*.sql; 
    do
        # Вытаскивает дату из update
        basename=$(basename $sql)
        date=$(split_and_get_element_by_index "$basename" "_" 1)
        date_without_ext=$(split_and_get_element_by_index "$date" "." 0)
        integer_date_without_ext=$((date_without_ext))

        # Применяем только апдейты, которые позже бэкапа 
        if [ "$integer_date_without_ext" -ge "$integer_date_last_backup" ]; then
            echo "$sql"
            psql -U postgres -d accelerator -f "$sql"
            echo "------------------------------------------------------------"
        fi
    done

    return 0
}

BACKUP_DIR="/backups"

echo "scheme_rights.sql"
psql -U postgres -f /sql_dump/scheme_rights.sql
echo "------------------------------------------------------------"

# Проверяем, пуста ли директория
if [ -z "$(ls -A "$BACKUP_DIR")" ]; then

    echo "scheme_grant.sql"
    psql -U postgres -f /sql_dump/scheme_grant.sql
    echo "------------------------------------------------------------"

    echo "scheme_testData_live_221212.sql"
    psql -U postgres -d accelerator -f /sql_dump/scheme_testData_live_221212.sql
    echo "------------------------------------------------------------"

    apply_updates

    exit 0
fi

LATEST_FILE=$(ls -t "$BACKUP_DIR" | head -n 1)

echo "$BACKUP_DIR/$LATEST_FILE"
psql -U postgres -f $BACKUP_DIR/$LATEST_FILE
echo "------------------------------------------------------------"


DATE_LAST_BACKUP=$(split_and_get_element_by_index "$LATEST_FILE" "_" 1)
echo "ДАТА ПРИМЕНЕННОГО БЭКАПА: $DATE_LAST_BACKUP"

DATE_LAST_BACKUP_JOINED=$(split_and_join "$DATE_LAST_BACKUP" "-" "")

apply_updates $(($DATE_LAST_BACKUP_JOINED))


