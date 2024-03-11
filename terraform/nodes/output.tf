output "instance_arns" {
  value = {
    for key, ins in aws_instance.by_set :
      key => ins.arn
  }
}

output "instance_public_ip" {
  value = { for key, instance in aws_instance.by_set : key => instance.public_ip }
}
