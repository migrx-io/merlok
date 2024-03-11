locals {
  vols_map = { for vol in var.vols_set : vol => vol }
}

# Create a new security group
resource "aws_security_group" "ssh_access_sg" {
  name        = "ssh_access_sg"
  description = "Allow SSH access"
  
  # Inbound rule to allow SSH traffic from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere. Adjust as needed.
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }


}

resource "aws_key_pair" "instance" {
  key_name   = "key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "by_set" {
  for_each          = local.vols_map
  availability_zone = "us-east-1a"
  ami               = "ami-07761f3ae34c4478d"
  instance_type     = "t2.micro"

  key_name      = aws_key_pair.instance.key_name

  vpc_security_group_ids = [
    aws_security_group.ssh_access_sg.id,
  ]

  tags = {
    cassandra-test = true
  }

  # Add user data script to install Docker
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo service docker start
    sudo usermod -aG docker ec2-user
  EOF

  # Copy local file to the instance
  provisioner "file" {
    source      = "./cassandra.yaml"
    destination = "~/cassandra.yaml"

    connection {
      type        = "ssh"
      user        = "ec2-user"   # Replace with the appropriate username for your AMI
      private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key file
      host        = self.public_ip  # Automatically get the public IP of the instance
    }

  }

}

resource "aws_volume_attachment" "ebs_attachment" {
  for_each    = aws_instance.by_set
  device_name = "/dev/sdh"

  instance_id = each.value.id
  volume_id   = each.key

}
