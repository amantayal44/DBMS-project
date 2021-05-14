#!/bin/bash

mongo < mongo_query/DropTable.js >> temp1.txt
mongoimport --type csv -d cs315 -c A  --headerline --drop $1 >> temp1.txt 
mongoimport --type csv -d cs315 -c B  --headerline --drop $2 >> temp1.txt



for q in {'A','B','C','D'}
do
    echo "database $1, $2" >> $3/mongo_${q}.txt
done

for i in {1..7}
do
for q in {'A','B','C'}
do
echo "mongo -> query $q iteration:$i"
mongo < mongo_query/query${q}.js > temp.txt
awk '/\"executionTimeMillis\"/ {print $3}' temp.txt >> $3/mongo_${q}.txt
done

q='D'
if [ $i -le ${4:-7} ]; then
echo "mongo -> query $q iteration:$i"
mongo < mongo_query/query${q}.js > temp.txt
awk '/\"executionTimeMillis\"/ {print $3}' temp.txt >> $3/mongo_${q}.txt
fi

done
