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

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "${var.resource_prefix}-${var.aws_region}-tf-state"
    region = var.aws_region
    key    = "${var.resource_prefix}-${var.aws_region}-network.tfstate"
  }
}

data "aws_ami" "centos7" {
  most_recent = true

  owners = ["125523088429"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["CentOS Linux 7*"]
  }
}