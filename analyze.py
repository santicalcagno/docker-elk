import statistics

datafile = open('data.txt')

data = {}
w = 0

for line in datafile:
    if line.startswith('-'):
        wnew = int(next(datafile).split()[1])
        if w != wnew:
            w = wnew
            data[w] = {}
        b = int(next(datafile).split()[2])
        data[w][b] = []
        next(datafile)
    if line.startswith('-'):
        continue
    data[w][b].append(int(line))

avgs = {}
sds = {}
output = []

for w in data:
    avgs[w] = {}
    sds[w] = {}
    for b in data[w]:
        icount = data[w][b]
        indexrates = [j-i for i, j in zip(icount[:-1], icount[1:])]
        avg = sum(indexrates)/len(indexrates)
        avgs[w][b] = avg
        sd = statistics.stdev(indexrates)
        sds[w][b] = sd
        output.append(str(w) + " " + str(b) + " " + str(avg) + " " + str(sd))

output.sort(key=lambda x: (int(x.split()[0]), int(x.split()[1])))
for row in zip(output):
    print (' '.join(row).replace('.',','))
