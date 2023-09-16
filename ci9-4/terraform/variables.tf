//-----------------------------------------------------------------------
// global stock variables with map
// ----------------------------------------------------------------------
//> 1. Вместо использования 3-х переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедените их в переменные типа map с именами "vm_web_resources" и "vm_db_resources".
//> 2. Так же поступите с блоком metadata {serial-port-enable, ssh-keys}, эта переменная должна быть общая для всех ваших ВМ.
variable "vm_web_resources" {
  type = map(number)
  default = {
    cores:2,
    memory: 4,
    core_fraction: 5,
  }
}

variable "vm_db_resources" {
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
variable "policy_nat" {
  type= map(bool)
  default = {
    preemptible: true,
    nat: true
  }
}
variable "image" {
  type = string
  default = "centos-7"
}


//-----------------------------------------------------------------------
// variables stock on VM2 {db]
//> 2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ(в файле main.tf):
//"netology-develop-platform-db" ,
//cores = 2, memory = 2, core_fraction = 20.
//Объявите ее переменные с префиксом vm_db_ в том же файле('vms_platform.tf').
// ----------------------------------------------------------------------

//instance:platform
variable "vm_db_instanse_platform" {
  type = string
  default = "standard-v1"
  description = "instance platform"
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

variable "vm_web_default_zone" {
  type = string
  default = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_web_default_cidr" {
  type = list(string)
  default = [
    "10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_web_vpc_name" {
  type = string
  default = "develop"
  description = "VPC network & subnet name"
}


