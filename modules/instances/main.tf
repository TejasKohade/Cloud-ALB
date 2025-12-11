# Security group for the instances
resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Security group for demo instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "ec2-sg" }, var.tags)
}

# Compute total instances (count-based)
locals {
  total_subnets = length(var.subnet_ids)
  total_count   = var.instances_per_subnet * local.total_subnets
}

resource "aws_instance" "web" {
  count         = local.total_count
  ami           = data.aws_ami.amazonlinux.id
  instance_type = "t3.micro"
  subnet_id     = element(var.subnet_ids, count.index % local.total_subnets)
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<-EOT
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from public instance $(hostname)" > /var/www/html/index.html
              EOT

  tags = merge({
    Name = "web-${count.index}"
  }, var.tags)
}

# AMI data (Amazon Linux 2)
data "aws_ami" "amazonlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

output "public_ips" {
  description = "Public IPs of all instances"
  value       = [for i in aws_instance.web : i.public_ip]
}
