resource "aws_iam_policy" "images_bucket_read_policy" {
  name        = "images_bucket_read_policy"
  description = "Policy that allows for reading from Images bucket"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "s3:Get*",
            "s3:List*",
            "s3:Describe*"
        ]
        Effect   = "Allow"
        Resource = [
          "${data.terraform_remote_state.storage.outputs.s3_images_bucket_arn}",
          "${data.terraform_remote_state.storage.outputs.s3_images_bucket_arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "logs_bucket_write_policy" {
  name        = "logs_bucket_write_policy"
  description = "Policy that allows for writing to Logs bucket"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:PutObjectAcl",
            "s3:AbortMultipartUpload"
        ]
        Effect   = "Allow"
        Resource = "${data.terraform_remote_state.storage.outputs.s3_logs_bucket_arn}/*"
      },
    ]
  })
}

module "ec2_centos7" {
  source = "github.com/Coalfire-CF/terraform-aws-ec2?ref=v2.0.1"

  name = "${var.resource_prefix}-centos7-ec2"

  ami                 = data.aws_ami.centos7.id
  ec2_instance_type   = var.instance_size
  instance_count      = var.instance_count
  associate_public_ip = true

  vpc_id           = data.terraform_remote_state.network.outputs.poc_vpc_id
  subnet_ids       = [data.terraform_remote_state.network.outputs.public_subnets[var.subnet2_id]]
  ec2_key_pair     = aws_key_pair.generated_key.key_name
  ebs_kms_key_arn  = data.terraform_remote_state.account.outputs.ebs_kms_key_id
  ebs_optimized    = false
  root_volume_size = var.instance_volume_size

  iam_policies = [
    "${aws_iam_policy.images_bucket_read_policy.arn}",
    "${aws_iam_policy.logs_bucket_write_policy.arn}"
  ]

  # Security Group Rules
  ingress_rules = {
    ssh = {
      ip_protocol = "tcp"
      from_port   = "22"
      to_port     = "22"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  global_tags = {}

}