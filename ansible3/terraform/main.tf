//-----------------------------------------------------------------------
// network
// ----------------------------------------------------------------------
resource "yandex_vpc_network" "ansiblework" {
  name = var.vm_default_name
}
resource "yandex_vpc_subnet" "ansiblework" {
  name           = var.vm_default_name
  zone           = var.vm_default_zone
  network_id     = yandex_vpc_network.ansiblework.id
  v4_cidr_blocks = var.vm_global_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.image
}

//-----------------------------------------------------------------------
// VM [clickhouse]
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "clickhouse" {
  name        = "${local.namevmclickhouse}"
  platform_id = var.vm_platform
  resources {
    cores =  var.vm_clickhouse.cores
    memory = var.vm_clickhouse.memory
    core_fraction = var.vm_clickhouse.core_fraction
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
    subnet_id = yandex_vpc_subnet.ansiblework.id
    nat       = var.policy_nat.nat
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = var.metadata.ssh-keys
  }
}
//-----------------------------------------------------------------------
// VM [vector]
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "vector" {
  name        = "${local.namevmvector}"
  platform_id = var.vm_platform
  resources {
    cores =  var.vm_vector.cores
    memory = var.vm_vector.memory
    core_fraction = var.vm_vector.core_fraction
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
    subnet_id = yandex_vpc_subnet.ansiblework.id
    nat       = var.policy_nat.nat
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = var.metadata.ssh-keys
  }
}
//-----------------------------------------------------------------------
// VM [lighthouse]
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "lighthouse" {
  name        = "${local.namevmlighthouse}"
  platform_id = var.vm_platform
  resources {
    cores =  var.vm_lighthouse.cores
    memory = var.vm_lighthouse.memory
    core_fraction = var.vm_lighthouse.core_fraction
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
    subnet_id = yandex_vpc_subnet.ansiblework.id
    nat       = var.policy_nat.nat
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = var.metadata.ssh-keys
  }
}
