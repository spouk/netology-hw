//-----------------------------------------------------------------------
// mysql cluster
// ----------------------------------------------------------------------
resource "yandex_mdb_mysql_cluster" "clustermysql" {
  name                      = var.clusterstockvars.clustername
  environment               = var.clusterstockvars.clusterenv
  network_id                = yandex_vpc_network.stockvpc.id
  version                   = var.clusterstockvars.mysqlversion
  #  security_group_ids  = [ "<список_идентификаторов_групп_безопасности>" ]
  #  deletion_protection       = var.clusterstockvars.protectdelete
  backup_retain_period_days = "14"



  resources {
    resource_preset_id = var.clusterstockvars.setuphost.resource_preset_id
    disk_type_id       = var.clusterstockvars.setuphost.disk_type_id
    disk_size          = var.clusterstockvars.setuphost.disk_size
  }

  host {
    zone             = yandex_vpc_subnet.private-a.zone
    subnet_id        = yandex_vpc_subnet.private-a.id
    assign_public_ip = var.clusterstockvars.publicaccess
    priority         = 5
    backup_priority  = 10
  }
  host {
    zone             = yandex_vpc_subnet.private-b.zone
    subnet_id        = yandex_vpc_subnet.private-b.id
    assign_public_ip = var.clusterstockvars.publicaccess
    priority         = 10
    backup_priority  = 20
  }
  host {
    zone             = yandex_vpc_subnet.private-c.zone
    subnet_id        = yandex_vpc_subnet.private-c.id
    assign_public_ip = var.clusterstockvars.publicaccess
    priority         = 15
    backup_priority  = 30
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "MON"
    hour = 23
  }
  backup_window_start {
    hours   = 23
    minutes = 59
  }
}

resource "yandex_mdb_mysql_database" "netologydb" {
  cluster_id = yandex_mdb_mysql_cluster.clustermysql.id
  name       = var.clusterstockvars.namedbs
}
resource "yandex_mdb_mysql_user" "dbuser" {
  cluster_id = yandex_mdb_mysql_cluster.clustermysql.id
  name       = var.clusterstockvars.userdbname
  password   = var.clusterstockvars.userdbpassword
  permission {
    database_name = yandex_mdb_mysql_database.netologydb.name
    roles         = ["ALL"]
  }
}

