output "cluster_IP" {
  value = kubernetes_service.myproductservice.spec[0].cluster_ip
}

output "port" {
  value = kubernetes_service.myproductservice.spec[0].port
}