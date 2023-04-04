locals {
  child_namespaces = flatten([
    for namespace, child_namespaces in var.namespaces : [
      for child_namespace in child_namespaces : {
        parent_namespace = namespace
        child_namespace  = child_namespace
      }
    ]
  ])
}
