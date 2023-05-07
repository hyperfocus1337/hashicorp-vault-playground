# Vault configuration

This directory configures Vault and should be run after the infrastructure is deployed and Vault is initialzed and unsealed. (See `../../ansible/install_vault`.)

``` shell
terraform apply --var-file=token.tfars
```

