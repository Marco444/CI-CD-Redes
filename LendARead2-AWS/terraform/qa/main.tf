
module "main" {
  source            = "../modules/main"
  role="LabRole"
  rds_password="adjnb989ad##"
  ecs_task_cpu_architecture = "X86_64"
  aws_region = "us-east-1"
  multi_az_rds="false"
  vpc_cidr="10.2.0.0/16"
}
