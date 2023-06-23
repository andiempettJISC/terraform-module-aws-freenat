resource "aws_security_group" "nat_instance" {
  name        = "${var.name}-${var.env}-nat-instance"
  description = "Security group for NAT instance"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "VPC unrestricted internal access"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [local.vpc_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  egress = [
    {
      description      = "Egress Unrestricted"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]
  tags = {
    Name = "${var.name}-${var.env}-nat-instance"
  }
}