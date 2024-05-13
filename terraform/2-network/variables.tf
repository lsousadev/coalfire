variable "resource_prefix" {
  description = "The prefix for the s3 bucket names"
  type        = string
  default     = "fedco"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "delete_protection" {
  description = ""
  type        = bool
  default     = false # change this to true for prod
}

variable "poc_vpc_cidr" {
  description = ""
  type        = string
  default     = "10.1.0.0/16"
}

variable "deploy_aws_nfw" {
  description = ""
  type        = bool
  default     = false # TODO(lucas): add nfw last
}

variable "public_subnets" {
  description = ""
  type        = list(string)
  default = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]
}

variable "private_subnets" {
  description = ""
  type        = list(string)
  default = [
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]
}

variable "private_subnet_tags" {
  description = ""
  type        = map(string)
  default = {
    "0" = "Private"
    "1" = "Private"
  }
}
