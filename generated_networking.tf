resource "aws_vpc_peering_connection" "peer01" {
  provider    = aws.region-0
  vpc_id      = module.crdb-region-0.vpc_id
  peer_vpc_id = module.crdb-region-1.vpc_id
  peer_region = var.aws_region_list[1]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer01" {
  provider                  = aws.region-1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer01.id
  auto_accept               = true
}

resource "aws_route" "vpc0-to-vpc1" {
  route_table_id            = module.crdb-region-0.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer01.id
  provider                  = aws.region-0
}

resource "aws_route" "vpc1-to-vpc0" {
  route_table_id            = module.crdb-region-1.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer01.id
  provider                  = aws.region-1
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc0-from-vpc1-db" {
  provider          = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[1]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc0-db" {
  provider          = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[0]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc0-from-vpc1-ssh" {
  provider          = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[1]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc0-ssh" {
  provider          = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[0]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer02" {
  provider    = aws.region-0
  vpc_id      = module.crdb-region-0.vpc_id
  peer_vpc_id = module.crdb-region-2.vpc_id
  peer_region = var.aws_region_list[2]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer02" {
  provider                  = aws.region-2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer02.id
  auto_accept               = true
}

resource "aws_route" "vpc0-to-vpc2" {
  route_table_id            = module.crdb-region-0.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer02.id
  provider                  = aws.region-0
}

resource "aws_route" "vpc2-to-vpc0" {
  route_table_id            = module.crdb-region-2.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer02.id
  provider                  = aws.region-2
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc0-from-vpc2-db" {
  provider          = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[2]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc0-db" {
  provider          = aws.region-2
  security_group_id = module.crdb-region-2.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[0]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc0-from-vpc2-ssh" {
  provider          = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[2]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc0-ssh" {
  provider          = aws.region-2
  security_group_id = module.crdb-region-2.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[0]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer03" {
  provider    = aws.region-0
  vpc_id      = module.crdb-region-0.vpc_id
  peer_vpc_id = module.crdb-region-3.vpc_id
  peer_region = var.aws_region_list[3]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer03" {
  provider                  = aws.region-3
  vpc_peering_connection_id = aws_vpc_peering_connection.peer03.id
  auto_accept               = true
}

resource "aws_route" "vpc0-to-vpc3" {
  route_table_id            = module.crdb-region-0.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[3]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer03.id
  provider                  = aws.region-0
}

resource "aws_route" "vpc3-to-vpc0" {
  route_table_id            = module.crdb-region-3.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer03.id
  provider                  = aws.region-3
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc0-from-vpc3-db" {
  provider          = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[3]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc3-from-vpc0-db" {
  provider          = aws.region-3
  security_group_id = module.crdb-region-3.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[0]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc0-from-vpc3-ssh" {
  provider          = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[3]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc3-from-vpc0-ssh" {
  provider          = aws.region-3
  security_group_id = module.crdb-region-3.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[0]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer04" {
  provider    = aws.region-0
  vpc_id      = module.crdb-region-0.vpc_id
  peer_vpc_id = module.crdb-region-4.vpc_id
  peer_region = var.aws_region_list[4]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer04" {
  provider                  = aws.region-4
  vpc_peering_connection_id = aws_vpc_peering_connection.peer04.id
  auto_accept               = true
}

resource "aws_route" "vpc0-to-vpc4" {
  route_table_id            = module.crdb-region-0.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[4]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer04.id
  provider                  = aws.region-0
}

resource "aws_route" "vpc4-to-vpc0" {
  route_table_id            = module.crdb-region-4.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer04.id
  provider                  = aws.region-4
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc0-from-vpc4-db" {
  provider          = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[4]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc4-from-vpc0-db" {
  provider          = aws.region-4
  security_group_id = module.crdb-region-4.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[0]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc0-from-vpc4-ssh" {
  provider          = aws.region-0
  security_group_id = module.crdb-region-0.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[4]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc4-from-vpc0-ssh" {
  provider          = aws.region-4
  security_group_id = module.crdb-region-4.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[0]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer12" {
  provider    = aws.region-1
  vpc_id      = module.crdb-region-1.vpc_id
  peer_vpc_id = module.crdb-region-2.vpc_id
  peer_region = var.aws_region_list[2]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer12" {
  provider                  = aws.region-2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer12.id
  auto_accept               = true
}

resource "aws_route" "vpc1-to-vpc2" {
  route_table_id            = module.crdb-region-1.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer12.id
  provider                  = aws.region-1
}

resource "aws_route" "vpc2-to-vpc1" {
  route_table_id            = module.crdb-region-2.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer12.id
  provider                  = aws.region-2
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc2-db" {
  provider          = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[2]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc1-db" {
  provider          = aws.region-2
  security_group_id = module.crdb-region-2.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[1]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc2-ssh" {
  provider          = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[2]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc1-ssh" {
  provider          = aws.region-2
  security_group_id = module.crdb-region-2.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[1]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer13" {
  provider    = aws.region-1
  vpc_id      = module.crdb-region-1.vpc_id
  peer_vpc_id = module.crdb-region-3.vpc_id
  peer_region = var.aws_region_list[3]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer13" {
  provider                  = aws.region-3
  vpc_peering_connection_id = aws_vpc_peering_connection.peer13.id
  auto_accept               = true
}

resource "aws_route" "vpc1-to-vpc3" {
  route_table_id            = module.crdb-region-1.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[3]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer13.id
  provider                  = aws.region-1
}

