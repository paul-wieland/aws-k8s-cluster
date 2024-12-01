variable "region" {
  type    = string
  default = "us-east-1"
}

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

variable "ami-name" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "host_username" {
  type    = string
  default = "ubuntu"
}

variable "worker_instance_type" {
  type    = string
  default = "t2.medium"
}

# K8s control plane requires at least 2 cpus and 2GB ram
variable "control_plane_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "bastion_host_instance_type" {
  type    = string
  default = "t2.micro"
}
