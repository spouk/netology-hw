//--------------------------------
// provider
//--------------------------------
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
provider "yandex" {
  service_account_key_file = "key.json"
  zone = "ru-central1-a"
}

//--------------------------------
// variables
//--------------------------------
variable "folder_id" {
  description = "folder id"
  default = "b1gq6q3aajv9uhquigmm"
}
variable "databasename" {
  default = "testdb"
  description = "database name"
}
variable "userdb" {
  default = "user1"
  description = "user database name"
}


//--------------------------------
// resources
//--------------------------------

// cluster
resource "yandex_mdb_postgresql_cluster" "cls" {
  name = "testclusterfromterraform"
  folder_id = var.folder_id
  environment = "PRESTABLE"
  host_master_name = "nodemaster"
  network_id = yandex_vpc_network.net.id
  security_group_ids  = [ yandex_vpc_security_group.group1.id ]


  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id = "network-ssd"
      disk_size = 10
    }
    postgresql_config = {
      max_connections = 350
      enable_parallel_hash = true
      autovacuum_vacuum_scale_factor = 0.34
      default_transaction_isolation = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day = "SAT"
    hour = 12
  }


  host {
    zone      = "ru-central1-a"
    name      = "nodemaster"
    priority  = 2
    subnet_id = yandex_vpc_subnet.zoneasubnet.id
  }
  host {
    zone                    = "ru-central1-b"
    name                    = "nodeslave1"
    replication_source_name = "nodemaster"
    subnet_id               = yandex_vpc_subnet.zonebsubnet.id
  }
}

// user database
resource "yandex_mdb_postgresql_user" "userdb" {
  cluster_id = yandex_mdb_postgresql_cluster.cls.id
  name       = var.userdb
  password   = "user1user1"
}

// database
resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.cls.id
  name       = var.databasename
  owner      = "user1"
//  owner      = yandex_mdb_postgresql_user.userdb.id
}




//--------------------------------
// networks
//--------------------------------
resource "yandex_vpc_network" "net" {
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "zoneasubnet" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.1.0.0/24"]
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "zonebsubnet" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.2.0.0/24"]
  folder_id = var.folder_id
}


//--------------------------------
// security
//--------------------------------

resource "yandex_vpc_security_group" "group1" {
  name        = "My security group"
  description = "description for my security group"
  network_id  = yandex_vpc_network.net.id
  folder_id =  var.folder_id

  labels = {
    my-label = "my-label-value"
  }

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6432
  }
}
