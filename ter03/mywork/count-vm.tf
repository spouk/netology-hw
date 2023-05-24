//-----------------------------------------------------------------------
// VM1 [web] with `meta` count inline
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "platform" {
  count =  2 //set counts VM make in cloud
  name        = "${local.nameVMweb}-${count.index}"
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