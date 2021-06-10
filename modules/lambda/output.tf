output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.acg-etl.arn
}


output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.acg-etl.function_name
}