data "terraform_remote_state" "account" {
  backend = "s3"

  config = {
    bucket = "${var.resource_prefix}-${var.aws_region}-tf-state"
    region = var.aws_region
    key    = "${var.resource_prefix}-${var.aws_region}-account.tfstate"
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"

  config = {
    bucket = "${var.resource_prefix}-${var.aws_region}-tf-state"
    region = var.aws_region
    key    = "${var.resource_prefix}-${var.aws_region}-storage.tfstate"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}