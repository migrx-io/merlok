resource "aws_ebs_volume" "by_set" {
  for_each          = var.snapshot_set
  availability_zone = "us-east-1a"
  snapshot_id       = each.value

  size             = 9000     
  type             = "gp3" 
  iops             = 16000 
  throughput       = 250


  tags = {
    cassandra-test = true
  }

}
