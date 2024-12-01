variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security_group"
  type        = string
}

variable "security_group_description" {
  description = "Description of the security_group"
  type        = string
}


variable "rules" {
  type = list(object({
    cidr_ipv4   = string
    from_port   = string
    to_port     = string
    ip_protocol = string
    description = string
  }))
}
