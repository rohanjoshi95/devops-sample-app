variable "aws_region" {
  type    = list
  default = ["us-east-1", "ap-south-1", "eu-west-2"]
}
variable "amis" {
  type = map
  default = {
    us-east-1  = "ami-01d025118d8e760db",
    ap-south-1 = "ami-02d55cb47e83a99a0",
    eu-west-2  = "ami-032598fcc7e9d1c7a"
  }
}

variable "key_name" {
  default = "Mumbai"
}

variable "instance_type" {
  type    = list
  default = ["t2.micro", "t2.small", "t2.medium"]
}

variable "azs" {
  type = map(list(string))
  default = {
    us-east-1  = ["us-east-1a", "us-east-1b"],
    ap-south-1 = ["ap-south-1a", "ap-south-1b"],
    eu-west-2  = ["eu-west-2a", "eu-west-2b"]
  }
}

variable "cidr_block_vpc" {
  type    = string
  default = "10.0.0.0/16"
}
variable "cidr_block_public" {
  type    = string
  default = "10.0.1.0/24"
}
variable "sg_ports" {
  type        = list(number)
  description = "Number of ports"
  default     = [8001, 22, 3306, 6443]
}
variable "map_public_ip_on_launch_public" {
  type    = string
  default = "true"
}
variable "cidr_block_private" {
  type    = string
  default = "10.0.2.0/24"
}
variable "map_public_ip_on_launch_private" {
  type    = string
  default = "false"
}
