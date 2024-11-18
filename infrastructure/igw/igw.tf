resource "aws_internet_gateway" "k8s-internet-gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name = "k8s-internet-gateway"
  }
}
