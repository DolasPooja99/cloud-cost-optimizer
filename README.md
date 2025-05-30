# Cloud Cost Optimization & Alert System

This project provisions a fully automated cloud cost monitoring and alerting system using Terraform and AWS services such as Budgets, CloudWatch, SNS, and EC2.

## Features
- AWS Budgets to monitor cloud costs
- CloudWatch alarms for EC2 CPU usage
- SNS alerts via email for budget or usage breaches
- Infrastructure-as-Code using Terraform

## Setup Instructions

1. **Clone this repository**  
   `git clone https://github.com/your-username/cloud-cost-optimizer.git`

2. **Navigate into the folder**  
   `cd cloud-cost-optimizer`

3. **Initialize Terraform**  
   `terraform init`

4. **Apply the configuration**  
   `terraform apply`

> You will be asked to confirm. Type `yes` when prompted.

---

## Notes
- Replace `your-email@example.com` in `variables.tf` with your real email.
- You'll receive a confirmation email from AWS to subscribe to the SNS topic.
- The EC2 alarm is configured for a placeholder instance ID. Update it to your real EC2 instance.

---

## License
MIT
