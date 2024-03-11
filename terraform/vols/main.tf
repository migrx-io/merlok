resource "aws_ebs_volume" "by_set" {
  for_each          = var.snapshot_set
  availability_zone = "us-east-1a"
  snapshot_id       = each.value

  tags = {
    cassandra-test = true
  }

}
