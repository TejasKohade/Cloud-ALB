locals {
  instance_defs = flatten([
    for subnet_id in var.subnet_ids : [
      for n in range(var.instances_per_subnet) : {
        subnet = subnet_id
        index  = "${subnet_id}-${n}"
      }
    ]
  ])
}

resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

data "aws_vpc" "selected" {
  id = split("/", var.subnet_ids[0])[1]
}

resource "aws_instance" "web" {
  for_each = {
    for i in local.instance_defs : i.index => i
  }

  ami                    = data.aws_ami.amazonlinux.id
  instance_type          = "t3.micro"
  subnet_id              = each.value.subnet
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = templatefile("${path.module}/templates/public.sh", {})

  tags = merge(var.tags, { Name = "web-${each.key}" })
}

data "aws_ami" "amazonlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
