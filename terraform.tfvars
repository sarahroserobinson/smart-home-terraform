vpc_name           = "micro-services-vpc"
vpc_cidr_range     = "10.0.0.0/20"
availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
public_subnets     = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
private_subnets    = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
instance_type      = "t2.micro"
# ami_id_lighting_server = "ami-0e6ba473035021977"
# ami_id_heating_server  = "ami-071bc604218b1e5d7"
# ami_id_status_server   = "ami-011f5b87edc3fad57"
database_tables_names = ["lighting", "heating"]
server_names          = ["lighting", "heating", "status"]
ami_ids               = ["ami-0e6ba473035021977", "ami-071bc604218b1e5d7", "ami-011f5b87edc3fad57"]

