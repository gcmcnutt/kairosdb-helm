#!/usr/bin/env bash

# usage
# sh write-test.sh 3 http://tan-armadillo-kairosdb-app greg1 24

JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4

DEVICES=100
VOLUMES=50
METRIC_WRITE_RATE=20000
REAL_TTL_SEC=259200

IMAGE=621123821552.dkr.ecr.us-west-2.amazonaws.com/gmcnutt:lyu16
#CONTEXT=cluster2.pstg-dev.net

for i in $(seq 1 $JOBS)
do
 run=$NAME-$i
 kubectl \
    --image $IMAGE \
    --image-pull-policy=Always \
    --restart=Never \
    --labels=group=$NAME,agent=$i \
    --requests=cpu=100m,memory=50Mi \
    run $run -- sh -c "KAIROS=$KAIROS METRIC_BASE=$run HOURS=$HOURS DEVICES=$DEVICES VOLUMES=$VOLUMES METRIC_WRITE_RATE=$METRIC_WRITE_RATE REAL_TTL_SEC=$REAL_TTL_SEC python bulk_write.py"
done
