from cassandra.cluster import Cluster
import logging as log 
import time


cluster = Cluster(['10.100.11.94'])
session = cluster.connect("melrokdb")

rows = session.execute('SELECT * FROM resampled_metric')

metric  = {"count": 0, "found": 0}

tb = time.time()

DEL_MAP = {
        "2200": 2023,
        "2157": 2023,
        "2157": 2022,
        "2157": 2021,
        "2157": 2020,
        "2102": 2023,
        "2102": 2022,
        "2102": 2021,
        "2102": 2020,
        "2102": 2019,
        "2102": 2018,
        "2102": 2017,
        "2102": 2016,
        "2102": 2015,
        "2160": 2023,
        "2160": 2022,
        "2115": 2023,
        "2115": 2022,
        "2115": 2021,
        "2115": 2020,
        "2115": 2019,
        "2115": 2018,
        "2194": 2022,
        "2194": 2021,
        "2040": 2022,
        "2040": 2021,
        "2040": 2020,
        "2040": 2019,
        "2040": 2018,
        "2040": 2017,
        "2040": 2016,
        "2040": 2015,
        "2212": 2022,
        "2166": 2022,
        "2166": 2021,
        "2054": 2022,
        "2054": 2021,
        "2054": 2020,
        "2054": 2019,
        "2054": 2018,
        "2054": 2017,
        "4"   : 2022,
        "4"	  : 2021,
        "4"   : 2020,
        "4"   : 2019,
        "4"   : 2018,
        "4"   : 2017,
        "4"   : 2016,
        }

# accountid | year | metricid

for i in rows:
    
    metric["count"] += 1

    if metric["count"] % 10000 == 0:
        elapsed = time.time() - tb
        print(f"processed: {metric} elapsed(sec): {elapsed}")

    account = DEL_MAP.get(str(i.accountid))

    if account is not None:
        if i.year == account:
            metric["found"] += 1
            session.execute("DELETE FROM metric WHERE accountid = {} AND year = {} and metricid = '{}'".format(i.accountid, i.year, i.metricid))
            print("DEL: {}, {}, {}".format(i.accountid, i.year, i.metricid))

