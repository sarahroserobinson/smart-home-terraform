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

variable "ami_id_lighting_server" {
  type = string
  description = "AMI id to use in lighting EC2 instance"
  
}