variable "app_product" {
  default = "myproduct"
}

variable "app_mysql" {
  default = "mysqlhost"
}

variable "namespace" {
  default = "jenkinsdemo"
}
variable "myproductservice" {
  default = "myproductservice"
}

variable "mysql_user" {
  default = "rohan"
}

variable "mysql_database" {
  default = "sales"
}

variable "myproduct_image" {
  default = "rohanjoshi95/product:latest"
}

variable "mysql_image" {
  default = "mysql:5.6"
}