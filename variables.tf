variable "vpc_id" {
  type = string
}

variable "vpc_public_subnets" {
  type = list(string)
}

variable "vpc_private_route_table_ids" {
  type = list(string)
}

variable "instance_profile_name" {
  default = null
  type    = string
}

variable "name" {

}

variable "env" {

}