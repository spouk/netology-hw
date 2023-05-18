//-----------------------------------------------------------------------
// > 1. Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.
// ----------------------------------------------------------------------
output "vm_external_ip4_addressVM1_web" {
  value  = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}
output "vm_external_ip4_addressVM1_db" {
  value  = yandex_compute_instance.platformDB.network_interface[0].nat_ip_address
}