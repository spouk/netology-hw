resource "yandex_vpc_network" "develop" {
  name = var.vm_web_vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vm_web_vpc_name
  zone           = var.vm_web_default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_web_default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.image
}

//-----------------------------------------------------------------------
// VM1
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "cicd1" {
  name        = "${local.nameVMweb}"
  platform_id = var.vm_web_instanse_platform
  resources {
    cores =  var.vm_web_resources.cores
    memory = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.policy_nat.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.policy_nat.nat
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = var.metadata.ssh-keys
  }
}

//-----------------------------------------------------------------------
// VM2
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "cicd2" {
  name        = local.nameVMdb
  platform_id = var.vm_db_instanse_platform
  resources {
    cores         = var.vm_db_resources.cores
    memory        = var.vm_db_resources.memory
    core_fraction = var.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.policy_nat.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.policy_nat.nat
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = var.metadata.ssh-keys
  }
}


