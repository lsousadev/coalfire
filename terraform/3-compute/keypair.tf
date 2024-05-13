resource "tls_private_key" "ec2_priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "poc-key-pair"
  public_key = tls_private_key.ec2_priv_key.public_key_openssh
}