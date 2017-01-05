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
