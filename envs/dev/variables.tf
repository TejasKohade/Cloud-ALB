variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az_count" {
  default = 2
}

variable "subnet_count" {
  default = 2
}

variable "instances_per_subnet" {
  default = 1
}

variable "tags" {
  default = {
    Project = "terraform-demo"
  }
}
