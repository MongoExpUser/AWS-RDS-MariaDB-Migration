# ******************************************************************************************************************
# *  dev.auto.tfvars                                                                                               *
# ******************************************************************************************************************
# *                                                                                                                *
# *  Project: Migration Project                                                                                    *
# *                                                                                                                *
# *  Copyright © 2022 MongoExpUser. All Rights Reserved.                                                           *
# *                                                                                                                *
# *                                                                                                                *
# ******************************************************************************************************************


# 0. organization identifier, project, creator environmental, region, and tagging variables
org_identifier                            = "org"
project_name                              = "mgr"
region                                    = "us-east-1"
creator                                   = "Terraform"
environment                               = "dev"
map_dba                                   = "map-dba"

# 1. db subnet group variables
db_subnet_group_description               = "Mgr DB Subnet Group"
db_subnet_group_name                      = "db-subnet-group"
db_subnet_ids                             = ["subnet-0d141dd23929f0eb3", "subnet-09d9ce03690b79111", "subnet-086966d54848d70f9"]

# 2. db parameter group variables
db_parameter_group_name                   = "db-parameter-group"
db_parameter_group_family                 = "mariadb10.5"
db_parameter_group_description            = "Mgr DB Parameter Group"

# 3. security group variables
security_group_name                       = "mariadb-sg"
security_group_description                = "Allow SSH and DB ports"
vpc_id                                    = "vpc-06e79d3c234efea71"
ingress_ssh_description                   = "SSH Access"
ingress_ssh_port                          = 22
ingress_protocol                          = "tcp"
ingress_cidr_blocks                       = ["172.31.0.0/16"]
ingress_db_description                    = "MariaDB Access"
ingress_db_port                           = 3306
egress_port                               = 0
egress_protocol                           =  "-1"
egress_cidr_blocks                        = ["0.0.0.0/0"]

# 4. credentials-related  variables i.e. variables for random password, secret random uuid, secret & secret version
random_password_length                    = 20
random_password_true                      = true
random_password_override_special          = "!#$&*()-_=[]{}<>:?"
recovery_window_in_days                   = 7
secret_description                        = "Mgr Postgres Credentials"
secret_tag_value                          = "mgr-postgres-credentials"
aws_secretsmanager_secret_name            = "mgr-postgres-secret"
username                                  = "admin"

# 5. rds monitoring role variable(s)
rds_monitoring_role_name                  = "rds-monitoring-role"

# 6. primary and replica instances' variables
database_name                             = "migrationDB"
instance_identifier                       = "mgr"
allocated_storage                         = 20
max_allocated_storage                     = 50
storage_type                              = "gp2"
storage_encrypted                         = true
engine                                    = "mariadb"
engine_version                            = "10.5.13"
publicly_accessible                       = true
instance_class                            = "db.t3.micro"
allow_major_version_upgrade               = true
auto_minor_version_upgrade                = true
apply_immediately                         = true
monitoring_interval                       = 60
backup_retention_period                   = 30
preferred_backup_window                   = "20:00-22:30"
preferred_maintenance_window              = "sun:12:05-sun:14:35"
performance_insights_enabled              = true
copy_tags_to_snapshot                     = true
deletion_protection                       = false
enabled_cloudwatch_logs_exports           = ["audit", "error", "general", "slowquery"]
skip_final_snapshot                       = true
final_snapshot_identifier                 = "mgr-snapshot"
multi_az                                  = false
performance_insights_retention_period     = 7
number_of_replica                         = 1
