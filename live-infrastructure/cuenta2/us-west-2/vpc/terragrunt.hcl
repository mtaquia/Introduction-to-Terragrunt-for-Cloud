include "root" {
    path = find_in_parent_folders("root.hcl")
    # We need to make azs attribute dynamic and use the resolved region to determine the right azs
    expose = true
}

locals {
    region = include.root.locals.aws_region
}

# Configure the module
#
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=5.16.0".
#
# You can find the module at:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
#
# Note the extra `/` after the `tfr` protocol is required for the shorthand
# notation.
terraform {
    source = "tfr:///terraform-aws-modules/vpc/aws?version=5.16.0"
}

# Configure the inputs for the module
inputs = {
    name = "my-vpc"
    cidr = "10.0.0.0/16"

    #azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
    azs = ["${local.region}a","${local.region}b","${local.region}c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.105.0/24"]

    enable_nat_gateway = false
    enable_vpn_gateway = false

    tags = {
        IaC = "true"
        Environment = "dev"
    }
}