resource "aws_route" "vpc3-to-vpc1" {
  route_table_id            = module.crdb-region-3.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer13.id
  provider                  = aws.region-3
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc3-db" {
  provider          = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[3]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc3-from-vpc1-db" {
  provider          = aws.region-3
  security_group_id = module.crdb-region-3.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[1]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc3-ssh" {
  provider          = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[3]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc3-from-vpc1-ssh" {
  provider          = aws.region-3
  security_group_id = module.crdb-region-3.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[1]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer14" {
  provider    = aws.region-1
  vpc_id      = module.crdb-region-1.vpc_id
  peer_vpc_id = module.crdb-region-4.vpc_id
  peer_region = var.aws_region_list[4]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer14" {
  provider                  = aws.region-4
  vpc_peering_connection_id = aws_vpc_peering_connection.peer14.id
  auto_accept               = true
}

resource "aws_route" "vpc1-to-vpc4" {
  route_table_id            = module.crdb-region-1.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[4]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer14.id
  provider                  = aws.region-1
}

resource "aws_route" "vpc4-to-vpc1" {
  route_table_id            = module.crdb-region-4.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer14.id
  provider                  = aws.region-4
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc4-db" {
  provider          = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[4]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc4-from-vpc1-db" {
  provider          = aws.region-4
  security_group_id = module.crdb-region-4.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[1]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc1-from-vpc4-ssh" {
  provider          = aws.region-1
  security_group_id = module.crdb-region-1.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[4]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc4-from-vpc1-ssh" {
  provider          = aws.region-4
  security_group_id = module.crdb-region-4.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[1]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer23" {
  provider    = aws.region-2
  vpc_id      = module.crdb-region-2.vpc_id
  peer_vpc_id = module.crdb-region-3.vpc_id
  peer_region = var.aws_region_list[3]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer23" {
  provider                  = aws.region-3
  vpc_peering_connection_id = aws_vpc_peering_connection.peer23.id
  auto_accept               = true
}

resource "aws_route" "vpc2-to-vpc3" {
  route_table_id            = module.crdb-region-2.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[3]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer23.id
  provider                  = aws.region-2
}

resource "aws_route" "vpc3-to-vpc2" {
  route_table_id            = module.crdb-region-3.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer23.id
  provider                  = aws.region-3
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc3-db" {
  provider          = aws.region-2
  security_group_id = module.crdb-region-2.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[3]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc3-from-vpc2-db" {
  provider          = aws.region-3
  security_group_id = module.crdb-region-3.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[2]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc3-ssh" {
  provider          = aws.region-2
  security_group_id = module.crdb-region-2.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[3]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc3-from-vpc2-ssh" {
  provider          = aws.region-3
  security_group_id = module.crdb-region-3.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[2]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer24" {
  provider    = aws.region-2
  vpc_id      = module.crdb-region-2.vpc_id
  peer_vpc_id = module.crdb-region-4.vpc_id
  peer_region = var.aws_region_list[4]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer24" {
  provider                  = aws.region-4
  vpc_peering_connection_id = aws_vpc_peering_connection.peer24.id
  auto_accept               = true
}

resource "aws_route" "vpc2-to-vpc4" {
  route_table_id            = module.crdb-region-2.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[4]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer24.id
  provider                  = aws.region-2
}

resource "aws_route" "vpc4-to-vpc2" {
  route_table_id            = module.crdb-region-4.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer24.id
  provider                  = aws.region-4
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc4-db" {
  provider          = aws.region-2
  security_group_id = module.crdb-region-2.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[4]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc4-from-vpc2-db" {
  provider          = aws.region-4
  security_group_id = module.crdb-region-4.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[2]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc2-from-vpc4-ssh" {
  provider          = aws.region-2
  security_group_id = module.crdb-region-2.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[4]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc4-from-vpc2-ssh" {
  provider          = aws.region-4
  security_group_id = module.crdb-region-4.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[2]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_peering_connection" "peer34" {
  provider    = aws.region-3
  vpc_id      = module.crdb-region-3.vpc_id
  peer_vpc_id = module.crdb-region-4.vpc_id
  peer_region = var.aws_region_list[4]
  auto_accept = false
  tags        = local.tags
}

resource "aws_vpc_peering_connection_accepter" "peer34" {
  provider                  = aws.region-4
  vpc_peering_connection_id = aws_vpc_peering_connection.peer34.id
  auto_accept               = true
}

resource "aws_route" "vpc3-to-vpc4" {
  route_table_id            = module.crdb-region-3.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[4]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer34.id
  provider                  = aws.region-3
}

resource "aws_route" "vpc4-to-vpc3" {
  route_table_id            = module.crdb-region-4.route_table_public_id
  destination_cidr_block    = var.vpc_cidr_list[3]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer34.id
  provider                  = aws.region-4
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc3-from-vpc4-db" {
  provider          = aws.region-3
  security_group_id = module.crdb-region-3.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[4]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc4-from-vpc3-db" {
  provider          = aws.region-4
  security_group_id = module.crdb-region-4.security_group_intra_node_id
  from_port         = 26257
  to_port           = 26257
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[3]
  description       = "Allow access to CRDB db port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc3-from-vpc4-ssh" {
  provider          = aws.region-3
  security_group_id = module.crdb-region-3.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[4]
  description       = "Allow access to CRDB ssh port from peer"
}

resource "aws_vpc_security_group_ingress_rule" "into-vpc4-from-vpc3-ssh" {
  provider          = aws.region-4
  security_group_id = module.crdb-region-4.security_group_intra_node_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_list[3]
  description       = "Allow access to CRDB ssh port from peer"
}
