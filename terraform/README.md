# Provision test cassandra

## Create snapshots from nodes volumes

```
cd ./snap

# edit variables.tf and put vol list

terraform init

terraform plan

terraform apply

```

## Create new volumes from snapshots

```
cd ./vols

# edit variables.tf and put snap list

terraform init

terraform plan

terraform apply

```

## Create new instances and attach volumes 

```
cd ./nodes

# edit variables.tf and put vols list

terraform init

terraform plan

terraform apply

```

## Save node ips to hosts file 

```
echo "ip" > hosts

```

## Mount volume 

```

pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no lsblk

pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no sudo mkfs -t ext4 /dev/<?>

pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no sudo mkdir /mnt/cassandra

pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no sudo chown ec2-user:ec2-user /mnt/cassandra

pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no sudo mount /dev/<?> /mnt/cassandra

```


## Run cassandra

```

pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no docker pull cassandra:3.11.3

pscp -h hosts -l ec2-user cassandra.yaml /home/ec2-user/

# first node

ssh ec2-user@<ip> 

docker run --name cassandra -d -e CASSANDRA_BROADCAST_ADDRESS="<ip>" -e CASSANDRA_DC=DC1 -e CASSANDRA_RACK=Rack1  --network host -v /mnt/cassandra:/var/lib/cassandra -v ~/cassandra.yaml:/etc/cassandra/cassandra.yaml cassandra:3.11.3

# get seed ip
ip -a


# other nodes

pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no 'docker run --name cassandra -d -e CASSANDRA_SEEDS="<ip>" -e CASSANDRA_DC=DC1 -e CASSANDRA_RACK=Rack1  --network host -v /mnt/cassandra:/var/lib/cassandra -v ~/cassandra.yaml:/etc/cassandra/cassandra.yaml cassandra:3.11.3'

docker logs cassandra

docker exec -it cassandra /bin/bash

```


## Helpful commands


Get list of EBS Volumes

```
aws ec2 describe-volumes --filters "Name=tag:cassandra-test,Values=true"

```

Get list of EBS Snaps

```
aws ec2 describe-snapshots --filters "Name=tag:cassandra-test,Values=true"

```

Get IOPS
```
pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no "iostat -d nvme1n1 | grep nvme1n1 | awk '{ print $2; }'"
```

Get Disk space
```
pssh -l ec2-user -h hosts -i -O StrictHostKeyChecking=no df -h|grep nvme1n1
```
