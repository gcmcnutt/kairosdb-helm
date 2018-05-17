FROM openjdk:8-jdk

RUN	apt-get update

# TODO something changed in upstream packages... (and kairos doesn't work in java9 yet)
RUN apt-mark hold cron

RUN apt-get install -y wget dnsutils sysstat net-tools

RUN wget -qO /tmp/kairosdb-1.2.0-1.tar.gz \
    https://github.com/kairosdb/kairosdb/releases/download/v1.2.0/kairosdb-1.2.0-1.tar.gz

RUN mkdir -p /opt/ && \
    cd /opt/ && \
    tar -xf /tmp/kairosdb*

ADD logback.xml /opt/kairosdb/conf/logging/logback.xml
ADD kairosdb.properties.base /opt/kairosdb/conf
ADD wrapper.sh /wrapper.sh

# Kairos API telnet and jetty ports
EXPOSE 4242 8080

ENTRYPOINT ["sh", "/wrapper.sh"]
