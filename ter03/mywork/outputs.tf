//-----------------------------------------------------------------------
// > 1. Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.
// ----------------------------------------------------------------------
//output "vm_external_ip4_addressVM1_web" {
//  value  = yandex_compute_instance.platform[*].network_interface.nat_ip_address
//}
//output "vm_external_ip4_addressVM1_db" {
//  value  = yandex_compute_instance.platformDB.network_interface[0].nat_ip_address
//}

//-----------------------------------------------------------------------
// variant2
// ----------------------------------------------------------------------
output "infostock2" {
  value = [
    {
      //    "id" =  yandex_compute_instance.platform.*.id,
      "name" = {for name, vm in yandex_compute_instance.platform : vm.name => vm.name}
      "id" = {for name, vm in yandex_compute_instance.platform : vm.name => vm.id}
      "FQDN" = {for name, vm in yandex_compute_instance.platform : vm.name => vm.fqdn}
    },
    {
      "name" = {for name, vm in yandex_compute_instance.vmstock : vm.name => vm.name}
      "id" = {for name, vm in yandex_compute_instance.vmstock : vm.name => vm.id}
      "FQDN" = {for name, vm in yandex_compute_instance.vmstock : vm.name => vm.fqdn}
    },
    {
      "name" = {for name, vm in yandex_compute_instance.vmdisk[*] : vm.name => vm.name}
      "id" = {for name, vm in yandex_compute_instance.vmdisk[*] : vm.id => vm.id}
      "FQDN" = {for name, vm in yandex_compute_instance.vmdisk[*] : vm.fqdn => vm.fqdn}
    }
  ]
}

output "infostock3" {
  value = [
    {
      "name" = yandex_compute_instance.platform[*].name
      "id" = yandex_compute_instance.platform[*].id
      "FQDN" = yandex_compute_instance.platform[*].fqdn
    },
    {
      "name" = yandex_compute_instance.vmdisk[*].name
      "id" = yandex_compute_instance.vmdisk[*].id
      "FQDN" = yandex_compute_instance.vmdisk[*].fqdn
    },
    //    {
    //      "name" = yandex_compute_instance.vmstock[*].name
    //      "id" = yandex_compute_instance.vmstock[*].id
    //      "FQDN" = yandex_compute_instance.vmstock[*].fqdn
    //    }
  ]
}
//-----------------------------------------------------------------------
// variant with use data; preformated each instance for later use include in output section
// ----------------------------------------------------------------------

//platform
data "yandex_compute_instance" "data-platform" {
  depends_on = [
    yandex_compute_instance.platform]
  for_each = {for k, v in yandex_compute_instance.platform[*] : k => v}
  name = "${each.value.name}"
}
output "infoplan-platform" {
  value = [
  for v in data.yandex_compute_instance.data-platform: [
    "`name`= ${v.name}",
    "`id`= ${v.id}",
    "`fqdn`= ${v.fqdn}"
  ]
  ]
}
//vmstock
data "yandex_compute_instance" "data-vmstock" {
  depends_on = [
    yandex_compute_instance.vmstock]
  for_each = {for k, v in yandex_compute_instance.vmstock : k => v}
  name = "${each.value.name}"
}
output "infoplan-vmstock" {
  value = [
  for v in data.yandex_compute_instance.data-vmstock: [
    "`name`= ${v.name}",
    "`id`= ${v.id}",
    "`fqdn`= ${v.fqdn}"
  ]
  ]
}

// sdfsdfsdf
//
data "yandex_compute_instance" "data-vmdisk" {
  depends_on = [
    yandex_compute_instance.vmdisk]
  for_each = {for k, v in yandex_compute_instance.vmdisk[*] : k => v}
  name = "${each.value.name}"
}
output "infoplan-vmdisk" {
  value = [
  for v in data.yandex_compute_instance.data-vmdisk: [
    "`name`= ${v.name}",
    "`id`= ${v.id}",
    "`fqdn`= ${v.fqdn}"
  ]
  ]
}

