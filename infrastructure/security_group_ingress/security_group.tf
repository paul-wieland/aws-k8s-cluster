resource "aws_security_group" "security_group" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  count = length(var.rules)

  security_group_id = aws_security_group.security_group.id
  description       = var.rules[count.index].description
  cidr_ipv4         = var.rules[count.index].cidr_ipv4
  from_port         = var.rules[count.index].from_port
  ip_protocol       = var.rules[count.index].ip_protocol
  to_port           = var.rules[count.index].to_port
}