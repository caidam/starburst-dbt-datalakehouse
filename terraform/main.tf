# data "aws_iam_user" "s3_user" {
#   user_name = var.user_name
# }

# s3 bucket
resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3-bucket.id

  policy = <<-POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": "${aws_iam_user.s3_user.arn}"},
      "Action": ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }
  ]
}
POLICY
}

# s3 policy
# "Action": ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket"],
# "Action": ["s3:*"],
resource "aws_iam_policy" "s3_policy" {
  # name        = "MyS3Policy"
  # description = "My test S3 policy"
  name        = "${var.bucket_name}-s3-policy"
  description = "S3 policy giving permissions to the bucket"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${var.bucket_name}/*"]
    }
  ]
}
EOF
}

# dedicated iam user
resource "aws_iam_user" "s3_user" {
  name = var.user_name
  path = "/system/"
}

resource "aws_iam_access_key" "s3_user_keys" {
  user = aws_iam_user.s3_user.name
}

resource "aws_iam_user_policy_attachment" "s3_user_policy_attachment" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# # save credentials
# resource "null_resource" "credentials_file" {
#   provisioner "local-exec" {
#     command = <<-EOF
#       echo AWS_ACCESS_KEY=${aws_iam_access_key.s3_user_keys.id} > ../.env &&
#       echo AWS_SECRET_KEY=${aws_iam_access_key.s3_user_keys.secret} >> ../.env &&
#       echo S3_BUCKET_NAME=${var.bucket_name} >> ../.env &&
#       echo AWS_DEFAULT_REGION=${var.default_region} >> ../.env
#     EOF
#   }
#   depends_on = [aws_iam_access_key.s3_user_keys]
# }


# Create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["3.144.141.32/28", "176.138.173.18/32", "0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine            = "mysql"
  identifier        = "myrdsinstance"
  allocated_storage = 20
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"
  username          = "admin"
  password          = var.db_instance_password
  publicly_accessible  = true
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  allow_major_version_upgrade = true
}

# Populate the database
resource "null_resource" "db_setup" {
  provisioner "local-exec" {
    command = "mysql --host=${aws_db_instance.myinstance.address} --user=${aws_db_instance.myinstance.username} --password=${aws_db_instance.myinstance.password} < ../db_script/setup.sql"
  }
}

# save credentials
resource "null_resource" "credentials_file" {
  provisioner "local-exec" {
    command = <<-EOF
      echo AWS_ACCESS_KEY=${aws_iam_access_key.s3_user_keys.id} > ../.env &&
      echo AWS_SECRET_KEY=${aws_iam_access_key.s3_user_keys.secret} >> ../.env &&
      echo S3_BUCKET_NAME=${var.bucket_name} >> ../.env &&
      echo AWS_DEFAULT_REGION=${var.default_region} >> ../.env &&
      echo DB_INSTANCE_IDENTIFIER=${aws_db_instance.myinstance.identifier} >> ../.env &&
      echo DB_USERNAME=${aws_db_instance.myinstance.username} >> ../.env &&
      echo DB_PASSWORD=${aws_db_instance.myinstance.password} >> ../.env &&
      echo DB_HOST=${aws_db_instance.myinstance.endpoint} >> ../.env
    EOF
  }
  depends_on = [aws_iam_access_key.s3_user_keys, aws_db_instance.myinstance]
}