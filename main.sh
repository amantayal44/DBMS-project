#!/bin/bash


# roll no 180074
# a = 0, b = 7, c = 4


rm -rf temp*

if [ -d $1 ]; then
    rm -rf $1
fi

mkdir $1

A="dbs/A-100.csv"
for B in {"dbs/B-100-3-0.csv","dbs/B-100-5-0.csv","dbs/B-100-10-0.csv"}
do
    echo "sql $A,$B"
    bash sql.sh $A $B $1
    echo "maria $A,$B"
    bash maria.sh $A $B $1
    echo "maria with index $A,$B"
    bash maria_index.sh $A $B $1
    echo "mongo $A,$B"
    bash mongo.sh $A $B $1
done

A="dbs/A-1000.csv"
for B in {"dbs/B-1000-5-0.csv","dbs/B-1000-10-4.csv","dbs/B-1000-50-3.csv"}
do
    echo "sql $A,$B"
    bash sql.sh $A $B $1
    echo "maria $A,$B"
    bash maria.sh $A $B $1
    echo "maria with index $A,$B"
    bash maria_index.sh $A $B $1
    echo "mongo $A,$B"
    bash mongo.sh $A $B $1
done

A="dbs/A-10000.csv"
for B in {"dbs/B-10000-5-0.csv","dbs/B-10000-50-3.csv","dbs/B-10000-500-1.csv"}
do
    echo "sql $A,$B"
    bash sql.sh $A $B $1
    echo "maria with index $A,$B"
    bash maria_index.sh $A $B $1

done

# mongo and maria on 100000 (as its slow)

# 5 runs for B-10000-500 on mongo
A="dbs/A-10000.csv"

B="dbs/B-10000-5-0.csv"
echo "maria $A,$B"
bash maria.sh $A $B $1
echo "mongo $A,$B"
bash mongo.sh $A $B $1

B="dbs/B-10000-50-3.csv"
echo "maria $A,$B"
bash maria.sh $A $B $1
echo "mongo $A,$B"
bash mongo.sh $A $B $1

B="dbs/B-10000-500-1.csv"
echo "maria $A,$B"
bash maria.sh $A $B $1
echo "mongo $A,$B"
bash mongo.sh $A $B $1 5