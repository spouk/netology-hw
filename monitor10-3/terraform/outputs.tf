output "vm1_ip_prometheus" {
  value = yandex_compute_instance.prometheus.network_interface.0.nat_ip_address
}
output "vm2_ip_grafana" {
  value = yandex_compute_instance.grafana.network_interface.0.nat_ip_address
}