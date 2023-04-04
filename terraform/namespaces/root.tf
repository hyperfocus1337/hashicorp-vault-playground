resource "vault_namespace" "ns" {
  for_each = var.namespaces
  path     = each.key
}

resource "vault_namespace" "child" {
  depends_on = [
    vault_namespace.ns
  ]
  for_each = {
    for namespace in local.child_namespaces : "${namespace.parent_namespace}.${namespace.child_namespace}" => namespace
  }
  namespace = each.value.parent_namespace
  path      = each.value.child_namespace
}

resource "vault_audit" "file" {
  type = "file"

  options = {
    file_path = "/vault/logs/audit.log"
  }
}

resource "vault_policy" "root-admin-policy" {
  name   = "root-admin-policy"
  policy = <<EOT
## name: root-admin-policy
# namespace: root

# Manage auth methods
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/+/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/sys/auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/+/sys/auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage entities and groups
path "identity/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/identity/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/+/identity/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage namespaces
path "sys/namespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/sys/namespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/+/sys/namespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage policies
path "sys/policies/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/sys/policies/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "+/+/sys/policies/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List policies
path "sys/policies/acl" {
  capabilities = ["list"]
}
path "+/sys/policies/acl" {
  capabilities = ["list"]
}
path "+/+/sys/policies/acl" {
  capabilities = ["list"]
}

# Enable and manage secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "+/sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "+/+/sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow ui to determine access
path "sys/capabilities-self" {
  capabilities = ["update"]
}
path "+/sys/capabilities-self" {
  capabilities = ["update"]
}
path "+/+/sys/capabilities-self" {
  capabilities = ["update"]
}
EOT
}

resource "vault_identity_entity" "root-admin-entity" {
  name = "admin"
}

resource "vault_identity_group" "root-admin-group" {
  name     = "root-admin-group"
  policies = [vault_policy.root-admin-policy.name, "default"]
}

resource "vault_identity_group_member_entity_ids" "root-admin-group-entity-ids" {
  group_id = vault_identity_group.root-admin-group.id
  member_entity_ids = [
    vault_identity_entity.root-admin-entity.id
  ]
}

resource "vault_auth_backend" "root-userpass-auth-backend" {
  type = "userpass"
}

resource "vault_generic_endpoint" "root-user" {
  path      = "auth/userpass/users/${vault_identity_entity.root-admin-entity.name}"
  data_json = <<EOT
{
  "password": "${vault_identity_entity.root-admin-entity.name}",
  "policies": ["${vault_policy.root-admin-policy.name}"]
}
EOT
}

resource "vault_identity_entity_alias" "root-admin-entity-alias" {
  name           = vault_identity_entity.root-admin-entity.name
  mount_accessor = vault_auth_backend.root-userpass-auth-backend.accessor
  canonical_id   = vault_identity_entity.root-admin-entity.id
}
