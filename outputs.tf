# output "module-crdb-region-0-security-group-id" {
#   description = "the CockroachDB private IP join string"
#   value = module.crdb-region-0.security_group_intra_node_id
# }

# output "module-crdb-region-1-security-group-id" {
#   description = "the CockroachDB private IP join string"
#   value = module.crdb-region-1.security_group_intra_node_id
# }

# output "module-crdb-region-2-security-group-id" {
#   description = "the CockroachDB private IP join string"
#   value = module.crdb-region-2.security_group_intra_node_id
# }

output "module-crdb-region-0-app_node_public_ip" {
  description = "The public IP address of the 1st Region app node, if created."
  value = module.crdb-region-0.app_node_public_ip
}

output "module-crdb-region-1-app_node_public_ip" {
  description = "The public IP address of the 2nd Region app node, if created."
  value = module.crdb-region-1.app_node_public_ip
}

output "module-crdb-region-2-app_node_public_ip" {
  description = "The public IP address of the 3rd Region app node, if created."
  value = module.crdb-region-2.app_node_public_ip
}

output "module-crdb-region-0-public_ips_by_az" {
  description = "CockroachDB Node public IPs assigned to interfaces by AZ in 1st Region."
  value       = module.crdb-region-0.public_ips_by_az
}

output "module-crdb-region-1-public_ips_by_az" {
  description = "CockroachDB Node public IPs assigned to interfaces by AZ in 2nd Region."
  value       = module.crdb-region-1.public_ips_by_az
}

output "module-crdb-region-2-public_ips_by_az" {
  description = "CockroachDB Node public IPs assigned to interfaces by AZ in 3rd Region."
  value       = module.crdb-region-2.public_ips_by_az
}
