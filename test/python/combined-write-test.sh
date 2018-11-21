#!/usr/bin/env bash

# usage

# sh test/python/combined-write-test.sh 20 http://10.16.65.118 greg1 500 1000 10

JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4
DEVICES=$5
VOLUMES=$6

METRIC_WRITE_RATE=4000
REAL_TTL_SEC=259200

IMAGE=gcmcnutt/ktest:combined4

for i in $(seq 1 $JOBS)
do
 run=$NAME-$i
 kubectl \
    --image $IMAGE \
    --image-pull-policy=Always \
    --restart=Never \
    --labels=group=$NAME,agent=$i \
    --requests=cpu=100m,memory=50Mi \
    run $run -- sh -c "KAIROS=$KAIROS METRIC_BASE=$run HOURS=$HOURS DEVICES=$DEVICES VOLUMES=$VOLUMES METRIC_WRITE_RATE=$METRIC_WRITE_RATE REAL_TTL_SEC=$REAL_TTL_SEC python combined_bulk_write.py"
done
