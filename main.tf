module "vpc" {
  source             = "./modules/vpc"
  vpc_name           = var.vpc_name
  vpc_cidr_range     = var.vpc_cidr_range
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "servers" {
  source              = "./modules/servers"
  security_groups_ids = module.security.security_groups_ids
  instance_type       = var.instance_type
  public_subnet_ids   = module.vpc.public_subnets_ids
  ami_ids             = var.ami_ids
  server_names        = var.server_names
}

module "database" {
  source                = "./modules/database"
  database_tables_names = var.database_tables_names
}

module "loadbalancer" {
  source              = "./modules/loadbalancer"
  vpc_id              = module.vpc.vpc_id
  server_instance_ids = module.servers.server_instance_ids
  security_groups_ids = module.security.security_groups_ids
  public_subnet_ids   = module.vpc.public_subnets_ids
}
