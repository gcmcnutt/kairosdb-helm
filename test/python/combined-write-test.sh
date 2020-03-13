#!/usr/bin/env bash

# usage

# sh test/python/combined-write-test.sh 20 http://10.16.65.116 greg1 500 1000 10
# sh test/python/combined-write-test.sh 25 http://lame-macaw-kairosdb-app greg1 840 80 50
# sh test/python/combined-write-test.sh 5 http://impressive-pronghorn-kairosdb-app greg1 840 80 50
# sh test/python/combined-write-test.sh 10 http://10.16.65.116 greg1 840 80 50

# KAIROS=http://10.16.65.121 python combined_bulk_write.py

# sh test/python/combined-write-test.sh 10 http://10.136.24.11 greg1 840 80 50
# sh test/python/combined-write-test.sh 20 http://musty-chimp-kairosdb-app greg1 840 80 50
# sh test/python/combined-write-test.sh 10 http://piquant-dragonfly-kairosdb-app greg1 840 80 50


JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4
DEVICES=$5
VOLUMES=$6

METRIC_WRITE_RATE=1000
REAL_TTL_SEC=259200
METRICS=3

IMAGE=gcmcnutt/ktest:combined4

for i in $(seq 1 $JOBS)
do
 run=$NAME-$i
 kubectl \
    --image $IMAGE \
    --restart=Never \
    --labels=group=$NAME,agent=$i \
    --requests=cpu=100m,memory=50Mi \
    run $run -- sh -c "KAIROS=$KAIROS METRIC_BASE=$run HOURS=$HOURS DEVICES=$DEVICES VOLUMES=$VOLUMES METRIC_WRITE_RATE=$METRIC_WRITE_RATE METRICS=$METRICS REAL_TTL_SEC=$REAL_TTL_SEC python combined_bulk_write.py"
done
