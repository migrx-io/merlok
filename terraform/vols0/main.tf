resource "aws_ebs_volume" "by_set" {
  for_each = var.volume_set
  availability_zone = "us-east-1a"
  size              = 10
  # snapshot_id       = each.value
  tags = {
    cassandra-test = true
  }
}
