provider "kubernetes" {
  config_path = "C:/Users/rjoshi4/.kube./config"
  }

resource "kubernetes_deployment" "myproduct" {
  metadata {
    namespace = var.namespace
    name      = var.app_product
    labels = {
      app = var.app_product
    }
  }
  spec {
    selector {
      match_labels = {
        app = var.app_product
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_product
        }
      }
      spec {
        container {
          image = var.myproduct_image
          name  = var.app_product
          port {
            container_port = 8081
          }
          env {
            name  = "SPRING_DATASOURCE_USERNAME"
            value = var.mysql_user
          }
          env {
            name = "SPRING_DATASOURCE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-user-pass"
                key  = "password"
              }
            }
          }
          env {
            name = "SPRING_DATASOURCE_URL"
            value_from {
              secret_key_ref {
                name = "mysql-db-url"
                key  = "url"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "mysqlhost" {
  metadata {
    namespace = var.namespace
    name      = var.app_mysql
    labels = {
      app = var.app_mysql
    }
  }
  spec {
    selector {
      match_labels = {
        app = var.app_mysql
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_mysql
        }
      }
      spec {
        container {
          port {
            container_port = 3306
          }
          image = var.mysql_image
          name  = var.app_mysql
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-root-pass"
                key  = "password"
              }
            }
          }
          env {
            name  = "MYSQL_DATABASE"
            value = var.mysql_database
          }
          env {
            name  = "MYSQL_USER"
            value = var.mysql_user
          }
          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-user-pass"
                key  = "password"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "myproductservice" {
  metadata {
    namespace = var.namespace
    name      = var.myproductservice
  }
  spec {
    selector = {
      app = kubernetes_deployment.myproduct.metadata[0].labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8081
      target_port = 8081
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "mysqlservice" {
  metadata {
    namespace = var.namespace
    name = var.app_mysql
    labels = {
      app = var.app_mysql
    }
  }
  spec {
    port {
      port = 3306
    }
    selector = {
      app = kubernetes_deployment.mysqlhost.metadata[0].labels.app
    }
    cluster_ip = "None"
  }
}
