
# Домашнее задание к занятию «Микросервисы: масштабирование»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: Кластеризация

Предложите решение для обеспечения развёртывания, запуска и управления приложениями.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- поддержка контейнеров;
- обеспечивать обнаружение сервисов и маршрутизацию запросов;
- обеспечивать возможность горизонтального масштабирования;
- обеспечивать возможность автоматического масштабирования;
- обеспечивать явное разделение ресурсов, доступных извне и внутри системы;
- обеспечивать возможность конфигурировать приложения с помощью переменных среды,
в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т. п.

Обоснуйте свой выбор.

На текущий момент на рынке представлены несколько программных продктов, которые в первом приближении вроде-бы 
полностью удовлетворяют заявленным критериям.Это,
- Kubernetes
- Docker Swarm
- Nomad
- Apache Mesos

При пристальном просмотре возможностей каждого продукта, выясняется, что заданные требования в полном объеме поддерживает
только  Kubernetes, также поддерживает как вертикальное так и горизонтальное масштабирование, наименьший vendor lock-in, 
обширные возможности по кастомизации кластеров, возможность относительно быстрого старта от момента начального обучения возможностям продукта
оканчивая полноценной работой с использованием последнего, +поддержка "из коробки" разных стратегий обновления приложения,
коробочная поддержка методологии IaC, что сильно уменьшает последующие затраты при развертывании/миграции сервисов/проекта в целом
У Docker Swarm из плюсов - низкий порог вхождения в использование продукта, из минусов строгое ограничение на использование
только технологии docker-контейнеризации, нет поддержки автоматическое масштабирование, отсутствует встроенная поддержка шаблонизации
Nomad - в целом похож на dockerswarm, из основных плюсов, что в качестве объекта оркестрации могут выступать не только 
docker контейнеры и вообще не только контейнеры, это могут быть и виртуальные машины и бинарники Java (как платформонезависимые для запуска),
есть компиляции под все платформы.Главный минус - за многие "фичи", указанные в критерии надо платить, т.к. это все если и есть то только
в Enterprise редакции, также отсутствует балансировка,нет автомасштабирования, манифесты пишутся на HCL (дефолт для продуктов от HashCorp for ex Terraform)
Apache Mesos - из минусов, отстуствует автоматическое масштабирование, поддержка только docker + mesos containerd,малнькое коммунити 

Я бы выбрал Kubernetes. Причины - удовлетворяет всем критериям, open-source продукт, в этой связи обширное коммьюнити, много уже реализованных паттернов,
и хорошо документирован. 



 
