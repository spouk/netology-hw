# Домашнее задание к занятию "12.5. «Индексы»" - `Мартыненко Алексей`


### Задание 1
Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.
```sql92
select  (sum(INDEX_LENGTH)/sum(DATA_LENGTH))*100 as 'procent'
from information_schema.TABLES
where TABLE_SCHEMA = 'sakila'
and lower(TABLE_TYPE) = 'base table'

```

### Задание 2
Выполните explain analyze следующего запроса:
```sql92
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
перечислите узкие места;
    подключение таблиц в виде перечисляемого списка дает полную сумму длины каждой таблицы к обработке каждого условия, т.к. происходит   table scan
      и в итоге получается, что субд будет использовать самый неоптимальный алгоритм по выборке time table scan (+payment +rental +customer +inventory +film) = последовательный поиск среди суммы всех записей всех таблиц
    
    
оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.
```sql92
select v.names, sum(v.amm)
from (select distinct concat(c.last_name, ' ', c.first_name)                   as names,
                      sum(p.amount) over (partition by c.customer_id, f.title) as amm
      from payment p
               left join rental r on r.rental_date = p.payment_date
               left join customer c on c.customer_id = r.customer_id
               left join inventory i on i.inventory_id = r.inventory_id
               left join film f on f.film_id = i.film_id
      where date(p.payment_date) = '2005-07-30') as v
group by v.names
order by v.names
```

Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 3*
Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

Приведите ответ в свободной форме.


Bitmap index –
метод битовых индексов заключается в создании отдельных битовых карт (последовательность 0 и 1)
для каждого возможного значения столбца,
где каждому биту соответствует строка с индексируемым значением,
а его значение равное 1 означает, что запись,
соответствующая позиции бита содержит индексируемое значение для данного столбца или свойства.



Partial index — это индекс, построенный на части таблицы,
удовлетворяющей определенному условию самого индекса. Данный индекс создан для уменьшения размера индекса.


Function based index Самим же гибким типом индексов являются функциональные индексы, то есть индексы, ключи которых хранят
результат пользовательских функций. Функциональные индексы часто строятся для полей,
значения которых проходят предварительную обработку перед сравнением в команде SQL.


GiST и SP-GiST - тип индексации для данных, представляющих собой к примеру математические координаты геометрической фигура, или
гео-координаты

GIN - "индекс для массивов", в которых есть доступность получения значения ячейки по индексу

BRIN  - индекс, работает с диапазонами блоков (или «диапазонами страниц»).
Блок-диапазон — это группа физически смежных страниц в таблице;
для каждого диапазона блоков некоторая сводная информация хранится в индексе.


### up:

Здравствуйте, Алексей!
Первое задание выполнено верно.

По второму заданию есть замечания:
просьба вывести результат работы explain analyze до оптимизации.
Провести оптимизацию и вывести результат, после оптимизации.
Следует так же обратить внимание, возможно не все таблицы нужны для результата 
работы запроса, из тех к которым обращаются.

```sql
explain analyze
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p,
     rental r,
     customer c,
     inventory i,
     film f
where date(p.payment_date) = '2005-07-30'
  and p.payment_date = r.rental_date
  and r.customer_id = c.customer_id
  and i.inventory_id = r.inventory_id

```

```sql
-> Table scan on <temporary>  (cost=2.50..2.50 rows=0) (actual time=7018.953..7018.998 rows=391 loops=1)
    -> Temporary table with deduplication  (cost=2.50..2.50 rows=0) (actual time=7018.950..7018.950 rows=391 loops=1)
    -> Window aggregate with buffering: sum(payment.amount) OVER (PARTITION BY c.customer_id,f.title )   (actual time=2895.152..6758.072 rows=642000 loops=1)
    -> Sort: c.customer_id, f.title  (actual time=2895.115..2978.655 rows=642000 loops=1)
    -> Stream results  (cost=10345806.38 rows=16009975) (actual time=0.421..2134.694 rows=642000 loops=1)
    -> Nested loop inner join  (cost=10345806.38 rows=16009975) (actual time=0.416..1830.732 rows=642000 loops=1)
    -> Nested loop inner join  (cost=8740806.37 rows=16009975) (actual time=0.401..1621.465 rows=642000 loops=1)
    -> Nested loop inner join  (cost=7135806.35 rows=16009975) (actual time=0.396..1379.877 rows=642000 loops=1)
    -> Inner hash join (no condition)  (cost=1581474.80 rows=15813000) (actual time=0.384..61.796 rows=634000 loops=1)
    -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1.65 rows=15813) (actual time=0.040..7.949 rows=634 loops=1)
    -> Table scan on p  (cost=1.65 rows=15813) (actual time=0.031..5.419 rows=16044 loops=1)
    -> Hash
    -> Covering index scan on f using idx_title  (cost=103.00 rows=1000) (actual time=0.047..0.277 rows=1000 loops=1)
    -> Covering index lookup on r using rental_date (rental_date=p.payment_date)  (cost=0.25 rows=1) (actual time=0.001..0.002 rows=1 loops=634000)
    -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=0.00 rows=1) (actual time=0.000..0.000 rows=1 loops=642000)
    -> Single-row covering index lookup on i using PRIMARY (inventory_id=r.inventory_id)  (cost=0.00 rows=1) (actual time=0.000..0.000 rows=1 loops=642000)
```

```sql92
explain analyze
select v.names, sum(v.amm)
from (select distinct concat(c.last_name, ' ', c.first_name)          as names,
                      sum(p.amount) over (partition by p.customer_id) as amm
      from payment p
               left join customer c on c.customer_id = p.customer_id
      where date(p.payment_date) = '2005-07-30') as v
group by v.names;
```

```sql
-> Table scan on <temporary>  (actual time=19.958..20.024 rows=391 loops=1)
    -> Aggregate using temporary table  (actual time=19.957..19.957 rows=391 loops=1)
        -> Table scan on v  (cost=2.50..2.50 rows=0) (actual time=19.374..19.465 rows=391 loops=1)
            -> Materialize  (cost=5.00..5.00 rows=0) (actual time=19.374..19.374 rows=391 loops=1)
                -> Table scan on <temporary>  (cost=2.50..2.50 rows=0) (actual time=19.148..19.236 rows=391 loops=1)
                    -> Temporary table with deduplication  (cost=2.50..2.50 rows=0) (actual time=19.146..19.146 rows=391 loops=1)
                        -> Window aggregate with buffering: sum(payment.amount) OVER (PARTITION BY p.customer_id )   (actual time=16.808..18.794 rows=634 loops=1)
                            -> Sort: p.customer_id  (actual time=16.767..16.893 rows=634 loops=1)
                                -> Stream results  (cost=7140.10 rows=15813) (actual time=0.200..16.442 rows=634 loops=1)
                                    -> Nested loop left join  (cost=7140.10 rows=15813) (actual time=0.164..15.852 rows=634 loops=1)
                                        -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1605.55 rows=15813) (actual time=0.149..14.425 rows=634 loops=1)
                                            -> Table scan on p  (cost=1605.55 rows=15813) (actual time=0.128..11.640 rows=16044 loops=1)
                                        -> Single-row index lookup on c using PRIMARY (customer_id=p.customer_id)  (cost=0.25 rows=1) (actual time=0.002..0.002 rows=1 loops=634)

```
