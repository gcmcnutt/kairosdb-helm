#KairosDB (with embedded ScyllaDB)

**Important**  For now, install with --set replicaCount=0 to launch scylladb before kairos, then change replication factor for kairos to launch itr

## Starting instructions

### minikube
```aidl
helm install helm/kairosdb
# endpoint will be a node port
```
### aws
```aidl
helm install -f helm/aws-dev.yaml ...
# endpoint is an internal AWS ELB
```

## Features
- Minikube
- AWS environments
- Uses PVCs
- Goal is docker images don't need patching for config changes

## Monitoring
- Can run nodetool on the actual nodes (as JMX is presently localhost only)
- various metrics in kairos itself (kairosdb.*) indicate health of TSDB

## TODO
### scylla
- get rid of the start-scylla script -- do config map and injection instead
- Fix the background tasks method of start -- maybe two containers...
- Add in liveness checks for health check
- Smarter sparse list for seed protocol (or just new a new provider)
- There seems to be some root file system writes on scylladb during large ingest
- **Intermittent**: A new cluster doesn't always seem to have all nodes join.  Feels like something with the dns entries not yet showing up...
- Need to use the Ec2Snitch or something so that rack is to the AZ
- Verify that a pod shutdown command does graceful shutdown of scylladb (catch signal, etc)
- Improve some config based on https://www.youtube.com/watch?v=Y-6qilMBr7A&amp=&t=0s&amp=&index=11

### kairos
- maybe make kairos a stateful set so we can preserve the file queue
  - kairos queue directory is tmpfile and needs to be on a private volume
- will want a kairosDB backlog alarm based on the file queue...
- try to run float instead of double or long... - see the impact on throughput
- how to control memory usage (it may need jvm container hint)

### benchmark
- scale the time scale so we can use ttl effectively on long running tests
- rethink rate control so we can govern throughput
- create a read load