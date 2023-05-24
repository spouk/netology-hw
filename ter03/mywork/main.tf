resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name = var.vpc_name
  zone = var.default_zone
  network_id = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
////-----------------------------------------------------------------------
// make ansible `host.cfg` from template file
// ----------------------------------------------------------------------
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tpl",
  {
    sc = yandex_compute_instance.platform,
    sfe = yandex_compute_instance.vmstock,
    sdisk = [
      yandex_compute_instance.vmdisk]
    //count elements in struct > 2, without [] get error with `plan`
  }  )
  filename = "${abspath(path.module)}/hosts.cfg"
}

//-----------------------------------------------------------------------
// use ansible playbook for example
// ----------------------------------------------------------------------
resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [
    yandex_compute_instance.platform,
    yandex_compute_instance.vmdisk,
    yandex_compute_instance.vmstock]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "cat ~/.ssh/id_rsa | ssh-add -"
  }

  #Костыль!!! Даем ВМ время на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
  provisioner "local-exec" {
    command = "sleep 30"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/test.yml"
    on_failure = continue
    #Продолжить выполнение terraform pipeline в случае ошибок
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    always_run = "${timestamp()}"
    #всегда т.к. дата и время постоянно изменяются
    playbook_src_hash = file("${abspath(path.module)}/test.yml")
    # при изменении содержимого playbook файла
    ssh_public_key = var.metadata.ssh-keys
    # при изменении переменной
  }
}


