output "poc_vpc_id" {
  description = "VPC id of deployed poc VPC"
  value       = module.poc_vpc.vpc_id
}

output "firewall_subnets" {
  description = "subnet ids of deployed firewall subnets"
  value       = module.poc_vpc.firewall_subnets
}

output "public_subnets" {
  description = "subnet ids of deployed public subnets"
  value       = module.poc_vpc.public_subnets
}

output "private_subnets" {
  description = "subnet ids of deployed private subnets"
  value       = module.poc_vpc.private_subnets
}

output "database_subnets" {
  description = "subnet ids of deployed firewall subnets"
  value       = module.poc_vpc.database_subnets
}

output "redshift_subnets" {
  description = "subnet ids of deployed public subnets"
  value       = module.poc_vpc.redshift_subnets
}

output "elasticache_subnets" {
  description = "subnet ids of deployed private subnets"
  value       = module.poc_vpc.elasticache_subnets
}

output "poc_vpc_cidr" {
  description = "poc vpc cidr block"
  value       = module.poc_vpc.vpc_cidr_block
}