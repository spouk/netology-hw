locals {
  name_base = "netologia"
  name_prom = "prometheus"
  name_grafana = "grafana"
  nameVM1 = "${local.name_base}-${local.name_prom}"
  nameVM2 = "${local.name_base}-${local.name_grafana}"
}