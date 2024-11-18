variable "route_table_name" {
  description = "Name of the route table"
}

variable "cidr_block_vpc" {
  description = "CIDR block of the VPC"
}

variable "vpc_id" {
  description = "ID of the vpc"
}

variable "internet_gateway_id" {
  description = "ID of the internet gateway"
  default     = ""
}

variable "nat_gateway_id" {
  description = "NAT gateway id"
  default     = ""
}

variable "is_public" {
  description = "Decides whether to create a public or private route table"
  type        = bool
}