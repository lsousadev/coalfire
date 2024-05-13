terraform {
  backend "s3" {
    bucket         = "fedco-us-east-1-tf-state"
    region         = "us-east-1"
    key            = "fedco-us-east-1-storage.tfstate"
    dynamodb_table = "fedco-us-east-1-state-lock"
    encrypt        = true
  }
}