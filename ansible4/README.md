# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```
```shell
  Файл: requirements.yml
  Размер: 122       	Блоков: 8          Блок В/В: 4096   обычный файл
  Устройство: 0/25	Инода: 2580394     Ссылки: 1
  Доступ: (0644/-rw-r--r--)  Uid: ( 1000/   spouk)   Gid: ( 1000/   spouk)
  Доступ:        2023-06-25 05:22:20.639141631 +0300
  Модифицирован: 2023-06-25 05:22:18.116173349 +0300
  Изменён:       2023-06-25 05:22:18.116173349 +0300
  Создан:        2023-06-25 05:22:13.652229468 +0300
```
2. При помощи `ansible-galaxy` скачайте себе эту роль.
```shell
tree ~/.ansible/roles 
╰─➤  tree ~/.ansible/roles
/home/spouk/.ansible/roles
└── clickhouse
    ├── README.md
    ├── defaults
    │   └── main.yml
    ├── handlers
    │   └── main.yml
    ├── meta
    │   └── main.yml
    ├── molecule
    │   ├── centos_7
    │   │   ├── converge.yml
    │   │   ├── molecule.yml
    │   │   ├── ubuntu_bionic
    │   │   │   └── molecule.yml
    │   │   └── verify.yml
    │   ├── centos_8
    │   │   ├── converge.yml
    │   │   ├── molecule.yml
    │   │   ├── ubuntu_bionic
    │   │   │   └── molecule.yml
    │   │   └── verify.yml
    │   ├── debian_bullseye
    │   │   └── molecule.yml
    │   ├── debian_buster
    │   │   └── molecule.yml
    │   ├── debian_jessie
    │   │   └── molecule.yml
    │   ├── debian_stretch
    │   │   └── molecule.yml
    │   ├── resources
    │   │   ├── Dockerfile.j2
    │   │   ├── Dockerfile_jessie.j2
    │   │   ├── inventory
    │   │   │   ├── group_vars
    │   │   │   │   └── all.yml
    │   │   │   ├── host_vars
    │   │   │   └── hosts.yml
    │   │   ├── playbooks
    │   │   │   └── converge.yml
    │   │   └── tests
    │   │       └── verify.yml
    │   ├── ubuntu_bionic
    │   │   └── molecule.yml
    │   ├── ubuntu_focal
    │   │   ├── converge.yml
    │   │   ├── molecule.yml
    │   │   └── verify.yml
    │   └── ubuntu_xenial
    │       └── molecule.yml
    ├── requirements-test.txt
    ├── tasks
    │   ├── configure
    │   │   ├── db.yml
    │   │   ├── dict.yml
    │   │   └── sys.yml
    │   ├── empty.yml
    │   ├── install
    │   │   ├── apt.yml
    │   │   ├── dnf.yml
    │   │   └── yum.yml
    │   ├── main.yml
    │   ├── params.yml
    │   ├── precheck.yml
    │   ├── remove
    │   │   ├── apt.yml
    │   │   ├── dnf.yml
    │   │   └── yum.yml
    │   ├── remove.yml
    │   └── service.yml
    ├── templates
    │   ├── config.j2
    │   ├── dicts.j2
    │   ├── macros.j2
    │   ├── remote_servers.j2
    │   ├── users.j2
    │   └── zookeeper-servers.j2
    └── vars
        ├── debian.yml
        ├── empty.yml
        ├── main.yml
        └── redhat.yml

29 directories, 53 files
```
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
+
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`.
+
5. Перенести нужные шаблоны конфигов в `templates`.
+
6. Опишите в `README.md` обе роли и их параметры.
+
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
+
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
```shell
╭─spouk@nbst /opt/s.devops/netologia/netology-hw/ansible4/playbook  ‹main*›
╰─➤  ansible-galaxy install -r requirements.yml
Starting galaxy role install process
- clickhouse (1.11.0) is already installed, skipping.
- extracting lighthouse to /home/spouk/.ansible/roles/lighthouse
- lighthouse (0.0.1) was installed successfully
- extracting vector to /home/spouk/.ansible/roles/vector
- vector (0.0.1) was installed successfully
╭─spouk@nbst /opt/s.devops/netologia/netology-hw/ansible4/playbook  ‹main*›
╰─➤  cat requirements.yml
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.11.0"
    name: clickhouse
  - src: git@github.com:spouk/lighthouse-role.git
    scm: git
    version: "0.0.1"
    name: lighthouse
  - src: git@github.com:spouk/vector-role.git
    scm: git
    version: "0.0.1"
    name: vector
╭─spouk@nbst /opt/s.devops/netologia/netology-hw/ansible4/playbook  ‹main*›
╰─➤

```
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

+ https://github.com/spouk/lighthouse-role/tree/0.0.1 
+ https://github.com/spouk/vector-role/tree/0.0.1
+ https://github.com/spouk/netology-hw/tree/main/ansible4/playbook

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
