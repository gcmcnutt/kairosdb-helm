#!/usr/bin/env bash

# usage
# sh test/python/read-test.sh 2 http://nosy-cheetah-kairosdb-app greg6 200 100 50 20
# sh test/python/read-test.sh 2 http://10.16.67.7 greg1 120 1000 50 12

JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4
DEVICES=$5
VOLUMES=$6
WRITERS=$7

QUERIES=50000

IMAGE=gcmcnutt/ktest:lyu19

for i in $(seq 1 $JOBS)
do
 kubectl \
    --image $IMAGE \
    --image-pull-policy=Always \
    --restart=Never \
    --labels=group=$NAME-r,agent=$i \
    --requests=cpu=100m,memory=50Mi \
    run $NAME-$i-r -- sh -c "KAIROS=$KAIROS WRITERS=$WRITERS QUERIES=$QUERIES METRIC_BASE=$NAME HOURS=$HOURS DEVICES=$DEVICES VOLUMES=$VOLUMES python random_read.py"
done
