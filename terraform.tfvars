vpc_name           = "micro-services-vpc"
vpc_cidr_range     = "10.0.0.0/20"
availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
public_subnets     = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
private_subnets    = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]