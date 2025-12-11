output "vpc_id" {
  description = "The main VPC id"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "List of created subnet ids"
  # Works whether aws_subnet.public is created with count or for_each
  value = [
    for s in aws_subnet.public : s.id
  ]
}
