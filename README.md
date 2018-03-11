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
  - also ensure that the main process (group) can catch a SIGTERM for gracefull shutdown
  - fix the background tasks method of start -- maybe two containers...
- Add in liveness checks for health check
- Smarter sparse list for seed protocol (or just new a new provider)
- There seems to be some root file system writes on scylladb during large ingest
- **Intermittent**: A new cluster doesn't always seem to have all nodes join.  Feels like something with the dns entries not yet showing up...
  - really what is needed here is kairos shouldn't interfere with scylla while the first nodes are joining
  - workaround is --set replicaCount=0 to stop kairos from starting, first and then upgrade template with target replicaCount
- Evaluate inter-node compression settings

### kairos
- consider flipping to MemoryQueueProcessor (or make this a help option)
- how to control memory usage (it may need jvm container hint)
- need to include https://github.com/kairosdb/kairos-healthcheck so we don't scan all metrics
- we have a bugfix for don't query TTL > 10year -- need to understand why we need it?

### benchmark
- create a read load