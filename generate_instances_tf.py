import hcl2
import os
import datetime
import argparse

# === Parse Command-Line Arguments ===
parser = argparse.ArgumentParser(description="Generate Terraform module or networking files based on input.")
parser.add_argument("--tfvars", default="terraform.tfvars", help="Path to the terraform.tfvars file")
parser.add_argument("--input", default="instances.tf", help="Path to existing 'instances.tf' file")
parser.add_argument("--output", default="generated_instances.tf", help="Path to new HCL terraform file that will be used to create the CRDB instances.")

args = parser.parse_args()

# === Use Your Variables ===
TFVARS_PATH = args.tfvars
INPUT_PATH = args.input
OUTPUT_PATH = args.output

print(f"TFVARS:  {TFVARS_PATH}")
print(f"INPUT:   {INPUT_PATH}")
print(f"OUTPUT:  {OUTPUT_PATH}")

# === LOAD TFVARS ===
with open(TFVARS_PATH, "r") as f:
    tfvars_data = hcl2.load(f)

regions = tfvars_data.get("aws_region_list", [])
cidrs = tfvars_data.get("vpc_cidr_list", [])
keys = tfvars_data.get("aws_instance_keys", [])

# === VALIDATE INPUT ===
if not (len(regions) == len(cidrs) == len(keys)):
    raise ValueError("Error: 'aws_region_list', 'vpc_cidr_list', and 'aws_instance_keys' must all have the same length.")

# === GENERATE PROVIDER BLOCKS ===
provider_blocks = []
for i in range(len(regions)):
    block = f'provider "aws" {{\n'
    block += f'  region = var.aws_region_list[{i}]\n'
    block += f'  alias  = "region-{i}"\n'
    block += f'}}\n\n'
    provider_blocks.append(block)

# === SHARED MODULE SETTINGS ===
common_settings = """
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
  systemd_restart_option = var.systemd_restart_option
  include_ha_proxy       = var.include_ha_proxy
  haproxy_instance_type  = var.haproxy_instance_type
  include_app            = var.include_app
  app_instance_type      = var.app_instance_type
  install_haproxy_on_app = var.install_haproxy_on_app
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
"""

# === GENERATE MODULE BLOCKS ===
module_blocks = []
for i in range(len(regions)):
    block = f'module "crdb-region-{i}" {{\n'
    block += f'  source = "github.com/nollenr/AWS-Terraform-CRDB-Module.git"\n'
    block += f'  providers = {{ aws = aws.region-{i} }}\n\n'
    block += f'  vpc_cidr               = var.vpc_cidr_list[{i}]\n'
    block += f'  crdb_instance_key_name = var.aws_instance_keys[{i}]\n'
    block += f'  aws_region_01          = var.aws_region_list[{i}]\n'

    if i == 0:
        block += '  run_init               = "yes"\n'
        block += '  create_admin_user      = "yes"\n'
        block += '  install_enterprise_keys = "yes"\n'
    else:
        block += '  run_init               = "no"\n'
        block += '  create_admin_user      = "no"\n'
        block += '  join_string            = module.crdb-region-0.join_string\n'

    block += common_settings
    block += "\n}\n\n"
    module_blocks.append(block)

# === Rename Existing File ===
if os.path.isfile(INPUT_PATH):
    # Append timestamp to create a new name
    timestamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    new_name = f"{INPUT_PATH}.{timestamp}"
    
    os.rename(INPUT_PATH, new_name)
    print(f"Renamed '{INPUT_PATH}' to '{new_name}'")
else:
    print(f"File '{INPUT_PATH}' does not exist.")

# === WRITE TO FILE ===
with open(OUTPUT_PATH, "w") as f:
    f.write("".join(provider_blocks + module_blocks))

print(f"✅ Successfully wrote {len(provider_blocks)} providers and {len(module_blocks)} modules to {OUTPUT_PATH}")
