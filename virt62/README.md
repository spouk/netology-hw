# Домашнее задание к занятию "6.2 SQL `Мартыненко Алексей`


### Задача 1
Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose-манифест.

```dockerfile
version: "3"

networks:
  app-tier:
    driver: bridge

services:
  postgresql:
    image: 'bitnami/postgresql:12'
    container_name: psql-db1
    ports:
      - '5555:5432'
    environment:
        - POSTGRESQL_PASSWORD=postgres
        - POSTGRESQL_POSTGRES_PASSWORD=postgres
    volumes:
      - /home/spouk/stock/s.develop/go/src/github.com/spouk/netology-hw/virt62/src/dbs:/bitnami/postgresql
      - /home/spouk/stock/s.develop/go/src/github.com/spouk/netology-hw/virt62/src/dbs/backup:/bitnami/backup
    networks:
        - app-tier
    restart: always
```

### Задача 2
В БД из задачи 1:

  * создайте пользователя test-admin-user и БД test_db;
  * в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
  * предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
  * создайте пользователя test-simple-user;
  * предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.

```sql92
Таблица orders:
id (serial primary key);
наименование (string);
цена (integer).

```

```sql92
Таблица clients:

id (serial primary key);
фамилия (string);
страна проживания (string, index);
заказ (foreign key orders).
```
Приведите:

>итоговый список БД после выполнения пунктов выше;
```sql

test_db=# \l
                                      List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |       Access privileges
-----------+----------+----------+-------------+-------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres                   +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres                   +
           |          |          |             |             | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres                  +
           |          |          |             |             | postgres=CTc/postgres         +
           |          |          |             |             | "test-admin-user"=CTc/postgres
(4 rows)

```

>описание таблиц (describe);
```sql
test_db=# \d+ clients;
                                                           Table "public.clients"
    Column    |          Type           | Collation | Nullable |               Default               | Storage  | Stats target | Description
--------------+-------------------------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id           | integer                 |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 family       | character varying(2048) |           |          |                                     | extended |              |
 countryplace | character varying(2048) |           |          |                                     | extended |              |
 orderid      | integer                 |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "countryplace_idx" btree (countryplace)
Foreign-key constraints:
    "clients_orderid_fkey" FOREIGN KEY (orderid) REFERENCES orders(id)
Access method: heap

test_db=# \d+ orders;
                                                        Table "public.orders"
 Column |          Type           | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-------------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer                 |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 name   | character varying(1024) |           |          |                                    | extended |              |
 cost   | integer                 |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_orderid_fkey" FOREIGN KEY (orderid) REFERENCES orders(id)
Access method: heap

test_db=#

```

>SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
```sql92
SELECT table_name, grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name in (
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
)
order by  table_name;

```
список пользователей с правами над таблицами test_db.
```sql
test_db=# SELECT table_name, grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name in (
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
)
order by  table_name;
 table_name |     grantee      | privilege_type
------------+------------------+----------------
 clients    | postgres         | TRUNCATE
 clients    | postgres         | REFERENCES
 clients    | postgres         | TRIGGER
 clients    | test-admin-user  | INSERT
 clients    | test-admin-user  | SELECT
 clients    | test-admin-user  | UPDATE
 clients    | test-admin-user  | DELETE
 clients    | test-admin-user  | TRUNCATE
 clients    | test-admin-user  | REFERENCES
 clients    | test-admin-user  | TRIGGER
 clients    | postgres         | INSERT
 clients    | postgres         | SELECT
 clients    | postgres         | UPDATE
 clients    | postgres         | DELETE
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
 orders     | test-admin-user  | TRUNCATE
 orders     | postgres         | SELECT
 orders     | postgres         | UPDATE
 orders     | postgres         | DELETE
 orders     | postgres         | TRUNCATE
 orders     | postgres         | REFERENCES
 orders     | postgres         | TRIGGER
 orders     | test-admin-user  | INSERT
 orders     | test-admin-user  | SELECT
 orders     | test-admin-user  | UPDATE
 orders     | test-admin-user  | DELETE
 orders     | postgres         | INSERT
 orders     | test-admin-user  | REFERENCES
 orders     | test-admin-user  | TRIGGER
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
(36 rows)

```


### Задача 3
Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:

```html
Таблица orders

Наименование	цена
Шоколад	10
Принтер	3000
Книга	500
Монитор	7000
Гитара	4000
```
```html
Таблица clients

ФИО	Страна проживания
Иванов Иван Иванович	USA
Петров Петр Петрович	Canada
Иоганн Себастьян Бах	Japan
Ронни Джеймс Дио	Russia
Ritchie Blackmore	Russia
```

Используя SQL-синтаксис:

>  вычислите количество записей для каждой таблицы.
Приведите в ответе:
> - запросы,
> - результаты их выполнения.

```sql92
    select count(*) as clientscount from clients;
    select count(*) as orderscount from orders;
```

```sql
test_db=#  select count(*) as clientscount from clients;
 clientscount
--------------
            5
(1 row)

test_db=#  select count(*) as orderscount from orders;
 orderscount
-------------
           5
(1 row)
```


### Задача 4
  Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

>Используя foreign keys, свяжите записи из таблиц, согласно таблице:
```sql
ФИО	Заказ
Иванов Иван Иванович	Книга
Петров Петр Петрович	Монитор
Иоганн Себастьян Бах	Гитара

```

> Приведите SQL-запросы для выполнения этих операций.
```sql
-- update record
update clients set orderid = (select id from orders where name = 'Книга') where family = 'Иванов Иван Иванович';

-- update record
update clients
set orderid = (select id from orders where name = 'Монитор')
where family = 'Петров Петр Петрович';

-- update record
update clients
set orderid = (select id from orders where name = 'Гитара')
where family = 'Иоганн Себастьян Бах';

```

> Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.
> 
```sql
select * from clients where orderid is not null;

 id |        family        | countryplace | orderid
----+----------------------+--------------+---------
  1 | Иванов Иван Иванович | USA          |       3
  2 | Петров Петр Петрович | Canada       |       4
  3 | Иоганн Себастьян Бах | Japan        |       5
(3 rows)
```
Подсказка: используйте директиву UPDATE.


### Задача 5
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
```sql
explain select * from clients where orderid is not null;

```

Приведите получившийся результат и объясните, что значат полученные значения.
```sql
Seq Scan on clients  (cost=0.00..10.70 rows=70 width=1040)
  Filter: (orderid IS NOT NULL)

Seq Scan on clients - линейное сканирование, по факту перебор всех значений в таблице
cost=0.00..10.70  - 0.00 = примерное время, после которого можно ожидать получения результата  
                    10.70 = примерное общее время завершения запроса, расчитывается приблизительно учитывается количество строк
rows=70  - ожидаемое количество строк
width=1040 - ожидаемый размер строки вывода в байтах
```

### Задача 6
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

```shell
# - backup database 
docker exec -u 0 -it $(docker ps -ql) bash
pg_dump  -h localhost -p 5432 -d test_db -u postgres -w > /bitnami/backup/testdb.dump

# - restore database 
подключаюсь к новой базе и создаю там пустую базу test_db
psql "host=localhost port=5555 user=postgres password=postgres"
create database test_db;

# - после восстанавливаю данные базы из дампа из нового инстанса postgresql
docker exec -u 0 -it $(docker ps -ql) bash
psql -U postgres -W test_db < /bitnami/backup/testdb.dump
```


