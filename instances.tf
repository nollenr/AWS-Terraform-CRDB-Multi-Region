module "crdb-region-0" {
  # use the https clone url from github, but without the "https://"
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"

  providers = {
    aws = aws.region-0
  }

#   depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

  vpc_cidr                = var.vpc_cidr_list[0]
  run_init                = "yes"
  create_admin_user       = "yes"
  crdb_instance_key_name  = var.aws_instance_keys[0]
  install_enterprise_keys = "yes"

  my_ip_address         = var.my_ip_address
  aws_region_01         = var.aws_region_list[0]
  owner                 = var.owner
  project_name          = var.project_name
  crdb_version          = var.crdb_version
  crdb_nodes            = var.crdb_nodes
  crdb_instance_type    = var.crdb_instance_type
  crdb_root_volume_type = var.crdb_root_volume_type
  crdb_root_volume_size = var.crdb_root_volume_size
  include_ha_proxy      = var.include_ha_proxy
  haproxy_instance_type = var.haproxy_instance_type
  include_app           = var.include_app
  app_instance_type     = var.app_instance_type
  admin_user_name       = var.admin_user_name
  aws_region_list       = var.aws_region_list # same for all -- needed for multi-region-demo

  tls_private_key = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key  = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert        = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert   = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key    = tls_private_key.client_keys.private_key_pem

  # From environment variables if available ().  This allows me to add the enterprise license to the cluster
  cluster_organization = var.cluster_organization
  enterprise_license   = var.enterprise_license
}


module "crdb-region-1" {
  # use the https clone url from github, but without the "https://"
  # source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git?ref=aws-update"
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"


  providers = {
    aws = aws.region-1
  }

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

  vpc_cidr               = var.vpc_cidr_list[1] # different for each module
  join_string            = module.crdb-region-0.join_string # from 1st module
  run_init               = "no" # no for all except the 1st
  create_admin_user      = "no" # no for all except the 1st
  crdb_instance_key_name = var.aws_instance_keys[1] # different for each module

  my_ip_address         = var.my_ip_address # same for all
  aws_region_01         = var.aws_region_list[1]
  owner                 = var.owner # same for all
  project_name          = var.project_name # same for all
  crdb_version          = var.crdb_version # same for all
  crdb_nodes            = var.crdb_nodes # same for all 
  crdb_instance_type    = var.crdb_instance_type # same for all
  crdb_root_volume_type = var.crdb_root_volume_type # same for all
  crdb_root_volume_size = var.crdb_root_volume_size # same for all
  include_ha_proxy      = var.include_ha_proxy # same for all
  haproxy_instance_type = var.haproxy_instance_type # same for all
  include_app           = var.include_app # same for all
  app_instance_type     = var.app_instance_type # same for all
  admin_user_name       = var.admin_user_name # same for all
  aws_region_list       = var.aws_region_list # same for all -- needed for multi-region-demo

  tls_private_key = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key  = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert        = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert   = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key    = tls_private_key.client_keys.private_key_pem

}

# Create the 3rd region VPC, subnets, etc and Cockroach Nodes
module "crdb-region-2" {
  # use the https clone url from github, but without the "https://"
  # source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git?ref=aws-update"
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"

  providers = {
    aws = aws.region-2
  }

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

  vpc_cidr               = var.vpc_cidr_list[2] # different for each module
  join_string            = module.crdb-region-0.join_string # from 1st module
  run_init               = "no" # no for all except the 1st
  create_admin_user      = "no" # no for all except the 1st
  crdb_instance_key_name = var.aws_instance_keys[2]

  my_ip_address         = var.my_ip_address # same for all
  aws_region_01         = var.aws_region_list[2]
  owner                 = var.owner # same for all
  project_name          = var.project_name # same for all
  crdb_version          = var.crdb_version # same for all
  crdb_nodes            = var.crdb_nodes # same for all 
  crdb_instance_type    = var.crdb_instance_type # same for all
  crdb_root_volume_type = var.crdb_root_volume_type # same for all
  crdb_root_volume_size = var.crdb_root_volume_size # same for all
  include_ha_proxy      = var.include_ha_proxy # same for all
  haproxy_instance_type = var.haproxy_instance_type # same for all
  include_app           = var.include_app # same for all
  app_instance_type     = var.app_instance_type # same for all
  admin_user_name       = var.admin_user_name # same for all
  aws_region_list       = var.aws_region_list # same for all -- needed for multi-region-demo

  tls_private_key = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key  = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert        = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert   = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key    = tls_private_key.client_keys.private_key_pem

}
