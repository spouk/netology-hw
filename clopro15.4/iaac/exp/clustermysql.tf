//-----------------------------------------------------------------------
// mysql cluster
// ----------------------------------------------------------------------
resource "yandex_mdb_mysql_cluster" "clustermysql" {

  name                      = var.clusterstockvars.clustername
  environment               = var.clusterstockvars.clusterenv
  network_id                = yandex_vpc_network.stockvpc.id
  version                   = var.clusterstockvars.mysqlversion
  #  security_group_ids  = [ "<список_идентификаторов_групп_безопасности>" ]
  deletion_protection       = var.clusterstockvars.protectdelete
  backup_retain_period_days = "14"

  resources {
    resource_preset_id = var.clusterstockvars.setuphost.resource_preset_id
    disk_type_id       = var.clusterstockvars.setuphost.disk_type_id
    disk_size          = var.clusterstockvars.setuphost.disk_size
  }

  dynamic "host" {
    for_each = yandex_vpc_subnet.private
    content {
      zone             = each.value.zone
      subnet_id        = each.value.id
      assign_public_ip = var.clusterstockvars.publicaccess
    }
  }

  host {
    zone             = each.value.zone
    subnet_id        = each.value.id
    assign_public_ip = var.clusterstockvars.publicaccess
    #priority         = <приоритет_при_выборе_хоста-мастера>
    #backup_priority  = <приоритет_для_резервного_копирования>
  }
  maintenance_window {
#    type = var.clusterstockvars.maintance.type
#    day  = var.clusterstockvars.maintance.day
#    hour = var.clusterstockvars.maintance.hour
    type = "WEEKLY"
    day  = "MON"
    hour = 23
  }
  backup_window_start {
#    hours   = var.clusterstockvars.backuptime.hours
#    minutes = var.clusterstockvars.backuptime.minutes
    hours   = 23
    minutes = 59
#    hours   = var.clusterstockvars.backuptime.hours
#    minutes = var.clusterstockvars.backuptime.minutes
  }

}

resource "yandex_mdb_mysql_database" "netologydb" {
  for_each   = yandex_mdb_mysql_cluster.clustermysql
  #  cluster_ip   = yandex_mdb_mysql_cluster.clustermysql.for_each
  #  cluster_id = yandex_mdb_mysql_cluster.clustermysql[each.value.id]
  cluster_id = each.value.id
  #  cluster_id = yandex_mdb_mysql_cluster.clustermysql.id
  name       = var.clusterstockvars.namedbs
}
resource "yandex_mdb_mysql_user" "dbuser" {
  for_each   = yandex_mdb_mysql_database.netologydb
  cluster_id = each.value.cluster_id
  name       = var.clusterstockvars.userdbname
  password   = var.clusterstockvars.userdbpassword
  permission {
    database_name = each.value.name
    roles         = ["ALL"]
  }
}


#//-----------------------------------------------------------------------
#// test vm for checking use for_each
#// ----------------------------------------------------------------------
#resource "yandex_compute_image" "ubuntu-1804-lts" {
#  source_family = "ubuntu-1804-lts"
#  folder_id     = "b1g6jkfnul7b3vp4jegm"
#
#}
#resource "yandex_compute_instance" "testvm" {
#  for_each = toset(yandex_vpc_network.stockvpc.subnet_ids)
#
#  name        = "vm${each.key}"
#  platform_id = "standard-v3"
#  zone        = "ru-central1-a"
#  folder_id   = "b1g6jkfnul7b3vp4jegm"
#
#  resources {
#    core_fraction = 20
#    cores         = 2
#    memory        = 2
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id = yandex_compute_image.ubuntu-1804-lts.id
#    }
#  }
#
#  network_interface {
#    subnet_id = each.value
#    nat       = true
#  }
#}
#
##output "showidprivatenets" {
##
##  value = ""
##}