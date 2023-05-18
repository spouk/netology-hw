locals {
  baseweb = "netologia"
  lineweb = "develop"
  typevmweb = "platform-web"
  typevmdb = "platform-db"

  nameVMweb = "${local.baseweb}-${local.lineweb}-${local.typevmweb}"
  nameVMdb = "${local.baseweb}-${local.lineweb}-${local.typevmdb}"

}