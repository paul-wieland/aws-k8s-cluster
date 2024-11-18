resource "aws_security_group" "security_group" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = var.from_port
  ip_protocol       = var.protocol
  to_port           = var.to_port
}