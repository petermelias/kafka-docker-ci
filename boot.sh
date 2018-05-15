#!/bin/bash

zkServer.sh start
topics.sh &

# printf "\nlisteners=PLAINTEXT://127.0.0.1:$KAFKA_PORT\n" >> config/server.properties
printf "\nadvertised.listeners=PLAINTEXT://127.0.0.1:$KAFKA_PORT\n" >> config/server.properties

exec kafka-server-start.sh config/server.properties
