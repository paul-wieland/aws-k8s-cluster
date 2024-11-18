variable "cidr_block_vpc" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cidr_block_private_subnet" {
  type    = string
  default = "10.0.1.0/24"
}

variable "cidr_block_public_subnet" {
  type    = string
  default = "10.0.2.0/24"
}