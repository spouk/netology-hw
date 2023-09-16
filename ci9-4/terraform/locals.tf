locals {
  baseweb = "netologia"
  lineweb = "cicd"
  typevmweb = "jenkins-master"
  typevmdb = "jenkins-agent"

  nameVMweb = "${local.baseweb}-${local.lineweb}-${local.typevmweb}"
  nameVMdb = "${local.baseweb}-${local.lineweb}-${local.typevmdb}"

}