[![CI - MariaDB Migration](https://github.com/MongoExpUser/AWS-RDS-MariaDB-Migration/actions/workflows/mariadb.yml/badge.svg)](https://github.com/MongoExpUser/AWS-RDS-MariaDB-Migration/actions/workflows/mariadb.yml)
# README #

This README summaries the contents of this repository.

### What is this repository for? ###
* Deployment of AWS RDS MariaDB instances (primary & replica(s)) and related resources for database migration.
* The number of replica can vary between 1 and 5. If the number of replica is set to zero on the **.tfvara file**, no replica is deployed.
* Version 1.0

### Deployed resoures ###
* AWS RDS DB subnet group
* AWS RDS DB parameter group
* AWS VPC security group 
* AWS secret manager secret
* AWS RDS enhanced monitoring IAM role 
* AWS RDS PostgreSQL DB instance 

### Repo usage ###
* Database migration
* Deployment instructions: use GitHub-Actions-Workflow
* Deployment yml file: **.github/workflows/mariadb.yml file** 

### Contribution guidelines ###
* Create branch
* Add codes
* Submit pull request for code review

### Who do I talk to? ###
* Repo owner or admin


### Authors and acknowledgment
* MongoExpUser

###  License

 * [MIT](https://github.com/MongoExpUser/AWS-RDS-MariaDB-Migration/blob/main/LICENSE)
