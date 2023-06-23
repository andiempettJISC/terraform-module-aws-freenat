locals {
  # length of list is not known by tf until apply time, hard set as a map
  vpc_private_route_table_ids = {
    1 = var.vpc_private_route_table_ids[0],
    2 = var.vpc_private_route_table_ids[1],
    3 = var.vpc_private_route_table_ids[2],
  }

  vpc_cidr_block = data.aws_vpc.vpc.cidr_block
}