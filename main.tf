# Arquivo principal que chama os módulos

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "ec2" {
  source            = "./modules/ec2"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id
  security_group_id = module.vpc.security_group_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
}

module "elastic_ip" {
  source                        = "./modules/elastic_ip"
  docker_jenkins_instance_id    = module.ec2.docker_jenkins_instance_id
  grafana_prometheus_instance_id = module.ec2.grafana_prometheus_instance_id
}