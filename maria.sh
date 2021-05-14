#!/bin/bash


mariadb<< END_MR
drop database if exists cs315;
create database cs315;
use cs315;
source sql_query/CreateTable_.sql;
load data local infile '$1' into table A fields terminated by ',' ignore 1 lines;
load data local infile '$2' into table B fields terminated by ',' ignore 1 lines;
DROP INDEX \`PRIMARY\` ON A;
DROP INDEX \`PRIMARY\` ON B;
show indexes from B;
show indexes from A;
END_MR


for q in {'A','B','C','D'}
do
    echo "database $1, $2" >> $3/mariadb_${q}.txt
done

for i in {1..7}
do
for q in {'A','B','C'}
do
echo "maria -> query $q iteration:$i"
mariadb <<END_MR > temp.txt
reset query cache;
use cs315; 
source sql_query/dummy.sql;
set profiling=1;
source sql_query/query${q}.sql;
show profiles;
END_MR
awk '/SELECT/ {print $2}' temp.txt >> $3/mariadb_${q}.txt
done

q='D'
if [ $i -le ${4:-7} ]; then
echo "maria -> query $q iteration:$i"
mariadb <<END_MR > temp.txt
use cs315; 
source sql_query/dummy.sql;
set profiling=1;
source sql_query/query${q}.sql;
show profiles;
END_MR
awk '/SELECT/ {print $2}' temp.txt >> $3/mariadb_${q}.txt
fi

done