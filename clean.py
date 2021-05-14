import os
import matplotlib.pyplot as plt
import pandas as pd
import sys
import dataframe_image as dfi

if len(sys.argv) != 2:
    print("give correct arguments")
    exit(-1)

folder =sys.argv[1]
files = ["sqlite","mariadb","mariadb_index","mongo"]
query = ["A","B","C","D"]
output_folder = "graphs"
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

data = {}
a = " "
b = " "
for q in query:
    data[q] = {}
    for file in files:
        filename = file+"_"+q+".txt"
        path = os.path.join(folder,filename)
        with open(path,'r') as f:
            for line in f:
                line = line.rstrip("\n")
                t = line.split(" ")
                if t[0] == "database":
                    a = t[1].split(",")[0][4:-4]
                    b = t[2][4:-4]
                    if (a,b) not in data[q].keys():
                        data[q][a,b] = {}
                    data[q][a,b][file] = []
                else:
                    t = line.split(",")[0]
                    if(file != "mongo"): time = float(t)*1000
                    else: time = float(t)
                    time = int(round(time,0))
                    data[q][a,b][file].append(time)


def mean_std(times):
    t = times.copy()
    if len(t)>=5:
        t.remove(min(t))
        t.remove(max(t))
    mean = round(float(sum(t))/len(t),2)
    if len(t) == 1:
        std = None
    else: std = round((sum([(i-mean)**2 for i in t])/(len(t)-1))**0.5,2)
    return [mean,std]



graph_mean = {}
graph_std = {}
tables = {}
index = [[],[]]

db = [
    ("A-100","B-100-3-0"),
    ("A-100","B-100-5-0"),
    ("A-100","B-100-10-0"),
    ("A-1000","B-1000-5-0"),
    ("A-1000","B-1000-10-4"),
    ("A-1000","B-1000-50-3"),
    ("A-10000","B-10000-5-0"),
    ("A-10000","B-10000-50-3"),
    ("A-10000","B-10000-500-1"),
]

for q in query:
    graph_mean[q] = {}
    graph_std[q] = {}
    for dbms in files:
        graph_mean[q][dbms] = {"X":[],"Y":[]}
        graph_std[q][dbms] = {"X":[],"Y":[]}
        index[0] += ["query"+q]
        index[1] += [dbms]
 
    for a,b in db:

    
            for dbms in files:
                d = data[q][a,b][dbms]
                v = mean_std(d)
                
                if q == "A":
                    if a in graph_mean[q][dbms]["X"]:
                        i = graph_mean[q][dbms]["X"].index(a)
                        graph_mean[q][dbms]["Y"][i] = v[0]
                        graph_std[q][dbms]["Y"][i] = v[1]
                    else:
                        graph_mean[q][dbms]["X"].append(a)
                        graph_mean[q][dbms]["Y"].append(v[0])
                        graph_std[q][dbms]["X"].append(a)
                        graph_std[q][dbms]["Y"].append(v[1])
                else:
                    graph_mean[q][dbms]["X"].append(b)
                    graph_mean[q][dbms]["Y"].append(v[0])
                    if v[1] is not None:
                        graph_std[q][dbms]["X"].append(b)
                        graph_std[q][dbms]["Y"].append(v[1])



def min_one(Y):
    Y_ = []
    for y in Y:
        Y_.append(max(y,1)) 
    return Y_


def plot_graph(q,type="mean",is_log=True,ticks=None):
    if type=="mean":
        graph = graph_mean.copy()
        title = "Average time taken"
    else:
        graph = graph_std.copy()
        title = "Standard deviation of time taken"
    y_label = "in log scale" if is_log else ""


    markers = ["-o","-s","-^","-p"]
    plt.figure(figsize=(13,8))
    for dbms,marker in zip(files,markers):
        if is_log:
            graph[q][dbms]["Y"] = min_one(graph[q][dbms]["Y"])
        plt.plot(graph[q][dbms]["X"],graph[q][dbms]["Y"],marker,label=dbms)
    
    if is_log: plt.yscale('log')
    plt.yticks(ticks,fontsize=16)
    plt.xticks(fontsize=11)
    plt.ylabel("Time (ms) {}".format(y_label),fontsize=18)
    plt.xlabel("Databases",fontsize=18)
    plt.title("Query {} ({})".format(q,title),fontsize=18)
    plt.legend(prop={'size': 12})
    path = "{}/{}_{}.png".format(output_folder,q,type)
    plt.savefig(path,dpi=300)

plot_graph("A","mean",False)
plot_graph("B","mean")
plot_graph("C","mean")
plot_graph("D","mean")
plot_graph("A","std",False)
plot_graph("B","std",False)
plot_graph("C","std")
plot_graph("D","std")

#plotting graph of time taken by each query in database
a,b = db[-1]
graph_q = {}

for dbms in files:
    graph_q[dbms] = [[],[],[]]
    for q in query:
        v = mean_std(data[q][a,b][dbms])
        graph_q[dbms][0].append("Query"+q)
        graph_q[dbms][1].append(v[0])
        graph_q[dbms][2].append(v[1])

markers = ["-o","-s","-^","-p"]
plt.figure(figsize=(13,8))
for dbms,marker in zip(files,markers):
    graph_q[dbms][1] = min_one(graph_q[dbms][1])
    plt.plot(graph_q[dbms][0],graph_q[dbms][1],marker,label=dbms)

plt.yscale('log')
plt.yticks(fontsize=16)
plt.ylabel("Time (ms) {}".format("in log scale"),fontsize=18)
plt.xlabel("Query",fontsize=18)
plt.title("Average time taken on database {},{}".format(a,b),fontsize=18)
plt.legend(prop={'size': 12})
path = "{}/{}_{}.png".format(output_folder,"query","mean")
plt.savefig(path,dpi=300)

plt.figure(figsize=(13,8))
for dbms,marker in zip(files,markers):
    graph_q[dbms][2] = min_one(graph_q[dbms][2])
    plt.plot(graph_q[dbms][0],graph_q[dbms][2],marker,label=dbms)

plt.yscale('log')
# plt.yticks(ticks)
plt.yticks(fontsize=16)
plt.ylabel("Time (ms) {}".format("in log scale"),fontsize=18)
plt.xlabel("Query",fontsize=18)
plt.title("Standard deviation of time taken on database {},{}".format(a,b),fontsize=18)
plt.legend(prop={'size': 12})
path = "{}/{}_{}.png".format(output_folder,"query","std")
plt.savefig(path,dpi=300)


t = []
for q in query:
    for dbms in files:
        t_ = []
        for a,b in db:
            d = data[q][a,b][dbms]
            v = mean_std(d)
            t_ += [round(v[0]),round(v[1])]
        t.append(t_)


itr = [[d[1] for d in db],["mean","std"]]
itr = pd.MultiIndex.from_product(itr)
df = pd.DataFrame(t, index=index,columns=itr)
dfi.export(df, output_folder+'/table.png')
