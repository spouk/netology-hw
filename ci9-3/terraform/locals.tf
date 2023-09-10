locals {
  baseweb = "netologia"
  lineweb = "develop"
  typevmweb = "cicd1"
  typevmdb = "cicd2"

  nameVMweb = "${local.baseweb}-${local.lineweb}-${local.typevmweb}"
  nameVMdb = "${local.baseweb}-${local.lineweb}-${local.typevmdb}"

}