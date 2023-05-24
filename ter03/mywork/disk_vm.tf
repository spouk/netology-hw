//-----------------------------------------------------------------------
// make 3 empty disk for task N3
// ----------------------------------------------------------------------

resource "yandex_compute_disk" "diskstock" {
  count = 3
  name = "disk${count.index}"
  zone = var.default_zone
  type = var.default_info_disk.typedisk
  size = var.default_info_disk.sizedisk
  block_size = var.default_info_disk.blocksize
}

resource "yandex_compute_instance" "vmdisk" {
  name = "${local.nameVMdisk}"
  platform_id = var.vm_web_instanse_platform
  resources {
    cores = var.vm_web_resources.cores
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
    nat = var.policy_nat.nat
    //set network security rules
    security_group_ids = [
      "${yandex_vpc_security_group.example.id}"
    ]
  }

  // assign disks from diskstock to new vm
  dynamic secondary_disk {
    for_each = "${yandex_compute_disk.diskstock.*.id}"
    content {
      disk_id = yandex_compute_disk.diskstock["${secondary_disk.key}"].id
    }
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys = var.metadata.ssh-keys
  }
}