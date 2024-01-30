//-----------------------------------------------------------------------
// kubernetes cluster
// ----------------------------------------------------------------------
// yc managed-kubernetes cluster list
// yc managed-kubernetes cluster get-credentials <idcluster>   --external
resource "yandex_kubernetes_cluster" "kubernetescluster" {
  network_id = yandex_vpc_network.stockvpc.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.public-a.zone
        subnet_id = yandex_vpc_subnet.public-a.id
      }

      location {
        zone      = yandex_vpc_subnet.public-b.zone
        subnet_id = yandex_vpc_subnet.public-b.id
      }

      location {
        zone      = yandex_vpc_subnet.public-c.zone
        subnet_id = yandex_vpc_subnet.public-c.id
      }

    }
    public_ip = true


    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }

      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.sakc.id
  node_service_account_id = yandex_iam_service_account.sakc.id
  depends_on              = [
    yandex_resourcemanager_folder_iam_member.kuber-k8sclustereditor,
    yandex_resourcemanager_folder_iam_member.kuber-vpcpublicadmin,
    yandex_resourcemanager_folder_iam_member.kuber-kms,
    yandex_resourcemanager_folder_iam_member.kuber-vpcuser,
    yandex_resourcemanager_folder_iam_member.kuber-editor,
    yandex_resourcemanager_folder_iam_member.kuber-containerpuller
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }

}

//-----------------------------------------------------------------------
// keys
// ----------------------------------------------------------------------
resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ Yandex Key Management Service для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}

//-----------------------------------------------------------------------
// nodes
// ----------------------------------------------------------------------
resource "yandex_kubernetes_node_group" "kubernodegroup" {
  cluster_id = yandex_kubernetes_cluster.kubernetescluster.id
  name       = "kubernodegroup"


  instance_template {
    platform_id               = "standard-v2"
    network_acceleration_type = "standard"

    container_runtime {
      type = "containerd"
    }

    network_interface {
      nat        = true
      subnet_ids = [
        yandex_vpc_subnet.public-a.id,
      ]
#      security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    metadata = {
      ssh-keys = "remoteuser:${file("~/.ssh/remoteuser.pub")}"
    }

  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.public-a.zone
    }
  }
}
