provider "aws" {
  region = "us-east-1"
  #profile = "personal" # by Michael
}

resource "aws_instance" "terragrunt_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "terragrunt_instance"
  }
}
#
