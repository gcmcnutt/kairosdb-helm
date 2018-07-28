#!/usr/bin/env bash

# usage
# sh test/python/kubecwrite-test.sh 10 http://altered-oyster-kairosdb-app greg2 1000 1000 50
# sh test/python/write-test.sh 1 http://altered-oyster-kairosdb-app greg1 4 100 50
# sh test/python/write-test.sh 10 http://altered-oyster-kairosdb-app greg2 4 100 50
# sh test/python/write-test.sh 100 http://bumptious-tiger-kairosdb-app greg2 1000 1000 50
# sh test/python/write-test.sh 10 http://honking-sasquatch-kairosdb-app greg1 4 100 50
# sh test/python/write-test.sh 20 http://honking-sasquatch-kairosdb-1.honking-sasquatch-kairosdb.gmcnutt.svc.cluster.local:8080 greg6 4 100 50
# sh test/python/write-test.sh 20 http://honking-sasquatch-kairosdb-app greg7 4 100 50

# sh test/python/write-test.sh 10 http://illocutionary-ragdoll-kairosdb-app greg1 4 100 50
# sh test/python/write-test.sh 100 http://illocutionary-ragdoll-kairosdb-app greg2 1000 1000 50
# sh test/python/write-test.sh 100 http://internal-a029bf3c5609f11e8a92c067563aff83-527735186.us-west-2.elb.amazonaws.com greg2 1000 1000 50
# sh test/python/write-test.sh 50 http://virulent-olm-kairosdb-app greg2 100 1000 50

# sh test/python/write-test.sh 1 http://melting-mite-kairosdb-app greg1 4 100 50
# sh test/python/write-test.sh 3 http://queenly-ibex-kairosdb-app greg3 100 1000 50
# sh test/python/write-test.sh 3 http://foolish-antelope-kairosdb-app greg4 100 1000 50

JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4
DEVICES=$5
VOLUMES=$6

METRIC_WRITE_RATE=20000
REAL_TTL_SEC=259200

IMAGE=621123821552.dkr.ecr.us-west-2.amazonaws.com/gmcnutt:lyu16

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