variable "vpc_name" {
  type        = string
  description = "name of vpc"
}

variable "vpc_cidr_range" {
  type        = string
  description = "CIDR range for vpc"
}
variable "availability_zones" {
  type        = list(string)
  description = "availability zones for use in VPC module"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR ranges for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR ranges for private subnets"
}

variable "instance_type" {
  type        = string
  description = "type of instance to be used for creating lighting EC2 instance"
}


variable "ami_ids" {
  type        = list(string)
  description = "AMI ids to use in lighting, heating, status servers"
}

variable "database_tables_names" {
  type        = list(string)
  description = "names for dynamodb tables"
}

variable "service_names" {
  type        = list(string)
  description = "names for servers"
}


variable "target_group_paths" {
  type        = list(string)
  description = "paths for servers to be used in loadbalancer target groups"
}

variable "key_name" {
  type        = string
  description = "name of security key"
}
