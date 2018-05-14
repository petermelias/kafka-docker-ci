FROM anapsix/alpine-java

ARG kafka_ver=1.0.0
ARG kafka_port=9092
ARG scala_ver=2.11
ARG zk_ver=3.4.10
ARG zk_port=2181
ARG ap_mirror=http://mirrors.sonic.net/apache/
ARG ktar=$ap_mirror/kafka/$kafka_ver/kafka_$scala_ver-$kafka_ver.tgz
ARG ztar=$ap_mirror/zookeeper/zookeeper-$zk_ver/zookeeper-$zk_ver.tar.gz
ARG repo=https://raw.githubusercontent.com/petermelias/kafka-docker-ci/master/

ENV ZK_ROOT=/zookeeper
ENV ZK_DATA=$ZK_ROOT/data
ENV KAFKA_MNT=/kafka
ENV KAFKA_LOG_DIRS=$KAFKA_MNT/logs
ENV KAFKA_HEAP_OPTS="-Xms512m -Xmx1g"
ENV PATH=$PATH:$KAFKA_MNT/bin:$ZK_ROOT/bin
ENV ZK_PORT=$zk_port
ENV KAFKA_PORT=$kafka_port
ENV TOPICS="default.topic"

RUN apk add --update unzip wget curl jq coreutils tar

RUN mkdir $KAFKA_MNT
RUN mkdir $KAFKA_LOG_DIRS

RUN wget -q $ktar -O /tmp/kafka.tgz
RUN tar xfz /tmp/kafka.tgz -C $KAFKA_MNT --strip-components=1
RUN rm -f /tmp/kafka.tgz

RUN mkdir $ZK_ROOT
RUN mkdir $ZK_DATA
RUN mkdir $ZK_ROOT/conf
RUN wget -q $ztar -O /tmp/zk.tgz
RUN tar xfz /tmp/zk.tgz -C $ZK_ROOT --strip-components=1
RUN rm -f /tmp/zg.tgz
RUN printf "tickTime=2000\ndataDir=$ZK_DATA\nclientPort=2181" > $ZK_ROOT/conf/zoo.cfg

RUN wget -q $repo/boot.sh -O $KAFKA_MNT/bin/boot.sh
RUN chmod +x $KAFKA_MNT/bin/boot.sh
RUN wget -q $repo/topics.sh -O $KAFKA_MNT/bin/topics.sh
RUN chmod +x $KAFKA_MNT/bin/topics.sh

VOLUME $KAFKA_LOG_DIRS
WORKDIR $KAFKA_MNT
CMD ["boot.sh"]
