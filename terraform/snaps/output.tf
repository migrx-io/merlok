output "snapshot_arns" {
  value = {
    for key, snap in aws_ebs_snapshot.by_set :
      key => snap.arn
  }
}
