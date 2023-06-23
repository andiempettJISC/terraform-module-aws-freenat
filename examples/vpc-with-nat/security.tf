resource "aws_security_group" "egress_only" {
  name        = "${local.name}-${local.env}-egress-only"
  description = "Allow egress only traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    description      = "Allow all egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.name}-${local.env}-egress-only"
  }
}