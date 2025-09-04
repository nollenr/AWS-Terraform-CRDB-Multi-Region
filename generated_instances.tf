provider "aws" {
  region = var.aws_region_list[0]
  alias  = "region-0"
}

provider "aws" {
  region = var.aws_region_list[1]
  alias  = "region-1"
}

provider "aws" {
  region = var.aws_region_list[2]
  alias  = "region-2"
}

provider "aws" {
  region = var.aws_region_list[3]
  alias  = "region-3"
}

provider "aws" {
  region = var.aws_region_list[4]
  alias  = "region-4"
}

module "crdb-region-0" {
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"
  providers = { aws = aws.region-0 }

  vpc_cidr               = var.vpc_cidr_list[0]
  crdb_instance_key_name = var.aws_instance_keys[0]
  aws_region_01          = var.aws_region_list[0]
  run_init               = "yes"
  create_admin_user      = "yes"
  install_enterprise_keys = "yes"

  my_ip_address          = var.my_ip_address
  owner                  = var.owner
  project_name           = var.project_name
  crdb_version           = var.crdb_version
  crdb_nodes             = var.crdb_nodes
  crdb_instance_type     = var.crdb_instance_type
  crdb_root_volume_type  = var.crdb_root_volume_type
  crdb_root_volume_size  = var.crdb_root_volume_size
  crdb_store_volume_type = var.crdb_store_volume_type
  crdb_store_volume_size = var.crdb_store_volume_size
  crdb_store_volume_iops = var.crdb_store_volume_iops
  crdb_store_volume_throughput = var.crdb_store_volume_throughput
  crdb_wal_failover      = var.crdb_wal_failover
  include_ha_proxy       = var.include_ha_proxy
  haproxy_instance_type  = var.haproxy_instance_type
  include_app            = var.include_app
  app_instance_type      = var.app_instance_type
  admin_user_name        = var.admin_user_name
  aws_region_list        = var.aws_region_list
  create_db_ui_user      = var.create_db_ui_user
  db_ui_user_name        = var.db_ui_user_name
  db_ui_user_password    = var.db_ui_user_password
  cache                  = var.cache
  max_sql_memory         = var.max_sql_memory

  tls_private_key        = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key         = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert               = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert          = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key           = tls_private_key.client_keys.private_key_pem

  cluster_organization   = var.cluster_organization
  enterprise_license     = var.enterprise_license

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

}

module "crdb-region-1" {
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"
  providers = { aws = aws.region-1 }

  vpc_cidr               = var.vpc_cidr_list[1]
  crdb_instance_key_name = var.aws_instance_keys[1]
  aws_region_01          = var.aws_region_list[1]
  run_init               = "no"
  create_admin_user      = "no"
  join_string            = module.crdb-region-0.join_string

  my_ip_address          = var.my_ip_address
  owner                  = var.owner
  project_name           = var.project_name
  crdb_version           = var.crdb_version
  crdb_nodes             = var.crdb_nodes
  crdb_instance_type     = var.crdb_instance_type
  crdb_root_volume_type  = var.crdb_root_volume_type
  crdb_root_volume_size  = var.crdb_root_volume_size
  crdb_store_volume_type = var.crdb_store_volume_type
  crdb_store_volume_size = var.crdb_store_volume_size
  crdb_store_volume_iops = var.crdb_store_volume_iops
  crdb_store_volume_throughput = var.crdb_store_volume_throughput
  crdb_wal_failover      = var.crdb_wal_failover
  include_ha_proxy       = var.include_ha_proxy
  haproxy_instance_type  = var.haproxy_instance_type
  include_app            = var.include_app
  app_instance_type      = var.app_instance_type
  admin_user_name        = var.admin_user_name
  aws_region_list        = var.aws_region_list
  create_db_ui_user      = var.create_db_ui_user
  db_ui_user_name        = var.db_ui_user_name
  db_ui_user_password    = var.db_ui_user_password
  cache                  = var.cache
  max_sql_memory         = var.max_sql_memory

  tls_private_key        = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key         = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert               = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert          = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key           = tls_private_key.client_keys.private_key_pem

  cluster_organization   = var.cluster_organization
  enterprise_license     = var.enterprise_license

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

}

module "crdb-region-2" {
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"
  providers = { aws = aws.region-2 }

  vpc_cidr               = var.vpc_cidr_list[2]
  crdb_instance_key_name = var.aws_instance_keys[2]
  aws_region_01          = var.aws_region_list[2]
  run_init               = "no"
  create_admin_user      = "no"
  join_string            = module.crdb-region-0.join_string

