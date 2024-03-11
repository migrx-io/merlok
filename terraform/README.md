# Provision test cassandra

Get list of EBS Volumes

```
aws ec2 describe-volumes --filters "Name=tag:cassandra-test,Values=true"

```

Get list of EBS Snaps

```
aws ec2 describe-snapshots --filters "Name=tag:cassandra-test,Values=true"

```


EC2 instance type - t3.2xlarge



pssh -l ec2-user -h hosts -i  echo "1"
