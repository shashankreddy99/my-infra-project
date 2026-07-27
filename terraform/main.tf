terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Configures remote state storage and locking
  backend "s3" {
    bucket         = "infra-state-management-bucket599" 
    key            = "jenkins/ec2/terraform.tfstate"
    region         = "us-east-1" 
    dynamodb_table = "terraform-state-lock" 
    encrypt        = true                  
  }
}

provider "aws" {
  region = var.aws_region
}

# Input variables mapped from Jenkins inputs
variable "aws_region"   { type = string }
variable "ami_id"       { type = string }
variable "server_type"  { type = string }

# Provisions the virtual server
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.server_type

  tags = {
    Name      = "Jenkins-Provisioned-Server"
    ManagedBy = "Terraform"
  }
}
