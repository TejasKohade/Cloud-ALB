# Provide a map with stable keys so other modules can for_each over it.
output "instance_ids_map" {
  description = "Map of instance ids with stable keys (string keys)"
  value = { for idx, inst in aws_instance.web : tostring(idx) => inst.id }
}

# Legacy list output kept if other code expects it
output "instance_ids" {
  description = "Legacy: list of instance ids (in index order)"
  value       = [for i in aws_instance.web : i.id]
}
