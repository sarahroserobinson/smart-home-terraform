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

