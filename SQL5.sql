--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

SELECT film_id, title, special_features
FROM film
where special_features @> ARRAY['Behind the Scenes']



--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.


select film_id, title, special_features
from film
where special_features && array['Behind the Scenes']


select film_id, title, special_features
from film
where 'Behind the Scenes' = any(special_features)





--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

with cte AS 
		(SELECT film_id, title, special_features
		 FROM film
		 where special_features @> ARRAY['Behind the Scenes']) 
select cu.customer_id,count(cte.film_id) as "Количество фильмов"
from customer cu
join rental r on r.customer_id= cu.customer_id
join inventory i on r.inventory_id = i.inventory_id
join cte on cte.film_id = i.film_id
group by cu.customer_id
order by cu.customer_id 
	



--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.

select cu.customer_id,count(t.film_id) as "Количество фильмов"
from customer cu
join rental r on r.customer_id= cu.customer_id
join inventory i on r.inventory_id = i.inventory_id
join (SELECT film_id, title, special_features
		 FROM film
		 where special_features @> ARRAY['Behind the Scenes']) t
on t.film_id = i.film_id
group by cu.customer_id
order by cu.customer_id



--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view task_1 as
select cu.customer_id,count(t.film_id) as "Количество фильмов"
from customer cu
join rental r on r.customer_id= cu.customer_id
join inventory i on r.inventory_id = i.inventory_id
join (SELECT film_id, title, special_features
		 FROM film
		 where special_features @> ARRAY['Behind the Scenes']) t
on t.film_id = i.film_id
group by cu.customer_id
order by cu.customer_id;

refresh materialized view task_1;



--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ стоимости выполнения запросов из предыдущих заданий и ответьте на вопросы:
--1. с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания: 
--поиск значения в массиве затрачивает меньше ресурсов системы;
--2. какой вариант вычислений затрачивает меньше ресурсов системы: 
--с использованием CTE или с использованием подзапроса.

1. 
explain analyze --67.5/1.09
SELECT film_id, title, special_features
FROM film
where special_features @> ARRAY['Behind the Scenes']

explain analyze --67.5/1.2
select film_id, title, special_features
from film
where special_features && array['Behind the Scenes']

explain analyze --77.5/0.731
select film_id, title, special_features
from film
where 'Behind the Scenes' = any(special_features)

Быстрее работает с =any, по стоимости - с @> и c && одинаково, у =ANY больше.

2.
explain analyze --720.76/24.99
with cte AS 
		(SELECT film_id, title, special_features
		 FROM film
		 where special_features @> ARRAY['Behind the Scenes']) 
select cu.customer_id,count(cte.film_id) as "Количество фильмов"
from customer cu
join rental r on r.customer_id= cu.customer_id
join inventory i on r.inventory_id = i.inventory_id
join cte on cte.film_id = i.film_id
group by cu.customer_id
order by cu.customer_id 

explain analyze --720.76/25.646
select cu.customer_id,count(t.film_id) as "Количество фильмов"
from customer cu
join rental r on r.customer_id= cu.customer_id
join inventory i on r.inventory_id = i.inventory_id
join (SELECT film_id, title, special_features
		 FROM film
		 where special_features @> ARRAY['Behind the Scenes']) t
on t.film_id = i.film_id
group by cu.customer_id
order by cu.customer_id

Быстрее работает CTE, по стоимости одинаково




--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии

--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.





--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день




