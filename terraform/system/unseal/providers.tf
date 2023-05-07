terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.14.0"
    }
  }
  backend "local" {
    path = "tfstate/terraform.tfstate"
  }
}

provider "aws" {
  region = "${var.aws_region}"
  profile = "default"
}