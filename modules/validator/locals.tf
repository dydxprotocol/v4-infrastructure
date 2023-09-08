locals {
  availability_zone_to_public_subnet_cidr = {
    for idx, val in var.cidr_public_subnets :
    var.availability_zones[idx] => val
  }
}
