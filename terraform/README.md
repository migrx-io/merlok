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

# edit variables.tf and put snap list

terraform init

terraform plan

terraform apply

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

EC2 instance type - t3.2xlarge


pssh -l ec2-user -h hosts -i  echo "1"
