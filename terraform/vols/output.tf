output "volume_arns" {
  value = {
    for key, volume in aws_ebs_volume.by_set :
      key => volume.arn
  }
}
