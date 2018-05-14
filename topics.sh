#!/bin/bash

waits=60
count=0
step=5
failed=false
while netstat -lnt | awk '$4 ~ /:'$KAFKA_PORT'$/ {exit 1}'; do
    sleep $step;
    count=$(expr $count + $step)
    if [ $count -gt $waits ]; then
        failed=true
        break
    fi
done

if $failed; then
    echo "Timed out waiting for Kafka."
    exit 1
fi

if [[ -n $TOPICS ]]; then
    IFS=','; for topic in $TOPICS; do
        JMX_PORT='' kafka-topics.sh --create --zookeeper localhost:$ZK_PORT --topic "$topic" --replication-factor 1 --partitions 1 --if-not-exists
    done
fi
