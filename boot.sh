#!/bin/bash

zkServer.sh start
topics.sh &

exec kafka-server-start.sh config/server.properties
