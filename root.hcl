# root.hcl
locals {
    #region_hcl = find_in_parent_folders("region.hcl")
    #region = read_terragrunt_config(local.region_hcl).locals.aws_region

    account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
    
    account_name = local.account_vars.locals.account_name
    account_id   = local.account_vars.locals.aws_account_id
    aws_profile  = local.account_vars.locals.aws_profile
    aws_region   = local.region_vars.locals.aws_region 
}

# Configure the AWS provider
generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
    region = "${local.aws_region}"
    profile = "${local.aws_profile}"
}
EOF    
}

# Configure the remote backend
remote_state {
    backend = "s3"
    config = {
        bucket = "mtaquia-terraform-state-${local.account_name}-${local.aws_region}"
        # bucket = geai-infra-flows-state
        key = "${path_relative_to_include()}/terraform.tfstate"
        # You could easily set it to store state in multiple regions. 
        #region = "us-east-1"
        region = local.aws_region
        encrypt = true
        use_lockfile = true
        profile = local.aws_profile
        #dynamodb_table = "mtaquia-dynamo-lock-table"
        #profile = "personal" # Ensure S3 backend and DynamoDB use personal profile
    }
    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}


