data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${local.name}-${local.env}"
  cidr = "10.2.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets  = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]
  intra_subnets   = ["10.2.41.0/24", "10.2.42.0/24", "10.2.43.0/24"]

  # No NAT gateway 
  enable_nat_gateway = false

  enable_vpn_gateway = false

  create_egress_only_igw                         = false
  enable_ipv6                                    = false
  private_subnet_assign_ipv6_address_on_creation = false

  create_database_subnet_group           = false
  create_database_subnet_route_table     = false
  create_database_internet_gateway_route = false
  create_elasticache_subnet_group        = false
  create_elasticache_subnet_route_table  = false

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "nat" {
  source                      = "../../."
  name                        = local.name
  env                         = local.env
  vpc_id                      = module.vpc.vpc_id
  vpc_private_route_table_ids = module.vpc.private_route_table_ids
  vpc_public_subnets          = module.vpc.public_subnets
  instance_profile_name       = aws_iam_instance_profile.instance_profile.name
}

resource "aws_instance" "example_instance" {
  ami                         = data.aws_ami.ubuntu_arm_ami.id
  instance_type               = "t4g.nano"
  vpc_security_group_ids      = [aws_security_group.egress_only.id]
  subnet_id                   = module.vpc.private_subnets[1]
  associate_public_ip_address = false
  metadata_options {
    http_tokens = "required"
  }
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "${local.name}-${local.env}-example-instance"
  }
}