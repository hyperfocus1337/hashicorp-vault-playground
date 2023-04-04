terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.14.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  }
  backend "local" {
    path = "tfstate/terraform.tfstate"
  }
}

provider "vault" {
  address = "http://localhost:8200"
  token   = var.vault_token
}

provider "null" {}
