resource "aws_subnet" "k8s-subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block
  tags = {
    Name = var.subnet_name
  }
}