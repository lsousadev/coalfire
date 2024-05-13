module "asg_sg" {
  source = "github.com/Coalfire-CF/terraform-aws-securitygroup?ref=b6e9070a3f6201d75160c42a3f649d36cb9b2622"

  name        = "${var.resource_prefix}-asg-sg"
  description = "SG for ASG"
  vpc_id      = data.terraform_remote_state.network.outputs.poc_vpc_id

  ingress_rules = {
    alb443 = {
      description = "Allow 443 from ALB"
      ip_protocol = "tcp"
      from_port   = "443"
      to_port     = "443"
      referenced_security_group_id  = module.alb_sg.id
    }
  }
  egress_rules = {
    all = {
      description = "Allow all"
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

resource "aws_launch_template" "asg_priv_template" {
  name = "asg-priv-launch-template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  iam_instance_profile {
    name = module.ec2_centos7.iam_profile
  }

  image_id                             = data.aws_ami.centos7.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = aws_key_pair.generated_key.key_name
  vpc_security_group_ids               = [module.asg_sg.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 3
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.resource_prefix}-centos7-asg-instance"
    }
  }

  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "asg_priv" {
  desired_capacity  = 2
  max_size          = 6
  min_size          = 2
  health_check_type = "EC2"

  vpc_zone_identifier = [
    data.terraform_remote_state.network.outputs.private_subnets[var.subnet3_id],
    data.terraform_remote_state.network.outputs.private_subnets[var.subnet4_id]
  ]

  target_group_arns = [aws_lb_target_group.alb_tg.arn]

  launch_template {
    id      = aws_launch_template.asg_priv_template.id
    version = "$Latest"
  }
}