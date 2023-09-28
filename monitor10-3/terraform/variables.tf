//-----------------------------------------------------------------------
// global stock variables with map
// ----------------------------------------------------------------------

variable "vm_base_image" {
  type = string
  default = "centos-7"
  description = "image for install on virtual machine"
}
variable "vm_base_instanse_platform" {
  type = string
  default = "standard-v1"
  description = "instance platform"
}
variable "vm_base_zone" {
  type = string
  default = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_base_list_resource" {
  type = list(map(number))
  default = [
    {
      cores:2,
      memory: 2,
      core_fraction: 5,
    },
    {
      cores:2,
      memory: 4,
      core_fraction: 5,
    },
  ]
}

//variable "metadata" {
  variable "vm_base_sshkey" {
  type = map(any)
  default = {
    serial-port-enable:1,
    ssh-keys : "centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCobbI2TjVm8Xpyp+LAnfUiJvKGjuV/fY0f629DqwXfX00jJxm195Pz+xataNiZFrrIPHvrokHxEx1WQlGgLCX0Vt0nMTwZJQfb055P1teDrd/1XTEa2hMabSZmXkJnrfQ4z3yj24ciDH0RvfODmEJm1TW4Q46/ctFdFahGzOQou6H1TtUWfCE8kF5B7t6svUAAbA5Tae5wqygrmHjNT7IcXNi0b9k5D/y4qna7bbT/VH2dfKupYm0E9BMoBHTFy1ucg2uQ3sRNRV+PtFuJ1vmMadu3c1G56Ae21v77uAMUqmyC4WdQChYagE37ugTvBW2ILEFw4shLZgay/QXBQM6B spouk@sfh.bsd"
  }
}


//-----------------------------------------------------------------------
// variables
// -------------------------------------------------------
variable "vm_web_token" {
  type = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
variable "vm_web_cloud_id" {
  type = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "vm_web_folder_id" {
  type = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vm_web_default_zone" {
  type = string
  default = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

//variable "vm_web_vpc_name" {
//  type = string
//  default = "develop"
//  description = "VPC network & subnet name"
//}

//-----------------------------------------------------------------------
// networks
// ----------------------------------------------------------------------
variable "net_default_cidr" {
  type = list(string)
  default = [
    "10.0.1.0/24"
  ]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
variable "net_default_cidrname" {
  type = string
  default = "subnet for prometheus&&grafana for netology home tasks"
}

variable "net_policy_nat" {
  type = map(bool)
  default = {
    preemptible: true,
    nat: true
  }
}
variable "vm_base_network_id"{
  type = string
  default = "enp0bfo8siqdcq5db8f5"
  description = "exists network id for make new subnets and etc...."
}