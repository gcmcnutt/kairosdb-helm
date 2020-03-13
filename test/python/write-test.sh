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

# sh test/python/write-test.sh 10 http://torrid-zebra-kairosdb-app greg1 100 100 50
# sh test/python/write-test.sh 20 http://nosy-cheetah-kairosdb-app greg6 200 100 50
# sh test/python/write-test.sh 20 http://invited-buffalo-kairosdb-app greg6 200 100 50

# sh test/python/write-test.sh 10 http://odd-seagull-kairosdb-app:8080 greg1 200 100 50
# sh test/python/write-test.sh 20 http://10.16.65.108 greg1 500 1000 50

# sh test/python/write-test.sh 30 http://10.16.67.7 greg1 100 1000 50

# sh test/python/write-test.sh 10 http://mortal-dragonfly-kairosdb-app greg1 100 100 50

JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4
DEVICES=$5
VOLUMES=$6

METRIC_WRITE_RATE=2000
REAL_TTL_SEC=259200

IMAGE=gcmcnutt/kairosdb-test:1

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
