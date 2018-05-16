#!/usr/bin/env bash

# usage
# sh read-test.sh 3 http://plinking-pug-kairosdb-app greg1 24

JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4

DEVICES=100
VOLUMES=50
QUERIES=10000

IMAGE=621123821552.dkr.ecr.us-west-2.amazonaws.com/gmcnutt:lyu13
CONTEXT=cluster1.pstg-dev.net

for i in $(seq 1 $JOBS)
do
 run=$NAME-$i
 kubectl --context $CONTEXT \
    --image $IMAGE \
    --image-pull-policy=Always \
    --restart=Never \
    --labels=group=$NAME-r,agent=$i \
    --requests=cpu=100m,memory=50Mi \
    run $run-r -- sh -c "KAIROS=$KAIROS QUERIES=$QUERIES METRIC_BASE=$run HOURS=$HOURS DEVICES=$DEVICES VOLUMES=$VOLUMES python random_read.py"
done
