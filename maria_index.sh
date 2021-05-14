#!/bin/bash

mariadb<< END_MR
drop database if exists cs315;
create database cs315;
use cs315;
source sql_query/CreateTable.sql;
load data local infile '$1' into table A fields terminated by ',' ignore 1 lines;
load data local infile '$2' into table B fields terminated by ',' ignore 1 lines;
CREATE INDEX SORT on B(B3 ASC,B1,B2);
show indexes from B;
show indexes from A;
END_MR

for q in {'A','B','C','D'}
do
    echo "database $1, $2" >> $3/mariadb_index_${q}.txt
done

for i in {1..7}
do
for q in {'A','B','C'}
do
echo "maria_index -> query $q iteration:$i"
mariadb <<END_MR > temp.txt
reset query cache;
use cs315;
source sql_query/dummy.sql;
set profiling=1;
source sql_query/query${q}.sql;
show profiles;
END_MR
awk '/SELECT/ {print $2}' temp.txt >> $3/mariadb_index_${q}.txt
done

q='D'
if [ $i -le ${4:-7} ]; then
echo "maria_index -> query $q iteration:$i"
mariadb <<END_MR > temp.txt
use cs315;
source sql_query/dummy.sql;
set profiling=1;
source sql_query/query${q}.sql;
show profiles;
END_MR
awk '/SELECT/ {print $2}' temp.txt >> $3/mariadb_index_${q}.txt
fi

done
