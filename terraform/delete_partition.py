# 
# LOGLEVEL=INFO python delete_partition.py 10.100.11.94 melrokdb metric|resampled_metric
# 


from cassandra.cluster import Cluster
from cassandra.query import ConsistencyLevel
import logging as log 
import time
import os
import sys

log.basicConfig()


def load_acc_and_year(path):

    res = []

    with open(path) as f:
        data = f.read()

        log.debug("data: %s", data)
        for line in data.split("\n"):
            log.debug("line: %s", line)
            row = line.split(",")
            if len(row) < 2:
                continue
            log.debug("load_acc_and_year: row: %s", row)
            res.append({"account": int(row[0]), "year": int(row[1])})


    return res



def load_acc_to_metric(path):

    res = {}

    with open(path) as f:
        data = f.read()

        for line in data.split("\n"):
            row = line.split(",")
            log.debug("load_acc_to_metric: row: %s", row)

            if len(row) < 2:
                continue
 
            if res.get(row[1]) is None:
                res[row[1]] = [row[0]]
            else:
                res[row[1]].append(row[0])

    return res


def delete_metric(session, account_id, year, metric_id):
    sql = "DELETE FROM metric WHERE account_id = {} AND year = {} and metric_id = '{}'".format(account_id, year, metric_id)

    log.info("delete_metric: sql: %s", sql)
    session.execute(sql)

def delete_resampled(session, account_id, year, metric_id):

    sql = "DELETE FROM resampled_metric WHERE accountid = {} AND year = {} and metricid = '{}'".format(account_id, year, metric_id)

    log.ingo("delete_resampled: sql: %s", sql)
    session.execute(sql)



def main():
 
    log.getLogger().setLevel(os.environ.get("LOGLEVEL", "INFO"))

    node = sys.argv[1]
    ks = sys.argv[2]
    table = sys.argv[3]

    log.info("Connect to node:%s keyspace:%s table:%s")

    cluster = Cluster([node])
    session = cluster.connect(ks)

    session.default_consistency_level = ConsistencyLevel.ALL

    acc_and_year = load_acc_and_year("accountAndYear.csv")
    log.debug("acc_and_year: %s", acc_and_year)

    acc_to_metric = load_acc_to_metric("accountToMetricId.csv")
    log.debug("acc_to_metric: %s", acc_to_metric)


    for item in acc_and_year:
        log.info("start deletion for item: %s", item)

        metric_ids = acc_to_metric.get(str(item["account"])) 

        if metric_ids is None:
            log.info("no metrics for account: %s", item["account"])
            continue

        tb = time.time()
        for m in metric_ids:
            log.debug("delete partitiont account_id: %s year: %s metric_id: %s", item["account"], item["year"], m)

            if table == "metric":
                # del metric
                delete_metric(session, item["account"], item["year"], m)
            elif table == "resampled_metric":
                # del metric
                delete_resampled(session, item["account"], item["year"], m)

        log.info("partition for table: %s item: %s is deleted. elapsed(sec): %s", table, item, time.time() - tb)


if  __name__ == "__main__":
    main()
