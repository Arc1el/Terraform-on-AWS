resource "aws_db_subnet_group" "db_subnet1" {
  name           = "rds-${local.name}-db-subnet-prod"                                        # DB Subnet Group 이름
  subnet_ids     = local.rds_db_subent       # Subnet ID
  description    = "database subnet"

  tags = {
    Name = "rds-${local.name}-db-subnet-prod"
  }
}