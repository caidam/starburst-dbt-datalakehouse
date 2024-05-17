# variables

# aws & s3
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "user_name" {
  description = "The name of the IAM user"
  type        = string
}

variable "default_region" {
  description = "The name of the IAM user default region"
  type        = string
}

variable "db_instance_password" {
  description = "The password of the database instance"
}