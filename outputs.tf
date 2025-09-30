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
  value = module.crdb-region-0.var.include_app == "yes" && module.crdb-region-0.var.create_ec2_instances == "yes" ? (
    # If count is 1, access the first (and only) instance in the list
    module.crdb-region-0.aws_instance.app[0].public_ip
  ) : (
    # If count is 0, return null (or an empty string)
    null
  )
}

output "module-crdb-region-1-app_node_public_ip" {
  description = "The public IP address of the 1st Region app node, if created."
  value = module.crdb-region-1.var.include_app == "yes" && module.crdb-region-1.var.create_ec2_instances == "yes" ? (
    # If count is 1, access the first (and only) instance in the list
    module.crdb-region-0.aws_instance.app[0].public_ip
  ) : (
    # If count is 0, return null (or an empty string)
    null
  )
}

output "module-crdb-region-2-app_node_public_ip" {
  description = "The public IP address of the 1st Region app node, if created."
  value = module.crdb-region-2.var.include_app == "yes" && module.crdb-region-2.var.create_ec2_instances == "yes" ? (
    # If count is 1, access the first (and only) instance in the list
    module.crdb-region-0.aws_instance.app[0].public_ip
  ) : (
    # If count is 0, return null (or an empty string)
    null
  )
}

output "module-crdb-region-0-public_ips_by_az" {
  description = "CockroachDB Node public IPs assigned to interfaces by AZ."
  value       = module.crdb-region-0.local.crdb_public_ips_by_az
}

output "module-crdb-region-1-public_ips_by_az" {
  description = "CockroachDB Node public IPs assigned to interfaces by AZ."
  value       = module.crdb-region-1.local.crdb_public_ips_by_az
}

output "module-crdb-region-2-public_ips_by_az" {
  description = "CockroachDB Node public IPs assigned to interfaces by AZ."
  value       = module.crdb-region-2.local.crdb_public_ips_by_az
}