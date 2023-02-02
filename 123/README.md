# Домашнее задание к занятию "`12.3. «SQL. Часть 1»`" - `Мартыненко Алексей`

### Задание 1
Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.
```sql92
 select a.district
 from address a
 where left(a.district,1) = 'K'
 and right(a.district,1) ='a'
 and position(' ' in a.district) = 0
```

### Задание 2
Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года включительно и стоимость которых превышает 10.00.
```sql92
select p.*
from payment p
 where p.payment_date between  cast('2005-06-15 00:00:00' as datetime ) and cast('2005-06-18 23:59:00' as datetime)
and p.amount > 10.00
order by  p.payment_date asc

```
### Задание 3
Получите последние пять аренд фильмов.
```sql92
select r.*
from rental r
order by r.rental_date desc
limit 5;
```
### Задание 4
Одним запросом получите активных покупателей, имена которых Kelly или Willie.
Сформируйте вывод в результат таким образом:
все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
замените буквы 'll' в именах на 'pp'.
```sql92
select
 c.customer_id,
 c.store_id,
 lower(c.first_name),
 lower(c.last_name),
 c.email,
 concat_ws('@', lower(left(c.email, position('@' in c.email)-1)), right(c.email,length(c.email) - position('@' in c.email))),
 c.address_id,
 c.active,
 c.create_date,
 c.last_update
from customer c
where lower(c.first_name) in ('kelly','willie');
```


Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 5*
Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.
```sql92
select
    left(c.email, position('@' in c.email)-1) as firstname,
    right(c.email,length(c.email) - position('@' in c.email)) as lastname
from customer c

```
### Задание 6*
Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные — строчными.
```sql92
select
    concat(left(left(c.email, position('@' in c.email)-1),1), lower(right(left(c.email, position('@' in c.email)-1), length(left(c.email, position('@' in c.email)-1)) - 1)))  as firstname,
    right(c.email,length(c.email) - position('@' in c.email)) as lastname
from customer c

```

