//-----------------------------------------------------------------------
// variables for `meta` for-each
// list(object({ vm_name=string, cpu=number, ram=number, disk=number  }))
// ----------------------------------------------------------------------
variable "infoblock" {
  type = list(object(
  {
    name = string
    id = string
    fqdn = string
  }))
  default = []
}

variable "vm" {
  type = list(object({
    vm_name = string
    cpu = number
    ram = number
    disk = number
    core_fraction = number
  }))
  default = [
    {
      vm_name = "vm1"
      cpu = 2
      ram = 3
      disk = 10
      core_fraction = 5
    },
    {
      vm_name = "vm2"
      cpu = 4
      ram = 6
      disk = 7
      core_fraction = 5
    }]
}

//-----------------------------------------------------------------------
// global stock variables with map
// ----------------------------------------------------------------------
//> 1. Вместо использования 3-х переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедените их в переменные типа map с именами "vm_web_resources" и "vm_db_resources".
//> 2. Так же поступите с блоком metadata {serial-port-enable, ssh-keys}, эта переменная должна быть общая для всех ваших ВМ.


variable "vm_web_resources" {
  type = map(number)
  default = {
    cores:2,
    memory: 1,
    core_fraction: 5,
  }
}
//instance:platform
variable "vm_web_instanse_platform" {
  type = string
  default = "standard-v1"
  description = "instance platform"
}
variable "policy_nat" {
  type = map(bool)
  default = {
    preemptible: true,
    nat: true
  }
}
variable "metadata" {
  type = map(any)
  default = {
    serial-port-enable:1,
    ssh-keys : "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCobbI2TjVm8Xpyp+LAnfUiJvKGjuV/fY0f629DqwXfX00jJxm195Pz+xataNiZFrrIPHvrokHxEx1WQlGgLCX0Vt0nMTwZJQfb055P1teDrd/1XTEa2hMabSZmXkJnrfQ4z3yj24ciDH0RvfODmEJm1TW4Q46/ctFdFahGzOQou6H1TtUWfCE8kF5B7t6svUAAbA5Tae5wqygrmHjNT7IcXNi0b9k5D/y4qna7bbT/VH2dfKupYm0E9BMoBHTFy1ucg2uQ3sRNRV+PtFuJ1vmMadu3c1G56Ae21v77uAMUqmyC4WdQChYagE37ugTvBW2ILEFw4shLZgay/QXBQM6B spouk@sfh.bsd"
  }
}

variable "image" {
  type = string
  default = "ubuntu-2004-lts"
}
data "yandex_compute_image" "ubuntu" {
  family = var.image
}


###cloud vars
variable "token" {
  type = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}
variable "default_info_disk" {
  type = map(any)
  default = {
    typedisk = "network-hdd"
    sizedisk = 1
    blocksize = 4096
  }
  description = "empy network disk"
}

variable "default_zone" {
  type = string
  default = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type = list(string)
  default = [
    "10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type = string
  default = "develop"
  description = "VPC network&subnet name"
}
variable "test_list" {
  type = list
  default = [
    "develope",
    "production",
    "testing"]
}
