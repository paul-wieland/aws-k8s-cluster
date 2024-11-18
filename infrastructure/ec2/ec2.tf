data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "node" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amzn-linux-2023-ami.id
  instance_type               = var.instance_size
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  tags = {
    Name = format("%s-%02d", var.label_name, count.index)
  }
}