#!/bin/sh

W_VALUES=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 )
B_VALUES=( 16 32 64 125 250 500 1000 1250 )


for w in "${W_VALUES[@]}"
do
  for b in "${B_VALUES[@]}"
  do
    sed -i -e "s/-w [0-9]*/-w $w/" docker-compose.yml
    sed -i -e "s/-b [0-9]*/-b $b/" docker-compose.yml
    echo 'Starting Docker image...'
    docker-compose up &
    DOCKER_PID=$!

    sleep 50

    echo 'Starting monitoring script'
    echo '--------------------' >> data.txt
    echo "Workers: $w" >> data.txt
    echo "Batch size: $b" >> data.txt
    echo '--------------------' >> data.txt
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
  done
done
