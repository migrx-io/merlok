# Steps to delete data on cassandra nodes

These steps are valid and were tested on Melrok databases for 2 tables:

- metric
- resampled_metric

It should be applied only for that case on that particular data and cluster.

## Prerequisites


- Garbage collection process might significantly impact cluster performance, so the below steps should be run node by node and table by table. **Start from metric table and then repeat steps for resampled_metric**

- Choose the right operational window with minimal workload

- Before starting the process, data should be backed up and stored outside the cluster.

- Snapshots should be deleted on the node to allow for the release of disk space for completed SSTables. Current disk utilization doesn't allow for hosting snapshots and new SSTables."


## Steps (on all nodes)

1. Connect to Cassandra node 

2. Copy and execute the delete partitions script (located at ./scripts).

*It should be run only once from one node. There's no need to perform these steps on all nodes in the cluster*

```
pip install cassandra-driver==3.29.0

LOGLEVEL=INFO python delete_partition.py <CASSANDRA_NODE_IP> melrokdb metric > metric.log 2>&1 &

```

3. Flush deletes

```
nodetool flush melrokdb metric
```

4. Set performance parameters 

```
nodetool setcompactionthroughput 150 
nodetool setconcurrentcompactors 20

```

5. Run garbage collection

```
nodetool garbagecollect melrokdb metric -j 0  > /tmp/metric_gc.log 2>&1 &
```

6. Check running status and progress

*Average time to complete: metric (~35h) resampled_metric (~70h)*


```
nodetool compactionstats
```

7. (Optional) Don't forget to monitor EC2 Instance and EBS Volume performance in CloudWatch and/or create Alerts to allow reacting timely if needed

