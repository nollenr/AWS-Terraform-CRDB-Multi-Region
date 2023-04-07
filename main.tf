# TODO:
# Single Region Cluster

provider "aws" {
  region = var.aws_region_list[0]
  alias = "region-0"
}

provider "aws" {
  region = var.aws_region_list[1]
  alias = "region-1"
}

provider "aws" {
  region = var.aws_region_list[2]
  alias = "region-2"
}

locals {
  required_tags = {
    owner       = var.owner,
    project     = var.project_name,
    environment = var.environment
  }
  tags = merge(var.resource_tags, local.required_tags)
}

# -----------------------------------------------------------------------
#  CRDB Keys and ca.crt
# -----------------------------------------------------------------------
# Create both the keys and cert required for secure mode
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key#private_key_openssh
resource "tls_private_key" "crdb_ca_keys" {
  algorithm = "RSA"
  rsa_bits  = 2048 
}

# https://www.cockroachlabs.com/docs/v22.2/create-security-certificates-openssl
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert
# also created cert with : su - ec2-user -c 'openssl req -new -x509 -key my-safe-directory/ca.key -out certs/ca.crt -days 1831 -subj "/O=Cockroach /CN=Cockroach CA /keyUsage=critical,digitalSignature,keyEncipherment /extendedKeyUsage=clientAuth"'
resource "tls_self_signed_cert" "crdb_ca_cert" {
  private_key_pem = tls_private_key.crdb_ca_keys.private_key_pem

  subject {
    common_name  = "Cockroach CA"
    organization = "Cockroach"
  }

  validity_period_hours = 43921
  is_ca_certificate = true

  allowed_uses = [
    "any_extended",
    "cert_signing",
    "client_auth",
    "code_signing",
    "content_commitment",
    "crl_signing",
    "data_encipherment",
    "digital_signature",
    "email_protection",
    "key_agreement",
    "key_encipherment",
    "ocsp_signing",
    "server_auth"
  ]
}

# -----------------------------------------------------------------------
# Client Keys and cert
# -----------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key#private_key_openssh
resource "tls_private_key" "client_keys" {
  algorithm = "RSA"
  rsa_bits  = 2048 
}

resource "tls_cert_request" "client_csr" {
  private_key_pem = tls_private_key.client_keys.private_key_pem

  subject {
    organization = "Cockroach"
    common_name = "${var.admin_user_name}"
  }

  dns_names = ["root"]

}

resource "tls_locally_signed_cert" "user_cert" {
  cert_request_pem = tls_cert_request.client_csr.cert_request_pem
  ca_private_key_pem = tls_private_key.crdb_ca_keys.private_key_pem
  ca_cert_pem = tls_self_signed_cert.crdb_ca_cert.cert_pem

  validity_period_hours = 43921

    allowed_uses = [
    "any_extended",
    "cert_signing",
    "client_auth",
    "code_signing",
    "content_commitment",
    "crl_signing",
    "data_encipherment",
    "digital_signature",
    "email_protection",
    "key_agreement",
    "key_encipherment",
    "ocsp_signing",
    "server_auth"
  ]
}

module "crdb-region-0" {
  # use the https clone url from github, but without the "https://"
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"

  providers = {
    aws = aws.region-0
  }

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

  vpc_cidr                = var.vpc_cidr_list[0]
  run_init                = "yes"
  create_admin_user       = "yes"
  crdb_instance_key_name  = "nollen-cockroach-us-east-1-kp01"
  install_enterprise_keys = "yes"

  my_ip_address         = var.my_ip_address
  aws_region_01         = var.aws_region_01
  owner                 = var.owner
  project_name          = var.project_name
  environment           = var.environment
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

  tls_private_key = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key  = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert        = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert   = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key    = tls_private_key.client_keys.private_key_pem

  # From environment variables if available ()
  cluster_organization = var.cluster_organization
  enterprise_license   = var.enterprise_license

}


module "crdb-region-1" {
  # use the https clone url from github, but without the "https://"
  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"

  providers = {
    aws = aws.region-1
  }

  depends_on = [tls_self_signed_cert.crdb_ca_cert, tls_locally_signed_cert.user_cert]

  vpc_cidr = var.vpc_cidr_list[1] # different for each module
  join_string = module.crdb-region-0.join_string # from 1st module
  run_init = "no" # no for all except the 1st
  create_admin_user = "no" # no for all except the 1st
  crdb_instance_key_name = "nollen-cockroach-us-west-2-kp01" # different for each module

  my_ip_address = var.my_ip_address # same for all
  owner = var.owner # same for all
  project_name = var.project_name # same for all
  environment = var.environment # same for all
  crdb_version = var.crdb_version # same for all
  crdb_nodes = var.crdb_nodes # same for all 
  crdb_instance_type = var.crdb_instance_type # same for all
  crdb_root_volume_type = var.crdb_root_volume_type # same for all
  crdb_root_volume_size = var.crdb_root_volume_size # same for all
  include_ha_proxy = var.include_ha_proxy # same for all
  haproxy_instance_type = var.haproxy_instance_type # same for all
  include_app = var.include_app # same for all
  app_instance_type = var.app_instance_type # same for all
  admin_user_name = var.admin_user_name # same for all

  tls_private_key = tls_private_key.crdb_ca_keys.private_key_pem
  tls_public_key  = tls_private_key.crdb_ca_keys.public_key_pem
  tls_cert        = tls_self_signed_cert.crdb_ca_cert.cert_pem
  tls_user_cert   = tls_locally_signed_cert.user_cert.cert_pem
  tls_user_key    = tls_private_key.client_keys.private_key_pem

}


# https://dev.to/z4ck404/aws-multi-region-vpc-peering-using-terraform-47jl
resource "aws_vpc_peering_connection" "peer" {
  provider      = aws.region-0
  vpc_id        = module.crdb-region-0.vpc_id
  peer_vpc_id   = module.crdb-region-1.vpc_id
  peer_region   = "us-west-2"
  auto_accept   = false
  tags = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.region-1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
}

resource "aws_route" "vpc1-to-vpc2" {
  route_table_id = module.crdb-region-0.route_table_public_id
  destination_cidr_block = var.vpc_cidr_list[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  provider = aws.region-0
}

resource "aws_route" "vpc2_to_vpc1" {
  route_table_id = module.crdb-region-1.route_table_public_id
  destination_cidr_block = var.vpc_cidr_list[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  provider = aws.region-1
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc2" {
  provider = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port = 26257
  to_port = 26257
  ip_protocol = "tcp"
  cidr_ipv4 = var.vpc_cidr_list[1]
  description = "Allow access to CRDB database port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc1" {
  provider = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port = 26257
  to_port = 26257
  ip_protocol = "tcp"
  cidr_ipv4 = var.vpc_cidr_list[0]
  description = "Allow access to CRDB database port from peer"
}
