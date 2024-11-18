# VPC
resource "aws_vpc" "k8s-vpc" {
  cidr_block           = var.cidr_block_vpc
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "k8s-vpc"
  }
}