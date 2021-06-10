resource "aws_iam_role" "lambda_sns_role01" {
  name = "lambda_sns_role01"

  assume_role_policy = file("${path.module}/lambda-policy.json")
  description = "Allows Lambda functions to call AWS services on your behalf."
  force_detach_policies = false
}