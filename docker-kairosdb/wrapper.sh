#!/usr/bin/env bash

# TODO need a better way to have kairos wait for scylladb
sleep 15

# TODO would be better as an init container
sed -e "s/@@HOSTNAME@@/${MY_POD_NAME}/g" /opt/kairosdb/conf/kairosdb.properties.base > /opt/kairosdb/conf/kairosdb.properties

exec /opt/kairosdb/bin/kairosdb.sh run