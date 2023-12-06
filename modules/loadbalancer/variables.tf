variable "vpc_id" {
  type        = string
  description = "vpc id to be used in creating load balancer"
}

variable "server_instance_ids" {
    type = list(string)
    description = "instance ids of servers to be used in target group for loadbalancer"
}

variable "security_groups_ids" {
  type        = list(string)
  description = "ids of all security groups"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "ids of all public subnets"
}