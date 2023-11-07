variable "env" {}
variable "name" {}
variable "vpc_id" {}
variable "port" {
  default = 80
}
variable "sg_subnet_cidr" {}
variable "allow_ssh_cidr" {}
variable "load_balancer_type" {}
variable "subnets" {}
variable "internal" {}