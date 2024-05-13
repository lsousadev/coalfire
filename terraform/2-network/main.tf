module "poc_vpc" {
  source = "github.com/Coalfire-CF/terraform-aws-vpc-nfw?ref=v2.0.6"

  name = "${var.resource_prefix}-poc-vpc"

  delete_protection = var.delete_protection

  cidr = var.poc_vpc_cidr

  azs = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]

  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  private_subnet_tags = var.private_subnet_tags

  single_nat_gateway     = false
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true

  flow_log_destination_type       = "s3"
  flow_log_destination_arn        = "${data.terraform_remote_state.storage.outputs.s3_logs_bucket_arn}/${var.resource_prefix}-poc-vpc"
  cloudwatch_log_group_kms_key_id = data.terraform_remote_state.account.outputs.cloudwatch_kms_key_id

  deploy_aws_nfw = var.deploy_aws_nfw

  tags = {
    Owner       = var.resource_prefix
    Environment = "poc"
    createdBy   = "terraform"
  }
}