locals {
  rds_identifier = "db-peteasy-prod"
  rds_instance_class = "db.t3.small"
  rds_db_subent = [module.vpc.subnet_id["05.sub-${local.name}-prod-db-a-01"], module.vpc.subnet_id["06.sub-${local.name}-prod-db-c-01"]]
  rds_user = "admin"
  rds_password = "peteasyadmin12!!"
}

# ################################################################################
# # RDS 생성
# ################################################################################

resource "aws_db_instance" "rds_1" {
  identifier              = "${local.rds_identifier}"
  instance_class         = "${local.rds_instance_class}"
  allocated_storage      = 300
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = "${local.rds_user}"
  password               = "${local.rds_password}"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet1.name
  vpc_security_group_ids = [aws_security_group.sg_db.id]
  parameter_group_name   = "default.mysql8.0"
  publicly_accessible    = true
  skip_final_snapshot    = true
}
