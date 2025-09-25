terraform {
  backend "s3" {
    bucket  = "rit-unique-tfstate"
    key     = "wordpress/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "SWEN_514"   # SSH key pair name for EC2 instance access
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name

   user_data = file("wp_install.sh")

   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }
}

output "public_ip" {
    value = aws_instance.my_server.public_ip
}
