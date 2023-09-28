data "yandex_compute_image" "baseimage" {
  family = var.vm_base_image
}
resource "yandex_vpc_subnet" "basesubnet" {
  name = var.net_default_cidrname
  zone = var.vm_base_zone
  network_id = var.vm_base_network_id
  v4_cidr_blocks = var.net_default_cidr
}
//-----------------------------------------------------------------------
// VM1
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "prometheus" {
  name = "${local.name_prom}"
  platform_id = var.vm_base_instanse_platform
  resources {
    cores = var.vm_base_list_resource[0].cores
    memory = var.vm_base_list_resource[0].memory
    core_fraction = var.vm_base_list_resource[0].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.baseimage.image_id
    }
  }
  scheduling_policy {
    preemptible = var.net_policy_nat.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.basesubnet.id
    nat = var.net_policy_nat.nat
  }

  metadata = {
    serial-port-enable = var.vm_base_sshkey.serial-port-enable
    ssh-keys = var.vm_base_sshkey.ssh-keys
  }
}
//-----------------------------------------------------------------------
// VM2
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "grafana" {
  name = "${local.name_grafana}"
  platform_id = var.vm_base_instanse_platform
  resources {
    cores = var.vm_base_list_resource[1].cores
    memory = var.vm_base_list_resource[1].memory
    core_fraction = var.vm_base_list_resource[1].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.baseimage.image_id
    }
  }
  scheduling_policy {
    preemptible = var.net_policy_nat.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.basesubnet.id
    nat = var.net_policy_nat.nat
  }

  metadata = {
    serial-port-enable = var.vm_base_sshkey.serial-port-enable
    ssh-keys = var.vm_base_sshkey.ssh-keys
  }
}
