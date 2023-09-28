terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.vm_web_token
  cloud_id  = var.vm_web_cloud_id
  folder_id = var.vm_web_folder_id
  zone      = var.vm_web_default_zone
}