//-----------------------------------------------------------------------
// output extern ipv4 vm's for ssh con
// ----------------------------------------------------------------------
output "vm_external_ip4_address_clickhouse" {
  value  = yandex_compute_instance.clickhouse[*].network_interface[0].nat_ip_address
}
output "vm_int_ip4_address_clickhouse" {
  value  = yandex_compute_instance.clickhouse[*].network_interface[0].ip_address
}

output "vm_external_ip4_address_vector" {
  value  = yandex_compute_instance.vector.network_interface[0].nat_ip_address
}
output "vm_int_ip4_address_vector" {
  value  = yandex_compute_instance.vector.network_interface[0].ip_address
}

output "vm_external_ip4_address_lighthouse" {
  value  = yandex_compute_instance.lighthouse.network_interface[0].nat_ip_address
}
output "vm_int_ip4_address_lighthouse" {
  value  = yandex_compute_instance.lighthouse.network_interface[0].ip_address
}

