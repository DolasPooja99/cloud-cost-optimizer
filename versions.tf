# versions.tf

terraform {
  # Specifies the minimum required version of Terraform CLI.
  # Ensure your installed Terraform CLI is >= 1.5.0
  required_version = ">= 1.5.0"

  # Defines the required providers and their versions.
  # This tells Terraform to use the AWS provider from HashiCorp registry,
  # specifically version 5.31.0 or any newer 5.x.x version.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}