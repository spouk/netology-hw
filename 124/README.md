# Домашнее задание к занятию "`SQL. Часть 2`" - `Мартыненко Алексей`

### Задание 1
Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию:

фамилия и имя сотрудника из этого магазина;
город нахождения магазина;
количество пользователей, закреплённых в этом магазине.
```sql92
select
    -- family and name person
    s.first_name, s.last_name,
    -- store town place
    (select city from city where a.city_id = city.city_id) as town,
    -- count customers
    (select count(cu.customer_id) from customer cu where s.store_id = cu.store_id)  as countcustomer
from staff s
         left join store ss on ss.manager_staff_id = s.staff_id
         left join address a on s.address_id = a.address_id
where  (select count(cu.customer_id) from customer cu where s.store_id = cu.store_id)  > 300;

```
### Задание 2
Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.
```sql92
select count(f.film_id) as countfilms
from film f
where f.length > (
    select avg(ff.length) from film ff
    );

```
### Задание 3
Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.
```sql92
select month(p.payment_date) as mount, sum(p.amount) as totalammount, count(r.rental_id) as countrental
from payment p
left join rental r on r.rental_id = p.rental_id
group by month(p.payment_date)
order by totalammount desc
limit 1

```
Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 4*
Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».
```sql92
select f.first_name, f.last_name, f.email,
       count(p.payment_id) as countpays,
       case
           when count(p.payment_id) > 8000 then 'Да'
           else 'Нет'
           end as addpayment
from staff f
         left join payment p on f.staff_id = p.staff_id
         left join customer c on p.customer_id = c.customer_id
group by  f.staff_id

```
### Задание 5*
Найдите фильмы, которые ни разу не брали в аренду.
```sql92
select f.*
from film f
where f.film_id not in (select film_id from inventory)
```

