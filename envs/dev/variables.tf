variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of AZs"
  type        = number
  default     = 2
}

variable "subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

variable "instances_per_subnet" {
  description = "Number of instances to create per subnet"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default = {
    Project = "terraform-demo"
  }
}
