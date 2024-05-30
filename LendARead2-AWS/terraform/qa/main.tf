
module "main" {
  source                    = "../modules/main"
  ecs_task_cpu_architecture = "X86_64"
  aws_region                = "us-east-1"
  vpc_cidr                  = "10.2.0.0/16"
  multi_az_rds              = var.multi_az_rds
  role                      = var.role
  rds_password              = var.rds_password
  env                       = "qa"
}
