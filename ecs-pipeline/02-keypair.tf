resource "tls_private_key" "tls_1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "key_1" {
  key_name   = local.key_name
  public_key = tls_private_key.tls_1.public_key_openssh
}
resource "local_sensitive_file" "pem_file" {
  filename = pathexpand("./${local.key_name}.pem")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.tls_1.private_key_pem
}
