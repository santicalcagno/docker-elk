#!/bin/sh

# W_VALUES=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 )
# B_VALUES=( 1 2 4 8 16 32 64 125 250 500 1000 1250 )
#
# sed -i -e "s/-w [0-9]*/-w $1/" docker-compose.yml
# sed -i -e "s/-b [0-9]*/-b $2/" docker-compose.yml

echo 'Starting Docker image...'
docker-compose up &
DOCKER_PID=$!

sleep 50

echo 'Starting monitoring script'
sh ./gatherdata.sh &
GATHER_PID=$!

echo 'Injecting logs...'
python jlog.py
echo 'Injection finished'

echo 'Killing monitoring script and cleaning Elasticsearch'
kill $GATHER_PID && curl -s -XDELETE 'http://localhost:9200/_all'
sleep 5
echo 'Shutting down image'
kill $DOCKER_PID
sleep 10
