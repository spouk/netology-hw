


#//-----------------------------------------------------------------------
#// object storage
#// ----------------------------------------------------------------------
#// создание статического ключа доступа
#resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
#  service_account_id = var.stockvars.service_account_id
#  description        = "static access key for object storage"
#}
#
#// создание бакета с использованием ключа
#resource "yandex_storage_bucket" "test" {
#  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
#  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#  bucket     = "aleksey.martynenko.13012024"
#  anonymous_access_flags {
#    read = true
#    list = false
#  }
#
#}
#//загрузка объекта в бакет, в данном случае картинки
#resource "yandex_storage_object" "test-object" {
#  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
#  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#  bucket     = var.stockvars.bucket_image
#  key        = "helloworld.jpg"
#  source     = "img/zerro.jpg"
#}
#//-----------------------------------------------------------------------
#// group VM
#// ----------------------------------------------------------------------
#output "ip_instance_groups" {
#  depends_on = [yandex_compute_instance_group.group1]
#  #  value =  yandex_compute_instance_group.group1.instances.network_interface
#  #  value =  yandex_compute_instance_group.group1.instances.*.instance_id
#  value      = yandex_compute_instance_group.group1.instances.*.network_interface.0.ip_address
#}
#output "ip_instance_groups_nlb" {
#  depends_on = [yandex_compute_instance_group.group1]
#  #  value =  yandex_compute_instance_group.group1.instances.network_interface
#  #  value =  yandex_compute_instance_group.group1.instances.*.instance_id
#  value      = yandex_compute_instance_group.group1.load_balancer.0.target_group_id
#}
#resource "yandex_compute_instance_group" "group1" {
#  name                = "test-ig"
#  folder_id           = var.stockvars.folder_id
#  service_account_id  = var.stockvars.service_account_id
#  deletion_protection = false
#
#  instance_template {
#    platform_id = "standard-v1"
#    resources {
#      memory        = 2
#      cores         = 2
#      #      core_fraction = 100
#    }
#    boot_disk {
#      mode = "READ_WRITE"
#      initialize_params {
#        image_id = var.stockvars.image_id
#        size     = 4
#      }
#    }
#    network_interface {
#      network_id = yandex_vpc_network.basevpc.id
#      subnet_ids = [yandex_vpc_subnet.public.id]
#      nat = true
#    }
#    labels = {
#      label1 = "label1-value"
#      label2 = "label2-value"
#    }
#    metadata = {
#      foo      = "bar"
#      ssh-keys = "aleks:${file("~/.ssh/remoteuser.pub")}"
#      user-data = file("/opt/s.devops/netologia/netology-hw/clopro15.2/iaac/cloud-init.yaml")
#    }
#    network_settings {
#      type = "STANDARD"
#    }
#  }
#
#  variables = {
#    test_key1 = "test_value1"
#    test_key2 = "test_value2"
#  }
#
#  scale_policy {
#    fixed_scale {
#      size = 3
#    }
#  }
#
#  allocation_policy {
#
#    zones = [var.stockvars.zone]
#  }
#  load_balancer {
#    #    target_group_description = "group for nlb"
#    target_group_name = "groupnlb"
#  }
#
#  deploy_policy {
#    max_unavailable = 2
#    max_creating    = 2
#    max_expansion   = 2
#    max_deleting    = 2
#  }
#
#}
#//-----------------------------------------------------------------------
#// целевая группа
#// ----------------------------------------------------------------------
##resource "yandex_lb_target_group" "vmstock" {
##  name = "vmstockgroup"
##  target {
##    subnet_id = yandex_vpc_subnet.public.id
##    #    address  =  yandex_compute_instance_group.group1.instances.*.network_interface.0.ip_address
##    address   = yandex_compute_instance_group.group1.instances.0.network_interface.0.ip_address
##    #    address  =  yandex_compute_instance_group.group1.instances.0.network_interface.0.ip_address
##  }
##  target {
##    subnet_id = yandex_vpc_subnet.public.id
##    #    address  =  yandex_compute_instance_group.group1.instances.*.network_interface.0.ip_address
##    address   = yandex_compute_instance_group.group1.instances.1.network_interface.0.ip_address
##    #    address  =  yandex_compute_instance_group.group1.instances.0.network_interface.0.ip_address
##  }
##  target {
##    subnet_id = yandex_vpc_subnet.public.id
##    #    address  =  yandex_compute_instance_group.group1.instances.*.network_interface.0.ip_address
##    address   = yandex_compute_instance_group.group1.instances.2.network_interface.0.ip_address
##    #    address  =  yandex_compute_instance_group.group1.instances.0.network_interface.0.ip_address
##  }
##
##  #  target {
##  #    subnet_ids = yandex_vpc_subnet.public.id
##  #    address  =  yandex_compute_instance_group.group1.instances.*.network_interface.0.ip_address
##  #  }
##  #  target {
##  #    subnet_id = "<идентификатор_подсети>"
##  #    address   = "<внутренний_IP-адрес_ресурса_2>"
##  #  }
##}
##
#//-----------------------------------------------------------------------
#// NLB
#// ----------------------------------------------------------------------
#output "ip_nlb" {
#  depends_on = [yandex_lb_network_load_balancer.nlb]
#  value      = yandex_lb_network_load_balancer.nlb.listener.*.external_address_spec
#}
#resource "yandex_lb_network_load_balancer" "nlb" {
#  name      = "my-network-load-balancer"
#  folder_id = var.stockvars.folder_id
#
#  listener {
#    name = "my-listener-http"
#    port = 80
#    external_address_spec {
#      ip_version = "ipv4"
#    }
#  }
#  listener {
#    name = "my-listener-ssh"
#    port = 22
#    external_address_spec {
#      ip_version = "ipv4"
#    }
#  }
#  attached_target_group {
#    target_group_id = yandex_compute_instance_group.group1.load_balancer.0.target_group_id
#
#    healthcheck {
#      name = "http"
#      http_options {
#        port = 80
#        path = "/"
#      }
#    }
#  }
#}