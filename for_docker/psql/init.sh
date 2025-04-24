#!/bin/bash
set -e 

echo "------------------------------------------------------------"
echo "------------------------------------------------------------"

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

    for sql in /sql_dump/update_*.sql; 
    do
        echo "$sql"
        psql -U postgres -d accelerator -f "$sql"
        echo "------------------------------------------------------------"
    done

    exit 1
fi

LATEST_FILE=$(ls -t "$BACKUP_DIR" | head -n 1)

echo "$BACKUP_DIR/$LATEST_FILE"
psql -U postgres -f $BACKUP_DIR/$LATEST_FILE
echo "------------------------------------------------------------"

# psql -U postgres -c "CREATE DATABASE test_db;"
# psql -U postgres -c "CREATE DATABASE accelerator;"


# psql -U postgres -f /psql.dump

# echo "Databases created and dump restored!"


