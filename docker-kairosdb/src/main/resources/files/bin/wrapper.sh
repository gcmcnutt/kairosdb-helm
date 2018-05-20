#!/usr/bin/env bash

# TODO need a better way to have kairos wait for scylladb
sleep 15

sed -e "s/@@SEEDS@@/${SEEDS}/g" \
    -e "s/@@REPLICATION_FACTOR@@/${REPLICATION_FACTOR}/g" \
    /opt/kairosdb/conf/kairosdb.properties.base > /opt/kairosdb/conf/kairosdb.properties

exec /opt/kairosdb/bin/kairosdb.sh run