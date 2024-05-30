resource "aws_cloudwatch_log_group" "lendaread_log_group" {
  name              = format("%s-%s", var.ecs_log_name, var.env)
  retention_in_days = 14
}

