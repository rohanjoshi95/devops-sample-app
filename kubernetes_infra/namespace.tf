resource "kubernetes_namespace" "jenkinsdemo" {
  metadata {
    annotations = {
      name = var.namespace
    }
    labels = {
      app = var.app_product
    }
    name = var.namespace
  }
}