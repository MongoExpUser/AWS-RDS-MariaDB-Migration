# ******************************************************************************************************************
# *  main.tf                                                                                                       *
# ******************************************************************************************************************
# *                                                                                                                *
# *  Project: Migration Project                                                                                    *
# *                                                                                                                *
# *  Copyright © 2022 MongoExpUser. All Rights Reserved.                                                           *
# *                                                                                                                *
# *  This module implements the deployment of RDS MariaDB DB instance and related                                  *
# *  resources for the migration of On-Prem MariaDB database to RDS MariaDB.                                       *
# *                                                                                                                *
# *  The following resources are created:                                                                          *
# *                                                                                                                *
# *   1)  AWS RDS DB Subnet Group                                                                                  *
# *                                                                                                                *
# *   2)  AWS RDS DB Parameter Group                                                                               *
# *                                                                                                                *
# *   3)  AWS VPC Security Group for AWS RDS PostgreSQL Access                                                     *
# *                                                                                                                *
# *   4)  AWS Secret Manager's Secret (username and password) for the RDS MariaDB  Credential                      *
# *                                                                                                                *
# *   5)  AWS IAM Role that Provides Access to Cloudwatch for RDS Enhanced Monitoring of Instances                 *
# *                                                                                                                *
# *   6)  AWS RDS MariaDB DB Primary and Replica Instances - Migration Target                                      *
# *                                                                                                                *
# ******************************************************************************************************************


# configure provider(s) and backend
terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    random = {
      source = "hashicorp/random"
    }
  }


  backend "s3" {
    bucket  = var.state_bucket_name
    key     = "${var.state_key}-terraform.tfstate"
    region  = var.state_region
    encrypt = true
  }
  
}

# local variables
locals {
 aws_tags = {
    "environment" = var.environment
    "map-dba"     = var.map_dba
 }
}


# 0. create uuid, to be appended to to the following resources, to ensure uniqueness:
#    (a) the secret name => (uuid full string) and
#    (b) IAM role names, subnet group, parameter group, and security group => (uuid 4-element substring)
resource "random_uuid" "secret_random_uuid" { }

# 1. create db subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  depends_on                    = [random_password.random_password, random_uuid.secret_random_uuid]
  name                          = "${var.org_identifier}-${var.environment}-${var.db_subnet_group_name}-${substr(random_uuid.secret_random_uuid.result, 0, 4)}"
  description                   = var.db_subnet_group_description
  subnet_ids                    = var.db_subnet_ids

  tags = merge(
    {
        name                    = "${var.org_identifier}-${var.environment}-${var.db_subnet_group_name}-${substr(random_uuid.secret_random_uuid.result, 0, 4)}"
    },
    {
        creator                 = var.creator
    },
    local.aws_tags
  )
}


# 2. create db parameter group
resource "aws_db_parameter_group" "db_parameter_group" {
  depends_on                    = [random_password.random_password, random_uuid.secret_random_uuid]
  name                          = "${var.org_identifier}-${var.environment}-${var.db_parameter_group_name}-${substr(random_uuid.secret_random_uuid.result, 0, 4)}"
  family                        = var.db_parameter_group_family
  description                   = var.db_parameter_group_description

  parameter {
    name                        = var.db_parameter_name_one
    value                       = var.db_parameter_name_one_value
    apply_method                = var.db_parameter_group_apply_method
  }

  tags = merge(
    {
        name                    = "${var.org_identifier}-${var.environment}-${var.db_parameter_group_name}-${substr(random_uuid.secret_random_uuid.result, 0, 4)}"
    },
    {
        creator                 = var.creator
    },
    local.aws_tags
  )
}


# 3. create security group for db access
resource "aws_security_group" "db_security_group" {
  depends_on                    = [random_password.random_password, random_uuid.secret_random_uuid]
  name                          = "${var.org_identifier}-${var.environment}-${var.security_group_name}-${substr(random_uuid.secret_random_uuid.result, 0, 4)}"
  description                   = var.security_group_description
  vpc_id                        = var.vpc_id

  ingress {
    description                 = var.ingress_ssh_description
    from_port                   = var.ingress_ssh_port
    to_port                     = var.ingress_ssh_port
    protocol                    = var.ingress_protocol
    cidr_blocks                 = var.ingress_cidr_blocks
  }
  
 ingress {
    description                 = var.ingress_db_description
    from_port                   = var.ingress_db_port
    to_port                     = var.ingress_db_port
    protocol                    = var.ingress_protocol
    cidr_blocks                 = var.ingress_cidr_blocks
  }
  
  egress {
    from_port                   = var.egress_port
    to_port                     = var.egress_port
    protocol                    = var.egress_protocol
    cidr_blocks                 = var.egress_cidr_blocks
  }
  
  tags = merge(
    {
        name                    = "${var.org_identifier}-${var.environment}-${var.security_group_name}-${substr(random_uuid.secret_random_uuid.result, 0, 4)}"
        Name                    = "${var.org_identifier}-${var.environment}-${var.security_group_name}-${substr(random_uuid.secret_random_uuid.result, 0, 4)}"
    },
    {
        creator                 = var.creator
    },
    local.aws_tags
  )
}


