provider "aws" {
  region     = "us-east-1"
  access_key = "XXX"
  secret_key = "XXX"
}


#-------------------------------------------------------------------
module "vpc" {
  source         = "./vpc"
  cidr_block_vpc = var.cidr_block_vpc
}
#-------------------------------------------------------------------
# IGW
module "igw" {
  source = "./igw"
  vpc_id = module.vpc.vpc_id
}

# Public Route Table
module "public_route_table" {
  source              = "./route_table"
  cidr_block_vpc      = var.cidr_block_vpc
  is_public           = true
  internet_gateway_id = module.igw.internet_gateway_id
  route_table_name    = "k8s-public-route-table"
  vpc_id              = module.vpc.vpc_id
  depends_on = [
    module.igw, module.vpc
  ]
}

#-------------------------------------------------------------------
module "public_subnet" {
  source      = "./subnet"
  cidr_block  = var.cidr_block_public_subnet
  subnet_name = "k8s-public-subnet"
  vpc_id      = module.vpc.vpc_id
  depends_on  = [module.vpc]
}
module "public_subnet_route_table_association" {
  source         = "./route_table_association"
  route_table_id = module.public_route_table.route_table_id
  subnet_id      = module.public_subnet.subnet_id
  depends_on     = [module.public_subnet, module.public_route_table]
}

module "nat" {
  source           = "./nat"
  public_subnet_id = module.public_subnet.subnet_id
}

#-------------------------------------------------------------------
module "private_subnet" {
  source      = "./subnet"
  cidr_block  = var.cidr_block_private_subnet
  subnet_name = "k8s-private-subnet"
  vpc_id      = module.vpc.vpc_id
  depends_on  = [module.vpc]
}

module "private_route_table" {
  source           = "./route_table"
  cidr_block_vpc   = var.cidr_block_vpc
  is_public        = false
  nat_gateway_id   = module.nat.nat_id
  route_table_name = "k8s-private-route-table"
  vpc_id           = module.vpc.vpc_id
  depends_on = [
    module.nat, module.vpc
  ]
}

module "private_subnet_route_table_association" {
  source         = "./route_table_association"
  route_table_id = module.private_route_table.route_table_id
  subnet_id      = module.private_subnet.subnet_id
  depends_on     = [module.private_subnet, module.private_route_table]
}
#-------------------------------------------------------------------
module "allow_ingress_ssh" {
  source                     = "./security_group_ingress"
  cidr_ipv4                  = "0.0.0.0/0"
  from_port                  = 22
  security_group_description = "Allow incoming ssh connection"
  security_group_name        = "allow-incoming-ssh"
  to_port                    = 22
  vpc_id                     = module.vpc.vpc_id
  depends_on                 = [module.vpc]
}

module "allow_all_egress" {
  source                     = "./security_group_egress"
  security_group_description = "Allow all egress connections"
  security_group_name        = "allow-all-egress"
  vpc_id                     = module.vpc.vpc_id
  depends_on                 = [module.vpc]
}

#-------------------------------------------------------------------
module "ssh_key" {
  source          = "./key_pair"
  key_name        = "ssh-key"
  public_key_path = "../keys/ssh_key.pub"
}
#-------------------------------------------------------------------
module "control_plane" {
  source                      = "./ec2"
  label_name                  = "control-plane"
  subnet_id                   = module.private_subnet.subnet_id
  associate_public_ip_address = false
  key_name                    = module.ssh_key.key_name
  security_group_ids = [
    module.allow_ingress_ssh.id,
    module.allow_all_egress.id
  ]
  depends_on = [module.private_subnet, module.allow_ingress_ssh, module.allow_all_egress, module.ssh_key]
}

module "worker" {
  source                      = "./ec2"
  label_name                  = "worker"
  instance_count              = 1
  subnet_id                   = module.private_subnet.subnet_id
  associate_public_ip_address = false
  key_name                    = module.ssh_key.key_name
  security_group_ids = [
    module.allow_ingress_ssh.id,
    module.allow_all_egress.id
  ]
  depends_on = [module.private_subnet, module.allow_ingress_ssh, module.ssh_key]
}

module "bastion_host" {
  source                      = "./ec2"
  label_name                  = " bastion-host"
  subnet_id                   = module.public_subnet.subnet_id
  associate_public_ip_address = true
  key_name                    = module.ssh_key.key_name
  security_group_ids          = [module.allow_ingress_ssh.id, module.allow_all_egress.id]
  depends_on = [module.public_subnet,
    module.allow_all_egress,
    module.allow_ingress_ssh,
    module.ssh_key
  ]
}

#-------------------------------------------------------------------

resource "local_file" "hosts" {
  content = templatefile("../templates/hosts.tpl",
    {
      cluster_name            = module.vpc.cluster_name
      control_plane_instances = module.control_plane.instances
      worker_instances        = module.control_plane.instances
      bastion_user            = "ec2-user"
      bastion_ip              = module.bastion_host.instances[0].public_ip
    }
  )
  filename = "../generated/hosts.ini"
}
