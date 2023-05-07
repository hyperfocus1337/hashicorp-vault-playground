# Auto unseal procedure

1. Run `terraform init` to initialize Terraform.
2. Run `terraform apply` to create the AWS KMS key used for unsealing Vault.
3. Update `vault.hcl` with the key id of the AWS KMS key.
4. Run `vault operator init` to initialize the cluster.
5. Run `vault operator unseal -migrate` at least three times.
