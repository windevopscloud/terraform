provider "aws" {
  region = "eu-west-1"
}

# Customize with your own S3 bucket and DynamoDB table if you want to use a Remote Backend for State
terraform {
  backend "s3" {
    bucket         = "terraform-github-windevopscloud-poc-bucket"     # Update it 
    key            = "poc/terraform-github-windevopscloud-poc.tfstate" # Update it
    region         = "us-east-1"                            # Update it
    dynamodb_table = "terraform-github-windevopscloud-poc-lock"                       # Update it
    encrypt        = true
  }
}

resource "aws_budgets_budget" "zero_spend_budget" {
  name         = "ZeroSpendBudget"
  budget_type  = "COST"
  limit_amount = "0.1"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 0
    threshold_type             = "ABSOLUTE_VALUE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["your_email@domain.com"]
  }
}