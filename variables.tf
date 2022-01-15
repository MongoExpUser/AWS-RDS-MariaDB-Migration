# ******************************************************************************************************************
# *  variables.tf                                                                                                  *
# ******************************************************************************************************************
# *                                                                                                                *
# *  Project: Migration Project                                                                                    *
# *                                                                                                                *
# *  Copyright © 2022 MongoExpUser. All Rights Reserved.                                                           *
# *                                                                                                                *
# ******************************************************************************************************************


# 0. organization identifier, project, region, creator, environmental, and tagging variables
variable "org_identifier" {
  type = string
}

variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "creator" {
  description = "creator of the resource(s): could be e-mail address of creator or simply Terraform."
  type = string
}

variable "environment" {
  description = "Value to put in the environment slug. Provided by the CICD tool."
  type = string
}

variable "map_dba" {
  type = string
}


# 1. db subnet group variables
variable "db_subnet_group_description" {
  type = string
}

variable "db_subnet_group_name"{
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}


# 2. db parameter group variables
variable "db_parameter_group_name" {
  type = string
}

variable "db_parameter_group_family" {
  type = string
}

variable "db_parameter_group_description" {
  type = string
}

variable "db_parameter_name_one" {
  type = string
}

variable "db_parameter_name_one_value" {
  type = string
}

variable "db_parameter_group_apply_method" {
  type = string
}


# 3. security group variables
variable "security_group_name" {
  type = string
}

variable "security_group_description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_ssh_description" {
  type = string
}

variable "ingress_ssh_port" {
  type = number
}

variable "ingress_protocol" {
  type = string
}

variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "ingress_db_description" {
  type = string
}

variable "ingress_db_port" {
  type = number
}

variable "egress_port" {
  type = number
}

variable "egress_protocol" {
  type = string
}

variable "egress_cidr_blocks" {
  type = list(string)
}


# 4. credentials-related  variable i.e. variables for: random password, secret random uuid, secret & secret version
variable "random_password_length" {
  type = number
  default = 20
}

variable "random_password_true" {
  type = bool
  default = true
}

variable "random_password_override_special" {
  description = "A customized list of random special characters to be included in the password. The list overides the default special characters."
  type  = string
}

variable "recovery_window_in_days" {
  type = number
  default = 7
}

variable "secret_description" {
  type = string
}

variable "secret_tag_value" {
  type = string
}

variable "aws_secretsmanager_secret_name" {
  type = string
}

variable "username" {
  default = "admin"
}


# 5. rds monitoring role variable(s)
variable "rds_monitoring_role_name" {
  type = string
}


# 6. primary and replica instances' variables
variable "instance_identifier" {
  type = string
}

variable "database_name" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "max_allocated_storage" {
 type = number
}

variable "storage_type" {
  type = string
}

variable "storage_encrypted" {
   type = bool
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "publicly_accessible" {
  type = bool
}

variable "instance_class" {
 type = string
}

variable "allow_major_version_upgrade" {
  type = bool
}

variable "auto_minor_version_upgrade" {
  type = bool
}

variable "apply_immediately" {
  type = bool
}

variable "monitoring_interval" {
  type = number
}

variable "backup_retention_period" {
  type = number
}

variable "preferred_backup_window" {
  type = string
}

variable "preferred_maintenance_window" {
  type = string
}

variable "performance_insights_enabled" {
  type = bool
}

variable "copy_tags_to_snapshot" {
  type = bool
  default = true
}

variable "deletion_protection" {
  type = bool
}

variable "enabled_cloudwatch_logs_exports" {
  type = list(string)
}

variable "skip_final_snapshot"{
  type = bool
}

variable "final_snapshot_identifier"{
  type = string
}

variable "multi_az" {
  type = bool
}

variable "performance_insights_retention_period" {
  type = number
}

variable "number_of_replica" {
  type = number
}
