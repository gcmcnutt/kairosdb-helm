#!/bin/bash

HOST=$1

curl -X POST -d @kairos_insert.txt http://$HOST/api/v1/datapoints --header "Content-Type:application/json"
curl -X POST -d @kairos_query.txt http://$HOST/api/v1/datapoints/query --header "Content-Type:application/json"
