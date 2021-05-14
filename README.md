# DBMS-project (CS315)
Aman Tayal, 180074

## Usage:

### For time

Copy "dbs" folder in this folder
```
chmod +x *.sh
./main.sh output
```
Note - some query will take very long to run then press ctrl+c

files with time will get stored in output folder

final_output contains time output on macbook pro machine

### For generate table and graphs

install python libraries
```
pip install -r requirements.txt
```

to run output recieved
```
python3 clean.py output
```

to run on final_output ( time on my machine)
```
python3 clean.py final_output
```

create graphs folder with all graphs and table

## Description:
for every database,I have run each query 7 times and before running each query, I also run a dummy query
and clear cache for mariadb

For indexing in mariadb, I have used index on B(B1), B(B2), B(B3) and A(A1)

final_output folder has time output that I got in my machine

final_graph folder has graph and table that I got in my machine

## Note:
this script was run and tested in mac machine, might show some error in linux machine 

