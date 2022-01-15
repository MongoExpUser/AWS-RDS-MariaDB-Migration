# ******************************************************************************************************************
# *  outputs.tf                                                                                                    *
# ******************************************************************************************************************
# *                                                                                                                *
# *  Project: Migration Project                                                                                    *
# *                                                                                                                *
# *  Copyright © 2022 MongoExpUser. All Rights Reserved.                                                           *
# *                                                                                                                *
# ******************************************************************************************************************


# 1.
output "db_subnet_group_attributes" {
  description = "key-value pair attributes of the created db subnet group"
  value = aws_db_subnet_group.db_subnet_group
}

# 2.
output "db_parameter_group_attributes" {
  description = "key-value pair attributes of the created db parameter group"
  value = aws_db_parameter_group.db_parameter_group
}

# 3.
output "db_security_group_attributes" {
  description = "key-value pair attributes of the created security group"
  value = aws_security_group.db_security_group
}

# 4.
output "db_credentials_attributes" {
  description = "key-value pair of the master user's credentials (username and password)"
  value = jsondecode(aws_secretsmanager_secret_version.secret_version.secret_string)
  sensitive = true
}

# 5.
output "rds_monitoring_role_arn" {
  description = "ARN of the created enhanced monitoring role"
  value = aws_iam_role.rds_monitoring_role.arn
}

# 6a.
output "primary_instance_attributes" {
  description = "key-value pair attributes of the created primary instance"
  value = aws_db_instance.primary_instance
  sensitive = true
}

# 6b.
output "replica_instance_attributes" {
  description = "key-value pair attributes of the created replica instance(s)"
  value = aws_db_instance.replica_instance
  sensitive = true
}
