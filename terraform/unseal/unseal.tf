resource "aws_kms_key" "vault_auto_unseal" {
  description = "Vault auto unseal ${var.environment}"
  tags = {
    Name = "${var.environment}"
  }
}