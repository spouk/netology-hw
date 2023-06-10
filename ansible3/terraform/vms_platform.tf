//-----------------------------------------------------------------------
// global stock variables with map
// ----------------------------------------------------------------------
variable "vm_clickhouse" {
  type = map(number)
  default = {
    cores:2,
    memory: 4,
    core_fraction: 5,
  }
}

variable "vm_vector" {
  type = map(number)
  default = {
    cores:2,
    memory: 4,
    core_fraction: 5,
  }
}
variable "vm_lighthouse" {
  type = map(number)
  default = {
    cores:2,
    memory: 4,
    core_fraction: 5,
  }
}

variable "metadata" {
  type = map(any)
  default = {
    serial-port-enable:1,
    ssh-keys : "centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCobbI2TjVm8Xpyp+LAnfUiJvKGjuV/fY0f629DqwXfX00jJxm195Pz+xataNiZFrrIPHvrokHxEx1WQlGgLCX0Vt0nMTwZJQfb055P1teDrd/1XTEa2hMabSZmXkJnrfQ4z3yj24ciDH0RvfODmEJm1TW4Q46/ctFdFahGzOQou6H1TtUWfCE8kF5B7t6svUAAbA5Tae5wqygrmHjNT7IcXNi0b9k5D/y4qna7bbT/VH2dfKupYm0E9BMoBHTFy1ucg2uQ3sRNRV+PtFuJ1vmMadu3c1G56Ae21v77uAMUqmyC4WdQChYagE37ugTvBW2ILEFw4shLZgay/QXBQM6B spouk@sfh.bsd"
  }
}

variable "vm_global_cidr" {
  type = list(string)
  default = [
    "10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "policy_nat" {
  type= map(bool)
  default = {
    preemptible: true,
    nat: true
  }
}
variable "image" {
  type = string
//  default = "ubuntu-2004-lts"
  default = "centos-7"
}

//instance:platform
variable "vm_platform" {
  type = string
  default = "standard-v1"
  description = "instance platform"
}
variable "vm_default_zone" {
  type = string
  default = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_default_name" {
  type = string
  default = "develop"
  description = "VPC network & subnet name"
}

//-----------------------------------------------------------------------
// variables stock on VM1 [web]
// ----------------------------------------------------------------------
###hard variables
//instance:platform
variable "vm_web_instanse_platform" {
  type = string
  default = "standard-v1"
  description = "instance platform"
}

###cloud vars
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




