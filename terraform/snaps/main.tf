
resource "aws_ebs_snapshot" "by_set" {
  for_each = var.volume_set
  volume_id = each.value
  tags = {
    cassandra-test = true
    volume = each.value
  }
}

