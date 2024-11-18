resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "k8s-nat-eip"
  }
}

resource "aws_nat_gateway" "k8s_nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id
  tags = {
    Name = "k8s-nat-gateway"
  }
}