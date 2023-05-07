output "vault_kms_key_id" {
  value = aws_kms_key.vault_auto_unseal.id
}
