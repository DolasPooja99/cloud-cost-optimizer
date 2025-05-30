# main.tf

# -----------------------------------
# AWS Provider Configuration
# Configures the AWS provider to deploy resources in the specified region.
# -----------------------------------
provider "aws" {
  region = var.aws_region # Uses the 'aws_region' variable from variables.tf
}

# -----------------------------------
# EC2 Instance
# Creates a single EC2 instance based on specified AMI and instance type.
# -----------------------------------
resource "aws_instance" "example" {
  ami           = var.ami_id          # Uses the 'ami_id' variable
  instance_type = var.instance_type   # Uses the 'instance_type' variable

  tags = {
    Name = "example-instance" # Tag for easy identification in AWS Console
  }
}

# -----------------------------------
# SNS Topic for Alerts
# Creates an Amazon Simple Notification Service (SNS) topic.
# This topic acts as a central point for receiving various alerts.
# -----------------------------------
resource "aws_sns_topic" "budget_alerts" {
  name = "budget-alerts-topic" # Unique name for the SNS topic
}

# -----------------------------------
# SNS Topic Subscription
# Subscribes an email address to the SNS topic.
# This is absolutely CRUCIAL for you to receive email notifications from the budget or alarms.
# After 'terraform apply', AWS will send a confirmation email to 'var.sns_email'.
# You MUST click the confirmation link in that email to activate the subscription!
# -----------------------------------
resource "aws_sns_topic_subscription" "budget_email_subscription" {
  topic_arn = aws_sns_topic.budget_alerts.arn # ARN of the SNS topic created above
  protocol  = "email"                         # Specifies email as the notification protocol
  endpoint  = var.sns_email                   # The email address to subscribe, from variables.tf
}

# -----------------------------------
# AWS Budget with Notification
# Creates an AWS Budget to monitor your estimated monthly costs.
# It sends an alert to the SNS topic if the actual cost exceeds 100% of the defined budget limit.
# -----------------------------------
resource "aws_budgets_budget" "monthly_cost_budget" {
  name        = "monthly-cost-budget" # Unique name for the budget
  budget_type = "COST"                # Type of budget: monitoring costs
  limit_amount = var.budget_limit     # The financial limit for the budget, from variables.tf
  limit_unit   = "USD"                # Currency unit for the budget limit
  time_period_start = "2025-04-01_00:00"
  time_unit    = "MONTHLY"            # Time period for the budget (e.g., monthly, quarterly, annually)

  # Defines a notification for when the budget threshold is crossed.
  notification {
    comparison_operator = "GREATER_THAN" # Trigger when actual cost is GREATER_THAN the threshold
    threshold           = 80          # Threshold percentage (100% of the budget amount)
    threshold_type      = "PERCENTAGE"   # Indicates the threshold is a percentage
    notification_type   = "ACTUAL"       # Notify based on actual spend, not forecasted

    # Defines the subscriber for this budget notification.
    # The 'subscriber' block is fully supported in AWS Provider v5.x.x and above.
    #subscribers {
    #  subscription_type = "SNS"                          # Send notification to an SNS topic
    #  address           = aws_sns_topic.budget_alerts.arn # ARN of the SNS topic to send alerts to
    #  }
    subscriber_email_addresses = [ "youremailid@com" ] # Make sure no spaces or typos here
    subscriber_sns_topic_arns  = [ aws_sns_topic.budget_alerts.arn ]

  }

  # Optional: You can add another notification for forecasted costs.
  # This sends an alert if AWS forecasts you will exceed the budget.
  # notification {
  #   comparison_operator = "GREATER_THAN"
  #   threshold           = 80 # Alert when 80% of budget is forecasted to be spent
  #   threshold_type      = "PERCENTAGE"
  #   notification_type   = "FORECASTED"
  #
  #   subscriber {
  #     subscription_type = "SNS"
  #     address           = aws_sns_topic.budget_alerts.arn
  #   }
  # }
}

# -----------------------------------
# CloudWatch Alarm for EC2 CPU Utilization
# Creates a CloudWatch alarm to monitor the average CPU utilization of the EC2 instance.
# If CPU utilization exceeds 80% for 5 minutes, it sends an alert to the SNS topic.
# -----------------------------------
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "ec2-cpu-utilization-alarm" # Unique name for the alarm
  comparison_operator = "GreaterThanThreshold"      # Operator for comparing metric to threshold
  evaluation_periods  = 1                           # Number of periods to evaluate
  metric_name         = "CPUUtilization"            # The metric to monitor
  namespace           = "AWS/EC2"                   # The namespace for EC2 metrics
  period              = 300                         # The period in seconds (300s = 5 minutes)
  statistic           = "Average"                   # The statistic to apply (e.g., Average, Sum, Maximum)
  threshold           = 80                          # The threshold value (80% CPU utilization)
  alarm_description   = "Alarm when EC2 instance CPU exceeds 80%" # Description of the alarm
  # Actions to perform when the alarm state changes to ALARM
  alarm_actions       = [aws_sns_topic.budget_alerts.arn]

  # Dimensions to specify which specific EC2 instance to monitor
  dimensions = {
    InstanceId = aws_instance.example.id # Refers to the ID of the EC2 instance created above
  }
}

# -----------------------------------
# Outputs
# Defines output values that will be displayed after 'terraform apply'.
# These can be useful for quickly getting information about your deployed resources.
# -----------------------------------
output "instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.example.id
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic used for alerts"
  value       = aws_sns_topic.budget_alerts.arn
}