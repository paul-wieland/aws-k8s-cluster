resource "aws_route_table" "public_route_table" {
  count  = var.is_public ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  route {
    cidr_block       = var.cidr_block_vpc
    local_gateway_id = "local"
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table" "private_route_table" {
  count  = var.is_public ? 0 : 1
  vpc_id = var.vpc_id


  route {
    cidr_block       = var.cidr_block_vpc
    local_gateway_id = "local"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = var.route_table_name
  }
}