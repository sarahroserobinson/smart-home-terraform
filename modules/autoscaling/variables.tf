variable "service_names" {
  type        = list(string)
  description = "names of servers to be used for launch templates"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "ids of all public subnets"
}

variable "ami_ids" {
  type        = list(string)
  description = "instance amis to be used to create servers in launch template"
}

variable "key_name" {
  type        = string
  description = "name of security key"
}

variable "security_groups_ids" {
  type        = list(string)
  description = "ids of all security groups"
}

variable "instance_type" {
  type        = string
  description = "type of instance to be used for creating lighting EC2 instance"
}

variable "load_balancer_target_group_arns" {
  type        = list(string)
  description = "arns of load balancer target groups for creating auto scaling groups"
}

variable "min_size" {
  type        = number
  description = "number of minimum instances"

}

variable "max_size" {
  type        = number
  description = "number of maximum instances"

}
variable "desired_capacity" {
  type        = number
  description = "number of desired instances"
}
