> [!NOTE]  
> The solution and notes regarding the technical challenge are in [SOLUTION.md](SOLUTION.md)

## Architecture

![Architecture Diagram](coalfire_architecture.png)

## Dependencies

- AWS account
- AWS account credentials in CLI
- Terraform

## Resource List

| Directory | Purpose |
| --------- | ------- |
| `terraform/0-account` | Initial keys, tables, buckets, including ones used for Terraform state |
| `terraform/1-storage` | "Logs" and "Images" buckets |
| `terraform/2-network` | VPC, subnets, and downstream networking resources |
| `terraform/3-compute` | Standalone EC2 instance, ASG, ALB, and dependent resources such as EC2 keypair, SG's, and IAM objects |

## Deployment Instructions

1. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
2. Log into AWS via CLI with your [method of choice](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#configure-precedence).
3. Navigate to `terraform/0-account`, run `terraform init` and `terraform apply`.
4. Uncomment `backend.tf` and run `terraform init -migrate-state`.
5. Navigate to `terraform/1-storage`, run `terraform init` and `terraform apply`.
6. Navigate to `terraform/2-network`, run `terraform init` and `terraform apply`.
7. Navigate to `terraform/3-compute`, run `terraform init` and `terraform apply`.

- It is advised to run `terraform plan` before `terraform apply` as an extra guardrail.
- All necessary variables already have a working default value. Feel free to create custom variable files as needed.
- Depending on the region chosen and/or AZs available, you may need to pass custom values for `subnet1_id`, `subnet2_id`, `subnet3_id`, `subnet4_id` variables.
