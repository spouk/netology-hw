//-----------------------------------------------------------------------
// vpc
// ----------------------------------------------------------------------
resource "yandex_vpc_network" "stockvpc" {
  name        = "stockvpc"
  description = "stockvpc for netologia home tasks"
  folder_id   = var.stockvars.folder_id
  labels      = {
    tf-label    = "vpc-netogia-stock"
    empty-label = ""
  }
}
//-----------------------------------------------------------------------
// cluster private subnets
// ----------------------------------------------------------------------
resource "yandex_vpc_subnet" "private-a" {
  name           = var.zonelistsubnet.a.name
  zone           = var.zonelistsubnet.a.zone
  folder_id      = var.stockvars.folder_id
  v4_cidr_blocks = [var.zonelistsubnet.a.cidr]
  network_id     = yandex_vpc_network.stockvpc.id
}
resource "yandex_vpc_subnet" "private-b" {
  name           = var.zonelistsubnet.b.name
  zone           = var.zonelistsubnet.b.zone
  folder_id      = var.stockvars.folder_id
  v4_cidr_blocks = [var.zonelistsubnet.b.cidr]
  network_id     = yandex_vpc_network.stockvpc.id
}
resource "yandex_vpc_subnet" "private-c" {
  name           = var.zonelistsubnet.c.name
  zone           = var.zonelistsubnet.c.zone
  folder_id      = var.stockvars.folder_id
  v4_cidr_blocks = [var.zonelistsubnet.c.cidr]
  network_id     = yandex_vpc_network.stockvpc.id
}
//-----------------------------------------------------------------------
// public subnet for kubernetes cluster
// ----------------------------------------------------------------------
resource "yandex_vpc_subnet" "public-a" {
  name           = var.zonelistpublicsubnet.a.name
  zone           = var.zonelistpublicsubnet.a.zone
  folder_id      = var.stockvars.folder_id
  v4_cidr_blocks = [var.zonelistpublicsubnet.a.cidr]
  network_id     = yandex_vpc_network.stockvpc.id
}
resource "yandex_vpc_subnet" "public-b" {
  name           = var.zonelistpublicsubnet.b.name
  zone           = var.zonelistpublicsubnet.b.zone
  folder_id      = var.stockvars.folder_id
  v4_cidr_blocks = [var.zonelistpublicsubnet.b.cidr]
  network_id     = yandex_vpc_network.stockvpc.id
}
resource "yandex_vpc_subnet" "public-c" {
  name           = var.zonelistpublicsubnet.c.name
  zone           = var.zonelistpublicsubnet.c.zone
  folder_id      = var.stockvars.folder_id
  v4_cidr_blocks = [var.zonelistpublicsubnet.c.cidr]
  network_id     = yandex_vpc_network.stockvpc.id
}










