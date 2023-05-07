resource "time_sleep" "wait_1_minute" {
  create_duration = "1m"
}

resource "vault_mount" "ns" {
  depends_on = [
    vault_namespace.ns
  ]
  for_each  = var.namespaces
  namespace = vault_namespace.ns[each.key].path
  path      = "kv"
  type      = "kv"
  options = {
    version = 2
  }
}

resource "vault_kv_secret_backend_v2" "ns" {
  depends_on = [
    vault_mount.ns,
    time_sleep.wait_1_minute
  ]
  for_each     = var.namespaces
  namespace    = vault_namespace.ns[each.key].path
  mount        = vault_mount.ns[each.key].path
  max_versions = 5
}

resource "vault_mount" "child" {
  depends_on = [
    vault_namespace.child,
    time_sleep.wait_1_minute
  ]
  for_each = {
    for namespace in local.child_namespaces : "${namespace.parent_namespace}.${namespace.child_namespace}" => namespace
  }
  namespace = "${each.value.parent_namespace}/${each.value.child_namespace}"
  path      = "kv"
  type      = "kv"
  options = {
    version = 2
  }
}

resource "vault_kv_secret_backend_v2" "child" {
  depends_on = [
    vault_mount.child,
    time_sleep.wait_1_minute
  ]
  for_each = {
    for namespace in local.child_namespaces : "${namespace.parent_namespace}.${namespace.child_namespace}" => namespace
  }
  namespace    = "${each.value.parent_namespace}/${each.value.child_namespace}"
  mount        = vault_mount.child[each.key].path
  max_versions = 5
}
