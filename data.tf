data "aws_ami" "ubuntu_arm_ami" {
  most_recent = true
  owners = [
    "099720109477"
  ]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}