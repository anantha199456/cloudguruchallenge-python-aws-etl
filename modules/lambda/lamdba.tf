#tA Lambda layer is a . zip file archive that can contain additional code or data. A
# layer can contain libraries,
# a custom runtime, data, or configuration files
resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = var.lambda_layer_name
  s3_bucket = var.s3_bucket_layer
  s3_key = var.s3_key_layer
}

resource "aws_lambda_function" "acg-etl" {
  function_name = var.lambda_function_name
  role = aws_iam_role.lambda_sns_role01.arn
  handler = var.lambda_handler
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout
  s3_bucket = var.s3_bucket
  s3_key = var.s3_key
  depends_on = [
    aws_iam_role.lambda_sns_role01
  ]
  layers = [
    aws_lambda_layer_version.lambda_layer.arn
  ]
  environment {
    variables = {
      "rds_host" = var.rds_host
      "rds_database_name" = var.rds_database_name
      "rds_username" = var.rds_username
      "rds_password" = var.rds_password
      "rds_port" = var.port
      "sns_topic" = var.sns_arn
      "sns_arn" = var.sns_arn
       db_table = "covid"
       ny_url = "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us.csv"
       jh_url = "https://raw.githubusercontent.com/datasets/covid-19/master/data/time-series-19-covid-combined.csv?opt_id=oeu1603289369465r0.029250972293521915"
    }
  }
}