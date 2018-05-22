#!/usr/bin/env bash

# usage
# sh write-test.sh 10 http://altered-oyster-kairosdb-app greg2 1000 1000 50
# sh write-test.sh 1 http://altered-oyster-kairosdb-app greg1 4 100 50
# sh write-test.sh 10 http://altered-oyster-kairosdb-app greg2 4 100 50
# sh write-test.sh 100 http://altered-oyster-kairosdb-app greg3 1000 1000 50

JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4
DEVICES=$5
VOLUMES=$6

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
