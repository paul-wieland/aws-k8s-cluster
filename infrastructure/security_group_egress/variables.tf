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

variable "cidr_ipv4" {
  description = "Affected IP range"
  type        = string
  default     = "0.0.0.0/0"
}

variable "protocol" {
  description = "Protocol"
  type        = string
  default     = "-1"
}