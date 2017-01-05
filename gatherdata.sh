# echo 'Waiting for the system to stabilize (60sec)'
# sleep 60
while :
do
  echo 'Gathering data...'
  curl -s -XGET localhost:9200/_cat/indices | tail +2 | awk '{print $7}' >> data.txt
  sleep 1
done
