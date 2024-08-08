--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select concat_ws(' ',cu.last_name , cu.first_name) as "Customer name",
a.address,c.city, co.country
from customer cu
join address a on a.address_id=cu.address_id 
join city c on c.city_id=a.city_id 
join country co on co.country_id=c.country_id 


--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select cu.store_id as "id магазина",count(cu.customer_id) as"Количество покупателей"
from customer cu
join store s on s.store_id=cu.store_id
group by cu.store_id


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select cu.store_id as "id магазина",count(cu.customer_id) as"Количество покупателей"
from customer cu
join store s on s.store_id=cu.store_id
group by cu.store_id
having count(cu.customer_id)>300



-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select cu.store_id as "id магазина",count(cu.customer_id) as"Количество покупателей", 
c.city AS "Город", concat_ws(' ',st.last_name , st.first_name) as "Фамилия и имя сотрудника" 
from customer cu
join store s on s.store_id=cu.store_id
JOIN address a ON a.address_id=s.address_id
join city c on c.city_id=a.city_id 
join staff st on st.store_id = s.store_id 
group by cu.store_id, c.city_id, st.staff_id  
having count(cu.customer_id)>300



--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select cu.customer_id,concat_ws(' ',cu.last_name , cu.first_name) as "Фамилия и имя покупателя",
count(r.inventory_id) AS "Количество фильмов"
from customer cu
join rental r on r.customer_id= cu.customer_id
group by cu.customer_id 
limit 5



--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select cu.customer_id, concat_ws(' ',cu.last_name , cu.first_name) as "Фамилия и имя покупателя",
count(r.rental_id) as "Количесство фильмов",sum(p.amount) as "Общая стоимость платежей",
min(p.amount), max(p.amount)
from customer cu
join rental r on r.customer_id=cu.customer_id
join payment p ON p.rental_id =r.rental_id 
join inventory i on i.inventory_id =r.inventory_id
group by cu.customer_id 



--ЗАДАНИЕ №5
--Используя данные из таблицы городов, составьте все возможные пары городов так, чтобы 
--в результате не было пар с одинаковыми названиями городов. Решение должно быть через Декартово произведение.
 
select distinct c1.city as "Город 1", c2.city as "Город 2"
from city c1
cross join city c2
where c1.city>c2.city



--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и 
--дате возврата (поле return_date), вычислите для каждого покупателя среднее количество 
--дней, за которые он возвращает фильмы. В результате должны быть дробные значения, а не интервал.
 
select cu.customer_id as "id покупателя" ,
round((avg(return_date::date- rental_date::date)),2) as "Среднее количество дней на возврат"
from customer cu
join rental r on r.customer_id = cu.customer_id  
group by cu.customer_id 



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.





--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью него фильмы, которые отсутствуют на dvd дисках.





--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".







