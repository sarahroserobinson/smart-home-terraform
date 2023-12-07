variable "security_groups_ids" {
  type        = list(string)
  description = "ids of all security groups"
}

variable "instance_type" {
  type        = string
  description = "type of instance to be used for creating lighting EC2 instance"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "ids of all public subnets"
}

variable "service_names" {
  type        = list(string)
  description = "names for servers"
}

variable "ami_ids" {
  type        = list(string)
  description = "AMI ids to use in lighting, heating, status servers"
}

variable "key_name" {
  type        = string
  description = "name of security key"
}
