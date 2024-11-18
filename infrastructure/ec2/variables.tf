
variable "instance_count" {
  description = "Number of node instances"
  default     = 1
}

variable "instance_size" {
  description = "Instance size"
  default     = "t2.micro"
}

variable "label_name" {
  description = "Label name"
}

variable "subnet_id" {
  description = "Subnet where the node should be deployed to"
}

variable "associate_public_ip_address" {
  description = "Decide whether to associate a public ip or not"
  type        = bool
}

variable "security_group_ids" {
  description = "Security groups"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Name of the key"
  type        = string
}
