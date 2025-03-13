#!/bin/bash
set -e 

echo "scheme_rights.sql"
psql -U postgres -f /sql_dump/scheme_rights.sql
echo "------------------------------------------------------------"

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


# psql -U postgres -c "CREATE DATABASE test_db;"
# psql -U postgres -c "CREATE DATABASE accelerator;"


# psql -U postgres -f /psql.dump

# echo "Databases created and dump restored!"