# 4. create database credential
# a. create password to be used as database password
resource "random_password" "random_password" {
  length                        =  var.random_password_length
  special                       =  var.random_password_true
  lower                         =  var.random_password_true
  upper                         =  var.random_password_true
  number                        =  var.random_password_true
  override_special              =  var.random_password_override_special
}

# b. create secret manager's secret - for storing credential
resource "aws_secretsmanager_secret" "secret" {
  depends_on                    = [random_password.random_password, random_uuid.secret_random_uuid]
  name                          = "${var.org_identifier}-${var.environment}-${var.aws_secretsmanager_secret_name}-${random_uuid.secret_random_uuid.result}"
  description                   = var.secret_description
  recovery_window_in_days       = var.recovery_window_in_days
  tags = merge(
    {
        name                    = "${var.org_identifier}-${var.environment}-${var.aws_secretsmanager_secret_name}-${random_uuid.secret_random_uuid.result}"
    },
    {
        creator                 = var.creator
    },
    local.aws_tags
  )
}

# c. create local variables for referencing purpose
locals {
  depends_on                    = [aws_secretsmanager_secret.secret]
  credentials = {
    username                     = var.username
    password                     = random_password.random_password.result
  }
}

# d. create secret version - stores the credential (username and password) in secret manager's secret
resource "aws_secretsmanager_secret_version" "secret_version" {
  depends_on                     = [aws_secretsmanager_secret.secret]
  secret_id                      = aws_secretsmanager_secret.secret.id
  secret_string                  = jsonencode(local.credentials)
}


# e. create monitoring role for enabling "enhanced monitoring" that provides access to Cloudwatch for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  depends_on  = [aws_secretsmanager_secret_version.secret_version]
  name = "${var.org_identifier}-${var.environment}-${var.rds_monitoring_role_name}-${substr(random_uuid.secret_random_uuid.result, 0, 4)}"
  path = "/"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = "AllowRDSMonitoringToAssumeRole"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })
}


# 6. create primary and replica instances
# a. primary
resource "aws_db_instance" "primary_instance" {
  depends_on                            = [aws_iam_role.rds_monitoring_role,
                                           aws_db_subnet_group.db_subnet_group,
                                           aws_db_parameter_group.db_parameter_group,
                                           aws_secretsmanager_secret_version.secret_version]
  name                                  = var.database_name
  identifier                            = "${var.org_identifier}-${var.environment}-${var.instance_identifier}"
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  storage_type                          = var.storage_type
  storage_encrypted                     = var.storage_encrypted
  engine                                = var.engine
  engine_version                        = var.engine_version
  publicly_accessible                   = var.publicly_accessible
  instance_class                        = var.instance_class
  username                              = local.credentials.username
  password                              = local.credentials.password
  parameter_group_name                  = aws_db_parameter_group.db_parameter_group.name
  db_subnet_group_name                  = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids                = [aws_security_group.db_security_group.id]
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = aws_iam_role.rds_monitoring_role.arn
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.preferred_backup_window
  maintenance_window                    = var.preferred_maintenance_window
  performance_insights_enabled          = var.performance_insights_enabled
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  deletion_protection                   = var.deletion_protection
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  skip_final_snapshot                   = var.skip_final_snapshot
  final_snapshot_identifier             = "${var.org_identifier}-${var.environment}-${var.final_snapshot_identifier}"
  performance_insights_retention_period = var.performance_insights_retention_period
  multi_az                              = var.multi_az
  
  tags = merge(
    {
        name                            = "${var.org_identifier}-${var.environment}-${var.instance_identifier}"
    },
    {
        creator                         = var.creator
    },
    local.aws_tags
  )
}

# b. replica(s)
resource "aws_db_instance" "replica_instance" {
  depends_on                            = [aws_db_instance.primary_instance]
  count                                 = var.number_of_replica
  replicate_source_db                   = aws_db_instance.primary_instance.identifier
  identifier                            = "${var.org_identifier}-${var.environment}-${var.instance_identifier}-replica-${count.index+1}"
  engine                                = var.engine
  engine_version                        = var.engine_version
  publicly_accessible                   = var.publicly_accessible
  instance_class                        = var.instance_class
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  storage_encrypted                     = var.storage_encrypted
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled          = var.performance_insights_enabled
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  deletion_protection                   = var.deletion_protection
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  performance_insights_retention_period = var.performance_insights_retention_period
  
  tags = {
    name                                = "${var.org_identifier}-${var.environment}-${var.instance_identifier}-replica-${count.index}"
    creator                             = var.creator
  }
}

