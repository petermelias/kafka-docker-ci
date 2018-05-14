#!/bin/bash

zkServer.sh start
topics.sh &

printf "listeners=PLAINTEXT://localhost:$KAFKA_PORT" >> config/server.properties

exec kafka-server-start.sh config/server.properties
