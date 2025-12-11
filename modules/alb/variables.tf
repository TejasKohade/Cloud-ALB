variable "subnet_ids" {
  description = "List of subnet ids for ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id for the target group"
  type        = string
}

variable "instance_id_map" {
  description = "Preferred: map of instance IDs to attach to target group"
  type        = map(string)
  default     = null
}

variable "instance_ids" {
  description = "Legacy: list of instance IDs (converted to map if provided)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for ALB resources"
  type        = map(string)
  default     = {}
}
