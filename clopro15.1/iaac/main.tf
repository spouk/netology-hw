//-----------------------------------------------------------------------
// yandex cloud provider block
// ----------------------------------------------------------------------
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}
//-----------------------------------------------------------------------
// vpc
// ----------------------------------------------------------------------
resource "yandex_vpc_network" "basevpc" {
  name        = "basevpc"
  description = "basevpc for netologia home tasks"
  folder_id   = "b1g6jkfnul7b3vp4jegm"
  labels      = {
    tf-label    = "vpc-netogia"
    empty-label = ""
  }
}
//-----------------------------------------------------------------------
// subnet
// ----------------------------------------------------------------------
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  folder_id      = "b1g6jkfnul7b3vp4jegm"
  description    = "publicsubnet"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.basevpc.id}"
}
//-----------------------------------------------------------------------
// nat
// ----------------------------------------------------------------------
variable "vm_user" {
  type    = string
  default = "aleks"
}
variable "vm_user_nat" {
  type    = string
  default = "aleks"
}

variable "ssh_key_path" {
  type    = string
  default = "remoteuser.pub"
}

resource "yandex_compute_instance" "nat-instance" {
  name        = "nat"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  folder_id   = "b1g6jkfnul7b3vp4jegm"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    ip_address = "192.168.10.254"
    subnet_id  = yandex_vpc_subnet.public.id
    #    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
    nat        = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user_nat}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}
//-----------------------------------------------------------------------
// VM public
// ----------------------------------------------------------------------
resource "yandex_compute_image" "ubuntu-1804-lts" {
  source_family = "ubuntu-1804-lts"
  folder_id     = "b1g6jkfnul7b3vp4jegm"

}
resource "yandex_compute_instance" "vm-public" {
  name        = "vm-public"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  folder_id   = "b1g6jkfnul7b3vp4jegm"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu-1804-lts.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user_nat}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}
//-----------------------------------------------------------------------
// private  subnet
// ----------------------------------------------------------------------
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = "ru-central1-a"
  folder_id      = "b1g6jkfnul7b3vp4jegm"
  v4_cidr_blocks = ["192.168.20.0/24"]
  network_id     = "${yandex_vpc_network.basevpc.id}"
  route_table_id  = "${yandex_vpc_route_table.nat-instance-route.id}"
}
//-----------------------------------------------------------------------
// route table
// ----------------------------------------------------------------------
resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  folder_id  = "b1g6jkfnul7b3vp4jegm"
  network_id = "${yandex_vpc_network.basevpc.id}"
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "${yandex_compute_instance.nat-instance.network_interface.0.ip_address}"
  }
}
//-----------------------------------------------------------------------
// vm in private subnet
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "vm-private" {
  name        = "vm-private"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  folder_id   = "b1g6jkfnul7b3vp4jegm"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu-1804-lts.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}


#module "yc-vpc" {
#  source              = "git@github.com:terraform-yc-modules/terraform-yc-vpc.git"
#  network_name        = "test-module-network"
#  network_description = "test network created with module"
#  private_subnets     = [
#    {
#      name           = "subnet-1"
#      zone           = "ru-central1-a"
#      v4_cidr_blocks = ["10.10.0.0/24"]
#    },
#    {
#      name           = "subnet-2"
#      zone           = "ru-central1-b"
#      v4_cidr_blocks = ["10.11.0.0/24"]
#    },
#    {
#      name           = "subnet-3"
#      zone           = "ru-central1-c"
#      v4_cidr_blocks = ["10.12.0.0/24"]
#    }
#  ]
#}
