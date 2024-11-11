output "module-crdb-region-0-security-group-id" {
  description = "the CockroachDB private IP join string"
  value = module.crdb-region-0.security_group_intra_node_id
}

output "module-crdb-region-1-security-group-id" {
  description = "the CockroachDB private IP join string"
  value = module.crdb-region-1.security_group_intra_node_id
}

output "module-crdb-region-2-security-group-id" {
  description = "the CockroachDB private IP join string"
  value = module.crdb-region-2.security_group_intra_node_id
}