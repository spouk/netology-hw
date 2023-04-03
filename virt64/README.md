# Домашнее задание к занятию "6.4 «PostgreSQL» `Мартыненко Алексей`


### Задача 1
Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя psql.

Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

Найдите и приведите управляющие команды для:

* вывода списка БД
  `\l[+] или \list[+]`    
* подключения к БД,
  `\c или \connect [ -reuse-previous=on|off ] [ имя_бд [ имя_пользователя ] [ компьютер ] [ порт ] | строка_подключения ]`
* вывода списка таблиц,
   `\dp` 
* вывода описания содержимого таблиц,
    `\d+ <имя таблицы>`
* выхода из psql.
    `\q`

```dockerfile
version: "3"

networks:
  app-tier:
    driver: bridge

services:
  postgresql:
    image: 'bitnami/postgresql:13'
    container_name: psql-db3
    ports:
      - '6666:5432'
    environment:
        - POSTGRESQL_PASSWORD=postgres
        - POSTGRESQL_POSTGRES_PASSWORD=postgres
    volumes:
      - /home/spouk/stock/s.develop/go/src/github.com/spouk/netology-hw/virt64/src/dbs/data:/bitnami/postgresql
      - /home/spouk/stock/s.develop/go/src/github.com/spouk/netology-hw/virt64/src/dbs/backup:/bitnami/backup
    networks:
        - app-tier
    restart: always
```

### Задача 2
Используя psql, создайте БД test_database.
Изучите бэкап БД.
Восстановите бэкап БД в test_database.
Перейдите в управляющую консоль psql внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат.

```sql92
select tablename,attname,avg_width from pg_stats 
where tablename = 'orders'  order by avg_width desc limit 1;

test_database=# select tablename,attname,avg_width from pg_stats
                where tablename = 'orders'  order by avg_width desc limit 1;
tablename | attname | avg_width
-----------+---------+-----------
 orders    | title   |        16
(1 row)

test_database=#

```


### Задача 3
> Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.
> Предложите SQL-транзакцию для проведения этой операции.

```sql92
start transaction;
    create table orders_shard(id serial, title varchar(80) not null, price integer default 0) partition by range (price);
    create table orders_price_top partition of orders_shard for values from (0) to (500);
    create table orders_price_tail partition of orders_shard for values from (500) to (2147483647); -- 4byte=>max size integer type-1
    create index  on  orders_shard (id);
    drop table orders;
    alter table orders_new rename to orders;
commit;

```

> Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

Теоретически - да, практически - нет, т.к. отсутствуeт нужная статистика для принятия решения о разбиении. 
По факту, на момент запуска проекта мы не можем предположить, что "вот такой вот размер такой-то таблицы значительно
ухудшит временные метрики выполнение обращений к базе данных". Следует не забывать, что эта практика - один из методов _оптимизации нагрузки_,
а не дефолтное архитектурное решение при запуске любого проекта.


### Задача 4
> Используя утилиту pg_dump, создайте бекап БД test_database.
```shell
pg_dump -U postgres test_database > /bitnami/backup/test_database_dump.sql

```

> Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

```sql92
--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders1 (
    id integer NOT NULL,
    title character varying(80) NOT NULL unique,
    price integer DEFAULT 0
);

```


