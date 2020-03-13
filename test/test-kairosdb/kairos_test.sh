#!/bin/bash

set -xe

HOST=$1

now=`date +"%s"`

curl -X POST -d @kairos_insert.txt http://$HOST/api/v1/datapoints --header "Content-Type:application/json"
curl -X POST -d @kairos_query.txt http://$HOST/api/v1/datapoints/query --header "Content-Type:application/json"
sed "s/@@now@@/$now/g" combined_insert.txt | curl -X POST -d @- http://$HOST/api/v1/datapoints --header "Content-Type:application/json"
curl -X POST -d @combined_query.txt http://$HOST/api/v1/datapoints/query --header "Content-Type:application/json"
