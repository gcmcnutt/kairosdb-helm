FROM	ubuntu:16.04
RUN	apt-get update
RUN apt-get install -y wget dnsutils sysstat net-tools
RUN	wget -nv -O /etc/apt/sources.list.d/scylla-2.1-xenial.list http://downloads.scylladb.com/deb/ubuntu/scylla-2.1-xenial.list
RUN	apt-get update
RUN	apt-get install -y scylla-server scylla-jmx scylla-tools --force-yes

COPY    start-scylla /start-scylla

EXPOSE 	10000 9042 9160 9180 7000 7001
VOLUME 	/var/lib/scylla

ENTRYPOINT ["/start-scylla"]
