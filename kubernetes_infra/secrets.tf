resource "kubernetes_secret" "mysql-root-pass" {
  metadata {
    namespace = var.namespace
    name = "mysql-root-pass"
  }
  data = {
    password = "P4ssw0rd"
  }
}
resource "kubernetes_secret" "mysql-db-url" {
  metadata {
    namespace = var.namespace
    name = "mysql-db-url"
  }
  data = {
    url = "jdbc:mysql://mysqlhost:3306/sales"
  }
}

resource "kubernetes_secret" "mysql-user-pass" {
  metadata {
    namespace = var.namespace
    name = "mysql-user-pass"
  }
  data = {
    password = "P4ssw0rd"
  }
}