import hcl2
from itertools import combinations
import os
import datetime
import argparse

# === Parse Command-Line Arguments ===
parser = argparse.ArgumentParser(description="Generate Terraform module or networking files based on input.")
parser.add_argument("--tfvars", default="terraform.tfvars", help="Path to the terraform.tfvars file")
parser.add_argument("--input", default="networking.tf", help="Path to existing 'networking.tf' file")
parser.add_argument("--output", default="generated_networking.tf", help="Path to new HCL terraform file that will be used to create the multi-region networking.")

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
module_names = [f"crdb-region-{i}" for i in range(len(regions))]

# === VALIDATE INPUT LENGTHS ===
if not (len(regions) == len(cidrs) == len(keys)):
    raise ValueError("Error: 'aws_region_list', 'vpc_cidr_list', and 'aws_instance_keys' must all have the same length.")

# === GENERATE ALL UNIQUE REGION PAIRS ===
region_pairs = list(combinations(range(len(regions)), 2))

blocks = []

for i, j in region_pairs:
    # --- VPC PEERING CONNECTION AND ACCEPTER ---
    blocks.append(f'resource "aws_vpc_peering_connection" "peer{i}{j}" {{\n'
                  f'  provider    = aws.region-{i}\n'
                  f'  vpc_id      = module.crdb-region-{i}.vpc_id\n'
                  f'  peer_vpc_id = module.crdb-region-{j}.vpc_id\n'
                  f'  peer_region = var.aws_region_list[{j}]\n'
                  f'  auto_accept = false\n'
                  f'  tags        = local.tags\n'
                  f'}}\n')

    blocks.append(f'resource "aws_vpc_peering_connection_accepter" "peer{i}{j}" {{\n'
                  f'  provider                  = aws.region-{j}\n'
                  f'  vpc_peering_connection_id = aws_vpc_peering_connection.peer{i}{j}.id\n'
                  f'  auto_accept               = true\n'
                  f'}}\n')

    # --- ROUTES ---
    blocks.append(f'resource "aws_route" "vpc{i}-to-vpc{j}" {{\n'
                  f'  route_table_id            = module.crdb-region-{i}.route_table_public_id\n'
                  f'  destination_cidr_block    = var.vpc_cidr_list[{j}]\n'
                  f'  vpc_peering_connection_id = aws_vpc_peering_connection.peer{i}{j}.id\n'
                  f'  provider                  = aws.region-{i}\n'
                  f'}}\n')

    blocks.append(f'resource "aws_route" "vpc{j}-to-vpc{i}" {{\n'
                  f'  route_table_id            = module.crdb-region-{j}.route_table_public_id\n'
                  f'  destination_cidr_block    = var.vpc_cidr_list[{i}]\n'
                  f'  vpc_peering_connection_id = aws_vpc_peering_connection.peer{i}{j}.id\n'
                  f'  provider                  = aws.region-{j}\n'
                  f'}}\n')

    # --- SECURITY GROUP RULES (DB + SSH, both directions) ---
    for port, label in [(26257, "db"), (22, "ssh")]:
        # Into i from j
        blocks.append(f'resource "aws_vpc_security_group_ingress_rule" "into-vpc{i}-from-vpc{j}-{label}" {{\n'
                      f'  provider          = aws.region-{i}\n'
                      f'  security_group_id = module.crdb-region-{i}.security_group_intra_node_id\n'
                      f'  from_port         = {port}\n'
                      f'  to_port           = {port}\n'
                      f'  ip_protocol       = "tcp"\n'
                      f'  cidr_ipv4         = var.vpc_cidr_list[{j}]\n'
                      f'  description       = "Allow access to CRDB {label} port from peer"\n'
                      f'}}\n')

        # Into j from i
        blocks.append(f'resource "aws_vpc_security_group_ingress_rule" "into-vpc{j}-from-vpc{i}-{label}" {{\n'
                      f'  provider          = aws.region-{j}\n'
                      f'  security_group_id = module.crdb-region-{j}.security_group_intra_node_id\n'
                      f'  from_port         = {port}\n'
                      f'  to_port           = {port}\n'
                      f'  ip_protocol       = "tcp"\n'
                      f'  cidr_ipv4         = var.vpc_cidr_list[{i}]\n'
                      f'  description       = "Allow access to CRDB {label} port from peer"\n'
                      f'}}\n')

# === Rename Existing File ===
if os.path.isfile(INPUT_PATH):
    # Append timestamp to create a new name
    timestamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    new_name = f"{INPUT_PATH}.{timestamp}"
    
    os.rename(INPUT_PATH, new_name)
    print(f"Renamed '{INPUT_PATH}' to '{new_name}'")
else:
    print(f"File '{INPUT_PATH}' does not exist.")

# === WRITE OUTPUT ===
with open(OUTPUT_PATH, "w") as f:
    f.write("\n".join(blocks))

print(f"✅ Successfully wrote full-mesh networking configuration for {len(regions)} regions to {OUTPUT_PATH}")
