# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
   secret_key = var.AWS_SECRET_ACCESS_KEY
}

# credentials "app.terraform.io" {
#   token = "5moLf6q35wyF9g.atlasv1.stoxrkc3IgqRTkk66ZlGHZtDSdcjAV6P46I2Z4ql4gQ7JLyUTjeFJ9cvcf6Cr4BLVgQ"
# }


terraform {
  required_version = ">= 0.15.5"
}

#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "acg-etl"

#     workspaces {
#       name = "cgc-etl"
#     }
#   }

module "sns" {
  source = "../modules/sns"
  region = "us-east-1"
  sns_topic_name = "sns-acg-etl"
  display_name = "acg-etl-alert"
  stack_name = "CloudformationStackNameACGEtl"
  email_addresses = "anantha19945@gmail.com"
  ##email_addresses = "anantha19945@gmail.com"
}

module "cloudwatch_rule_event" {
  source = "../modules/cloudwatch_rule"
  region = "us-east-1"
  rule_name = "schedule-acg-etl"
  target_name = module.lambda_function.function_name
  lambda_function_arn = module.lambda_function.function_arn
  lambda_function_name = module.lambda_function.function_name
  schedule_expression = "cron(0 9 * * ? *)" #every 1 am
}

module "lambda_function" {
  source = "../modules/lambda"
  lambda_function_name = "acg-etl"
  lambda_handler = "etl_wrapper.main"
  lambda_runtime = "python3.7"
  lambda_timeout = 30
  s3_bucket = module.s3_create_bucket.s3_bucket
  s3_key = "acg-etl.zip"
  s3_bucket_layer = module.s3_create_bucket.s3_bucket
  s3_key_layer = "python.zip"
  rds_host = module.rds.rds_hostname
  rds_database_name = module.rds.rds_db_name
  rds_username = module.rds.rds_db_username
  rds_password = module.rds.rds_db_password
  port = module.rds.rds_port
  #send_notification = "True"
  sns_arn = module.sns.sns_topic_arn
  sns_topic = module.sns.sns_topic_arn
  depends_on = [
    module.s3_upload
  ]
  lambda_layer_name = "pythonlibs"
}

module "rds" {
  source = "../modules/rds"
}

module "s3_upload" {
  source = "../modules/s3_upload"
  region = "us-east-1"
  bucket = module.s3_create_bucket.s3_bucket
  acl = "public-read"
  upload_files_path = "./files_to_upload/"
  depends_on = [
    module.s3_create_bucket]
}

module "s3_create_bucket" {
  source = "../modules/s3"
  region = "us-east-1"
  bucket = "acglambdafiles"
  acl = "private"
}
