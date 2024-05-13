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

variable "instance_name" {
  description = "The name of the ec2 instance"
  type        = string
  default     = "ec2-centos7"
}

variable "instance_size" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "instance_volume_size" {
  description = "The size of the root ebs volume on the ec2 instances created"
  type        = string
  default     = "20"
}

variable "subnet1_id" {
  description = ""
  type        = string
  default     = "fedco-poc-vpc-public-us-east-1a"
}

variable "subnet2_id" {
  description = ""
  type        = string
  default     = "fedco-poc-vpc-public-us-east-1b"
}

variable "subnet3_id" {
  description = ""
  type        = string
  default     = "fedco-poc-vpc-private-us-east-1a"
}

variable "subnet4_id" {
  description = ""
  type        = string
  default     = "fedco-poc-vpc-private-us-east-1b"
}

variable "assume_role_policy" {
  description = "Policy document allowing Principals to assume this role (e.g. Trust Relationship)"
  type        = string
  default     = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}