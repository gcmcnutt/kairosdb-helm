#!/usr/bin/env bash

# TODO need a better way to have kairos wait for scylladb
sleep 15

sed -e "s/@@SEEDS@@/${SEEDS}/g" \
    -e "s/@@REPLICATION_FACTOR@@/${REPLICATION_FACTOR}/g" \
    -e "s/@@DEFAULT_TTL@@/${DEFAULT_TTL}/g" \
    -e "s/@@MEMORY_QUEUE_SIZE@@/${MEMORY_QUEUE_SIZE}/g" \
    -e "s/@@QUEUE_PROCESSOR@@/${QUEUE_PROCESSOR}/g" \
    /opt/kairosdb/templates/base.kairosdb.properties > /opt/kairosdb/conf/kairosdb.properties

exec /opt/kairosdb/bin/kairosdb.sh run