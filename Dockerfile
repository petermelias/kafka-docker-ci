FROM anapsix/alpine-java

ARG kafka_ver=1.0.0
ARG scala_ver=2.11
ARG topics="default_topic"
ARG ap_mirror=http://mirrors.sonic.net/apache/
ARG ktar=$ap_mirror/kafka/$kafka_ver/kafka_$scala_ver-$kafka_ver.tgz

ENV KAFKA_MNT=/kafka
ENV KAFKA_LOG_DIRS=$KAFKA_MNT/logs
ENV KAFKA_HEAP_OPTS="-Xms512m -Xmx1g"

RUN apk add --update unzip wget curl jq coreutils

RUN mkdir /kafka

RUN wget -q "$kar" -O /tmp/kafka.tgz
RUN tar xfz /tmp/kafka.tgz -C /kafka
RUN rm -f /tmp/kafka.tgz

VOLUME $KAFKA_MNT

wget -q "https://github.com/petermelias/kafka-docker-travis/blob/master/boot.sh" -O $KAFKA_MNT/boot.sh
RUN chmod +x $KAFKA_MNT/boot.sh

WORKDIR $KAFKA_MNT
CMD ["boot.sh"]
