# variables.tf

variable "aws_region" {
  description = "AWS region for deploying resources (e.g., us-west-2, us-east-1)"
  type        = string
  # IMPORTANT: Set your desired AWS region here.
  # "us-west-2" is a common example.
  default     = "us-west-2" #REPLACE with your Region
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
  # IMPORTANT: This is an example AMI for Amazon Linux 2023 in us-west-2.
  # You MUST verify the latest valid AMI for your chosen region and OS in the AWS Console.
  default     = "ami-0abcd2f1234567790"  # REPLACE with the AMI ID of your manually created instance-
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t2.micro for free tier)"
  type        = string
  default     = "t2.micro" # Common free-tier eligible instance type or REPLACE with the instance type
}

variable "sns_email" {
  description = "Email address to receive SNS alerts for budget and CloudWatch alarms"
  type        = string
  # IMPORTANT: REPLACE THIS WITH YOUR ACTUAL EMAIL ADDRESS!
  # AWS will send a confirmation email to this address. You MUST click the link to activate the subscription.
  default     = "your.actual.email@example.com"
}

variable "budget_limit" {
  description = "Monthly cost limit in USD for the AWS Budget"
  type        = number
  default     = 100 # Set your desired monthly budget limit in USD
}