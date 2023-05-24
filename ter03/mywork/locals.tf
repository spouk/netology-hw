locals {
  baseweb = "netologia"
  lineweb = "develop"
  typevmweb = "platform-web"

  nameVMweb = "${local.baseweb}-${local.lineweb}-${local.typevmweb}"
  nameVMfe = "${local.baseweb}-vmfe"
  nameVMdisk = "${local.baseweb}-diskexample"

  // for `for-each` project get ssh-key pub part use `file` function HCL
  sshkeyfromfile = "ubuntu:${file("~/.ssh/id_rsa.pub")}"

}