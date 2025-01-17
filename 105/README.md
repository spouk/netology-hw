# Домашнее задание к занятию "`10.5 Балансировка нагрузки. HAProxy/Nginx`" - `Мартыненко Алексей`

---

### Задание 1

Что такое балансировка нагрузки и зачем она нужна?

балансировка нагрузки - способ распределения входящих запросов ( в общем контексте - есть входящие подключения, их обработка и дальнейшее распределение согласно алгоритмам балансировки),
						между пулом "обработчиков запросов" (под обработчиков запросов можно понимать - субд, http/https мультиплексор, прокси сервер, etc...) 
						задача повысить до максимальных значений (в идеале 100%) уровень доступности сервиса,+ динамически масштабировать пулл обработчиков согласно текущей нагрузке 


### Задание 2


Чем отличаются между собой алгоритмы балансировки round robin и weighted round robin? В каких случаях каждый из них лучше применять?

Приведите ответ в свободной форме.

round robin - последовательное _линейное_ распределение поступающих входящих запросов между пулом "обработчиков запросов"
weighted round robin - тоже самое, что round robin но с добавлением "веса" конечного обработчика из пула, вес влияет на количество запросов (потенциальную пропускную способность по каждому "обработчику", входящему в пулл)



### Задание 3
Установите и запустите haproxy.

Приведите скриншот systemctl status haproxy, где будет видно, что haproxy запущен.



![haproxyrunning](img/3.png)


### Задание 4
Установите и запустите nginx.

Приведите скриншот systemctl status nginx, где будет видно, что nginx запущен.


![nginxrunning](img/4.png)


### Задание 5

Настройте nginx на виртуальной машине таким образом, чтобы при запросе:

curl http://localhost:8088/ping

он возвращал в ответе строчку:

"nginx is configured correctly"

Приведите скриншот получившейся конфигурации.

![nginxcorrectly](img/5.png)



### Задание 6*
Дополнительные задания (со звездочкой*)
Эти задания дополнительные (не обязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. Вы можете их выполнить, если хотите глубже и/или шире разобраться в материале.

Настройте haproxy таким образом, чтобы при ответе на запрос:

curl http://localhost:8080/

он проксировал его в nginx на порту 8088, который был настроен в задании 5 и возвращал от него ответ:

"nginx is configured correctly".

Приведите скриншот получившейся конфигурации.



![naproxy](img/6.png)


