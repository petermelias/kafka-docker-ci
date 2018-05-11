FROM anapsix/alpine-java

ARG kafka_ver=1.0.0
ARG scala_ver=2.11
ARG topics="default_topic"
ARG ap_mirror=http://mirrors.sonic.net/apache/
ARG ktar=$ap_mirror/kafka/$kafka_ver/kafka_$scala_ver-$kafka_ver.tgz

ENV KAFKA_MNT=/kafka
ENV KAFKA_LOG_DIRS=$KAFKA_MNT/logs
ENV KAFKA_HEAP_OPTS="-Xms512m -Xmx1g"
ENV PATH=$PATH:$KAFKA_MNT/bin

RUN apk add --update unzip wget curl jq coreutils tar

RUN mkdir $KAFKA_MNT
RUN mkdir $KAFKA_LOG_DIRS

RUN wget -q $ktar -O /tmp/kafka.tgz
RUN tar xfz /tmp/kafka.tgz -C $KAFKA_MNT --strip-components=1
RUN rm -f /tmp/kafka.tgz

RUN wget -q https://raw.githubusercontent.com/petermelias/kafka-docker-travis/master/boot.sh -O $KAFKA_MNT/bin/boot.sh
RUN chmod +x $KAFKA_MNT/bin/boot.sh

VOLUME $KAFKA_LOG_DIRS
WORKDIR $KAFKA_MNT
CMD ["boot.sh"]
