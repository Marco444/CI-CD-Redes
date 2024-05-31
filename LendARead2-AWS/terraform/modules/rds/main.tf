resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = format("%s-%s", "db_subnet_group", var.env)
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "lendaread_db" {
  identifier             = format("%s-%s", "db-instance", var.env)
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az               = var.multi_az_rds
  storage_type           = "gp2"
  skip_final_snapshot    = true
}

