//-----------------------------------------------------------------------
// VM1 [random] with `meta` for-each inline
// ----------------------------------------------------------------------
resource "yandex_compute_instance" "vmstock" {
  for_each = {for k in var.vm:  k.vm_name => k}

  name        = "${local.nameVMfe}-${each.value.vm_name}"
  platform_id = var.vm_web_instanse_platform

  depends_on = [yandex_compute_instance.platform]

  resources {
    cores =  each.value.cpu
    memory = each.value.ram
    core_fraction = each.value.core_fraction
  }


  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = each.value.disk
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
    serial-port-enable = var.metadata.serial-port-enable // use because other part `count.tf` use metadata variable
    ssh-keys           = local.sshkeyfromfile // ssh public part read from local file
  }
}