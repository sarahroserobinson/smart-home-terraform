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
