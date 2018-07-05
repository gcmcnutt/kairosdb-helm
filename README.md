#KairosDB (with embedded ScyllaDB)


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
- Smarter sparse list for seed protocol (or just new a new provider)
- Evaluate inter-node compression settings
- Figure out why serviceName and statefull set name can't be different
- can we get scylla to listen on all ports (so localhost works for kairosdb)?
- there is some crosstalk when two running at once: WARN  2018-05-16 18:30:35,216 [shard 0] gossip - ClusterName mismatch from 172.17.0.7 braided-ibis-kairosdb!=winsome-mite-kairosdb

### kairos
- consider flipping to MemoryQueueProcessor (or make this a help option)
- how to control memory usage (it may need jvm container hint)
- need to include https://github.com/kairosdb/kairos-healthcheck so we don't scan all metrics
- we have a bugfix for don't query TTL > 10year -- need to understand why we need it?
- inject my pod name as an init container instead of in wrapper.sh
- sleep delays in kairos are definitely not the best approach here
- need to change LoadBalancer to point only to our scylladb

### benchmark
- create a read load