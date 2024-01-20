//-----------------------------------------------------------------------
// vpc
// ----------------------------------------------------------------------
resource "yandex_vpc_network" "basevpc" {
  name        = "basevpc"
  description = "basevpc for netologia home tasks"
  folder_id   = var.stockvars.folder_id
  labels      = {
    tf-label    = "vpc-netogia"
    empty-label = ""
  }
}
//-----------------------------------------------------------------------
// subnet
// ----------------------------------------------------------------------
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  folder_id      = var.stockvars.folder_id
  description    = "publicsubnet"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.stockvars.zone
  network_id     = "${yandex_vpc_network.basevpc.id}"
}