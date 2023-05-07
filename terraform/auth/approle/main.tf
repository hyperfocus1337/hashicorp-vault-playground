resource "vault_mount" "approle" {
  type        = "approle"
  path        = "auth/approle"
  description = "AppRole authentication backend"
}

resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "auth/approle"
}

resource "vault_approle_auth_backend_role" "approle" {
  backend        = vault_auth_backend.approle.path
  role_name      = "test-role"
  token_policies = ["default"]
}