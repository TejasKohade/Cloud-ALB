variable "subnet_ids" {
  description = "List of subnet ids where instances will be launched"
  type        = list(string)
}

variable "instances_per_subnet" {
  description = "How many instances to create per subnet"
  type        = number
}

variable "vpc_id" {
  description = "VPC id where instances and security group will be created"
  type        = string
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}
