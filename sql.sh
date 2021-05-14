#!/bin/bash

if [ -f temp.db ]; then
    rm -rf temp.db
fi

sqlite3 temp.db <<END_SQL > temp.txt
.read sql_query/CreateTable.sql
.mode csv
.import $1 A
.import $2 B
END_SQL

for q in {'A','B','C','D'}
do
    echo "database $1, $2" >> $3/sqlite_${q}.txt
done

for i in {1..7}
do
for q in {'A','B','C'}
do
echo "sql -> query $q iteration:$i"
sqlite3 temp.db <<END_SQL > temp.txt
.read sql_query/dummy.sql
.timer on
.read sql_query/query${q}.sql
END_SQL
awk '/^Run/ {print $4}' temp.txt >> $3/sqlite_${q}.txt
done

q='D'
if [ $i -le ${4:-7} ]; then
echo "sql -> query $q iteration:$i"
sqlite3 temp.db <<END_SQL > temp.txt
.read sql_query/dummy.sql
.timer on
.read sql_query/query${q}.sql
END_SQL
awk '/^Run/ {print $4}' temp.txt >> $3/sqlite_${q}.txt
fi

done
