# Домашнее задание к занятию 10 «Jenkins» Алексей Мартыненко

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
![1](img/1.png)
2. Установить Jenkins при помощи playbook.
   ![2](img/2.png)
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.
   ![3](img/3.png)



## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
![41](img/41.png)

2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
   ![51](img/51.png)
```shell
pipeline {
    agent {
        label 'agent'
    }
    stages {
        stage('clear work dir') {
            steps {
                deleteDir()
            }
        }
        stage('clone repo') {
            steps {
                git branch: 'main', url: 'https://github.com/spouk/roles.git'
            }
        }
        stage('run test') {
            steps {
                sh 'export PATH=$PATH:/usr/local/bin; pwd; ls -la; cd simplerole; molecule test'
            }
        }
    }
}
```
3. Перенести Declarative Pipeline в репозиторий в файл --> [`Jenkinsfile`](https://github.com/spouk/roles/blob/main/Jenkinksfile)

4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
   ![61](img/61.png)
   ![62](img/62.png)

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
   ![71](img/71.png)

6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
   ![81](img/81.png)
   ![82](img/82.png)
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
   ![92](img/92.png)

8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.
+ [`Scripted pipeline`](scriptedpipeline)
+ [`role`](https://github.com/spouk/roles.git) --> `simplerole`

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---


