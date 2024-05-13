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
