data "aws_iam_role" "lab_role" {
  name = var.role
}


provider "aws" {
  region = var.aws_region
}


# module "ecr" {
#   source               = "../ecr"
#   aws_region           = var.aws_region
#   repository_name      = var.ecr_name
#   image_tag_mutability = var.ecr_mutability
#   branch               = var.branch_env
#   lb_url               = module.alb.alb_dns_name
# }

module "ecs" {
  source             = "../ecs"
  cluster_name       = var.cluster_name
  task_family        = var.task_family
  aws_region         = var.aws_region
  subnets            = [module.vpc.subnet_private1, module.vpc.subnet_private2]
  security_groups    = [module.security_groups.ecs_task_security_group_id]
  repository_url     = var.ecr_repository_url
  lb_dns_name        = module.alb.alb_dns_name
  db_endpoint        = module.rds.db_endpoint
  db_username        = module.rds.db_username
  db_password        = module.rds.db_password
  tg_arn             = module.alb.tg_arn
  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn
  cpu_architecture   = var.ecs_task_cpu_architecture
  ecs_log_group      = module.cloudwatch.ecs_log_group
  env                = var.env
  desired_count      = var.desired_count
}

module "alb" {
  source            = "../alb"
  vpc_id            = module.vpc.vpc_id
  alb_sg            = module.security_groups.lb_security_group_id
  public_subnets    = [module.vpc.subnet_public1, module.vpc.subnet_public2]
  alb_name          = var.alb_name
  target_group_name = var.alb_tg
  health_check_path = var.alb_health_path
  env               = var.env
}

module "rds" {
  source                 = "../rds"
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  username               = var.rds_username
  password               = var.rds_password
  subnet_ids             = [module.vpc.subnet_db1, module.vpc.subnet_db2]
  vpc_security_group_ids = [module.security_groups.rds_security_group_id]
  multi_az_rds           = var.multi_az_rds
  env                    = var.env
}

module "security_groups" {
  source = "../sg"
  vpc_id = module.vpc.vpc_id
  env    = var.env
}

module "vpc" {
  source              = "../vpc"
  cidr_vpc            = var.vpc_cidr
  availability_zone_1 = format("%s%s", var.aws_region, "a")
  availability_zone_2 = format("%s%s", var.aws_region, "b")
}

module "cloudwatch" {
  source       = "../cloudwatch"
  ecs_log_name = "/ecs/${var.task_family}"
  env          = var.env
}

