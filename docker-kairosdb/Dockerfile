FROM openjdk:8-jdk

RUN	apt-get update
RUN apt-get install -y wget dnsutils

RUN wget -qO /tmp/kairosdb-1.2.0-1.tar.gz \
    https://github.com/kairosdb/kairosdb/releases/download/v1.2.0/kairosdb-1.2.0-1.tar.gz

RUN mkdir -p /opt/ && \
    cd /opt/ && \
    tar -xf /tmp/kairosdb*

ADD logback.xml /opt/kairosdb/conf/logging/logback.xml

# Kairos API telnet and jetty ports
EXPOSE 4242 8080

ENTRYPOINT ["/opt/kairosdb/bin/kairosdb.sh", "run"]
