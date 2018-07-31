#!/usr/bin/env bash

# usage
# sh test/python/read-test.sh 3 http://invisible-hound-kairosdb-app greg4 144000 1000 50
# sh test/python/read-test.sh 3 http://romping-wolf-kairosdb-app greg3 144000 1000 50

JOBS=$1
KAIROS=$2
NAME=$3
TTL=$4
DEVICES=$5
VOLUMES=$6

QUERIES=50000

IMAGE=499918285206.dkr.ecr.us-west-2.amazonaws.com/gmcnutt:lyu17
CONTEXT=aws

for i in $(seq 1 $JOBS)
do
 run=$NAME-$i
 kubectl --context $CONTEXT \
    --image $IMAGE \
    --image-pull-policy=Always \
    --restart=Never \
    --labels=group=$NAME-r,agent=$i \
    --requests=cpu=100m,memory=50Mi \
    run $run-r -- sh -c "KAIROS=$KAIROS QUERIES=$QUERIES METRIC_BASE=$run TTL=$TTL DEVICES=$DEVICES VOLUMES=$VOLUMES python random_read.py"
done
