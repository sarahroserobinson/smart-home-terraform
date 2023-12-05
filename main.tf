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

module "lighting_service" {
  source                 = "./modules/lighting_service"
  security_groups_ids    = module.security.security_groups_ids
  instance_type          = var.instance_type
  public_subnet_ids      = module.vpc.public_subnets_ids
  ami_id_lighting_server = var.ami_id_lighting_server
}

module "database" {
  source = "./modules/database"
}