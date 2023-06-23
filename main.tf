resource "aws_eip" "nat_instance_ip" {
  domain            = "vpc"
}

resource "aws_eip_association" "nat_instance_accoc" {
  network_interface_id = aws_network_interface.nat_instance_interface.id
  allocation_id = aws_eip.nat_instance_ip.id
}

resource "aws_network_interface" "nat_instance_interface" {
  subnet_id         = var.vpc_public_subnets[0]
  source_dest_check = false
  security_groups   = [aws_security_group.nat_instance.id]

  tags = {
    Name = "${var.name}-${var.env}-nat-instance"
  }
}

resource "aws_instance" "nat_instance" {
  ami           = data.aws_ami.ubuntu_arm_ami.id
  instance_type = "t4g.small"
  network_interface {
    network_interface_id = aws_network_interface.nat_instance_interface.id
    device_index         = 0
  }

  user_data_replace_on_change = true
  metadata_options {
    http_tokens = "required"
  }
  iam_instance_profile = var.instance_profile_name
  user_data            = <<EOT
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
/usr/sbin/iptables -t nat -A POSTROUTING -s ${local.vpc_cidr_block} -j MASQUERADE
  EOT

  tags = {
    Name = "${var.name}-${var.env}-nat-instance"
  }
}

resource "aws_route" "nat_instance_route" {
  for_each = local.vpc_private_route_table_ids

  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.nat_instance_interface.id
}