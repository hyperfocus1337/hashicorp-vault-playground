# HashiCorp Vault playground

This is my personal playground for testing HashiCorp Vault features.

It makes use of the official Vault docker image with docker-compose.

Make sure to set `export VAULT_LICENSE=$(cat vault_license)` before running docker-compose.

Run it with `docker-compose up -d` and then access the Vault UI at http://localhost:8200.

Not intended to be used in production.

## Features

- Configure a local Vault cluster using Terraform
- Creates (child) namespaces with a secrets engine mounted in every child namespace using a simple hcl data structure
- Create any secrets or auth engine in individual namespaces

## CLI

Run `docker-compose exec vault vault status` to check the status of the Vault server.

Alternatively, run `export VAULT_ADDR=http://localhost:8200` and then run `vault status`.

Before you can use the cluster, you need to initialize it by running `vault operator init`.

Afterwards, unseal it by running `vault operator unseal` at least three times.

Finally, authenticate by running `vault login`.

## Removing

To remove the vault installation, run:

- `docker-compose down` to remove the containers.
- `rm -r docker/vault/data/*` to remove the vault data.

To remove the state files, run:

- `rm terraform/unseal/tfstate/*`
- `rm terraform/namespaces/tfstate/*`

## Terraform

First, initialize Terraform by running `terraform init`.

Then, run `terraform plan` to see what Terraform will do.

Finally, run `terraform apply` to apply the changes.

## Pre-requisites

The following tools need to be installed:

- Docker
