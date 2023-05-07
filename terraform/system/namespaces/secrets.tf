resource "vault_kv_secret_v2" "ns1" {
  depends_on = [
    vault_namespace.ns,
    time_sleep.wait_1_minute
  ]
  mount               = vault_mount.ns["ns1"].path
  namespace           = vault_namespace.ns["ns1"].path
  name                = "secret"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      zip = "zap",
      foo = "bar"
    }
  )
  custom_metadata {
    max_versions = 5
    data = {
      foo = "vault@example.com",
      bar = "12345"
    }
  }
}
