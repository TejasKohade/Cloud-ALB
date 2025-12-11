terraform {
  required_version = ">= 1.0"
}

module "vpc" {
  source        = "../../modules/vpc"
  vpc_cidr      = var.vpc_cidr
  az_count      = var.az_count
  subnet_count  = var.subnet_count
  tags          = var.tags
}

module "instances" {
  source               = "../../modules/instances"
  subnet_ids           = module.vpc.subnet_ids
  vpc_id               = module.vpc.vpc_id
  instances_per_subnet = var.instances_per_subnet
  tags                 = var.tags
}

module "alb" {
  source          = "../../modules/alb"
  subnet_ids      = module.vpc.subnet_ids
  vpc_id          = module.vpc.vpc_id
  # preferred: pass map (stable keys)
  instance_id_map = module.instances.instance_ids_map
  tags            = var.tags
}
