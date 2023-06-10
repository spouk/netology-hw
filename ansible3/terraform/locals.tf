locals {
  baseweb = "netologia"
  clickhouse = "clickhouse"
  vector = "vector"
  lighthouse = "lighthouse"

  namevmclickhouse = "${local.baseweb}-${local.clickhouse}"
  namevmvector = "${local.baseweb}-${local.vector}"
  namevmlighthouse = "${local.baseweb}-${local.lighthouse}"

}