  my_ip_address          = var.my_ip_address
  owner                  = var.owner
  project_name           = var.project_name
  crdb_version           = var.crdb_version
  crdb_nodes             = var.crdb_nodes
  crdb_instance_type     = var.crdb_instance_type
  crdb_root_volume_type  = var.crdb_root_volume_type
  crdb_root_volume_size  = var.crdb_root_volume_size
  crdb_store_volume_type = var.crdb_store_volume_type
  crdb_store_volume_size = var.crdb_store_volume_size
  crdb_store_volume_iops = var.crdb_store_volume_iops
  crdb_store_volume_throughput = var.crdb_store_volume_throughput
  crdb_wal_failover      = var.crdb_wal_failover
  include_ha_proxy       = var.include_ha_proxy
  haproxy_instance_type  = var.haproxy_instance_type
  include_app            = var.include_app
  app_instance_type      = var.app_instance_type
  admin_user_name        = var.admin_user_name
  aws_region_list        = var.aws_region_list
  create_db_ui_user      = var.create_db_ui_user
  db_ui_user_name        = var.db_ui_user_name
  db_ui_user_password    = var.db_ui_user_password
  cache                  = var.cache
  max_sql_memory         = var.max_sql_memory

  tls_private_key        = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key         = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert               = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert          = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key           = tls_private_key.client_keys.private_key_pem

  cluster_organization   = var.cluster_organization
  enterprise_license     = var.enterprise_license

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

}

module "crdb-region-3" {
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"
  providers = { aws = aws.region-3 }

  vpc_cidr               = var.vpc_cidr_list[3]
  crdb_instance_key_name = var.aws_instance_keys[3]
  aws_region_01          = var.aws_region_list[3]
  run_init               = "no"
  create_admin_user      = "no"
  join_string            = module.crdb-region-0.join_string

  my_ip_address          = var.my_ip_address
  owner                  = var.owner
  project_name           = var.project_name
  crdb_version           = var.crdb_version
  crdb_nodes             = var.crdb_nodes
  crdb_instance_type     = var.crdb_instance_type
  crdb_root_volume_type  = var.crdb_root_volume_type
  crdb_root_volume_size  = var.crdb_root_volume_size
  crdb_store_volume_type = var.crdb_store_volume_type
  crdb_store_volume_size = var.crdb_store_volume_size
  crdb_store_volume_iops = var.crdb_store_volume_iops
  crdb_store_volume_throughput = var.crdb_store_volume_throughput
  crdb_wal_failover      = var.crdb_wal_failover
  include_ha_proxy       = var.include_ha_proxy
  haproxy_instance_type  = var.haproxy_instance_type
  include_app            = var.include_app
  app_instance_type      = var.app_instance_type
  admin_user_name        = var.admin_user_name
  aws_region_list        = var.aws_region_list
  create_db_ui_user      = var.create_db_ui_user
  db_ui_user_name        = var.db_ui_user_name
  db_ui_user_password    = var.db_ui_user_password
  cache                  = var.cache
  max_sql_memory         = var.max_sql_memory

  tls_private_key        = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key         = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert               = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert          = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key           = tls_private_key.client_keys.private_key_pem

  cluster_organization   = var.cluster_organization
  enterprise_license     = var.enterprise_license

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

}

module "crdb-region-4" {
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"
  providers = { aws = aws.region-4 }

  vpc_cidr               = var.vpc_cidr_list[4]
  crdb_instance_key_name = var.aws_instance_keys[4]
  aws_region_01          = var.aws_region_list[4]
  run_init               = "no"
  create_admin_user      = "no"
  join_string            = module.crdb-region-0.join_string

  my_ip_address          = var.my_ip_address
  owner                  = var.owner
  project_name           = var.project_name
  crdb_version           = var.crdb_version
  crdb_nodes             = var.crdb_nodes
  crdb_instance_type     = var.crdb_instance_type
  crdb_root_volume_type  = var.crdb_root_volume_type
  crdb_root_volume_size  = var.crdb_root_volume_size
  crdb_store_volume_type = var.crdb_store_volume_type
  crdb_store_volume_size = var.crdb_store_volume_size
  crdb_store_volume_iops = var.crdb_store_volume_iops
  crdb_store_volume_throughput = var.crdb_store_volume_throughput
  crdb_wal_failover      = var.crdb_wal_failover
  include_ha_proxy       = var.include_ha_proxy
  haproxy_instance_type  = var.haproxy_instance_type
  include_app            = var.include_app
  app_instance_type      = var.app_instance_type
  admin_user_name        = var.admin_user_name
  aws_region_list        = var.aws_region_list
  create_db_ui_user      = var.create_db_ui_user
  db_ui_user_name        = var.db_ui_user_name
  db_ui_user_password    = var.db_ui_user_password
  cache                  = var.cache
  max_sql_memory         = var.max_sql_memory

  tls_private_key        = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key         = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert               = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert          = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key           = tls_private_key.client_keys.private_key_pem

  cluster_organization   = var.cluster_organization
  enterprise_license     = var.enterprise_license

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

}

