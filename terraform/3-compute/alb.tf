module "alb_sg" {
  source = "github.com/Coalfire-CF/terraform-aws-securitygroup?ref=b6e9070a3f6201d75160c42a3f649d36cb9b2622"

  name        = "${var.resource_prefix}-alb-sg"
  description = "SG for ALB"
  vpc_id      = data.terraform_remote_state.network.outputs.poc_vpc_id

  ingress_rules = {
    all80 = {
      description = "Allow 80 from all"
      ip_protocol = "tcp"
      from_port   = "80"
      to_port     = "80"
      cidr_ipv4   = "0.0.0.0/0"
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

resource "aws_lb" "alb" {
  name               = "${var.resource_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.alb_sg.id]
  subnets = [
    data.terraform_remote_state.network.outputs.public_subnets[var.subnet1_id],
    data.terraform_remote_state.network.outputs.public_subnets[var.subnet2_id]
  ]

  enable_deletion_protection = false

  access_logs {
    bucket  = data.terraform_remote_state.storage.outputs.s3_logs_bucket_id
    prefix  = "${var.resource_prefix}-alb"
    enabled = true
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.resource_prefix}-alb-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = data.terraform_remote_state.network.outputs.poc_vpc_id
}

resource "aws_lb_listener" "alb_listener_80" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
