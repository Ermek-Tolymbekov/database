--1

--a
select *
from dealer cross join client;

--b
select d.name, c.name, city, priority, s.id, date, amount
from (dealer d inner join client c on d.id = c.dealer_id) inner join sell s
on d.id = s.dealer_id and c.id = s.client_id
order by d.name;

--c
select d.name, c.name
from dealer d inner join client c
on d.location = c.city;

--d
select s.id, amount, c.name, city
from sell s inner join client c on s.client_id = c.id
where amount >= 100 and amount <= 500;

--e
select d.name
from dealer d left join client c on d.id = c.dealer_id
group by d.name;

--f
select c.name, city, d.name, charge
from dealer d left join client c on d.id = c.dealer_id;

--g
select c.name, city, d.name, charge
from dealer d left join client c on d.id = c.dealer_id
where charge > 0.12;

--h
select c.name, city, s.id, date, amount, d.name, charge
from (client c full join dealer d on d.id = c.dealer_id) inner join sell s
on d.id = s.dealer_id and c.id = s.client_id;

--2

--a
create view unique_clients as
    select date, count(distinct client_id) clients, avg(amount) average, sum(amount) total_amount
    from sell
    group by date
    order by date;

--b
create view top_5 as
    select date, sum(amount) total
    from sell
    group by date
    order by total desc
    limit 5;

--c
create view dealer_sales as
    select d.name, count(dealer_id) sales, avg(amount) average, sum(amount) total_amount
    from sell inner join dealer d on d.id = sell.dealer_id
    group by d.name;

--d
create view earned_from_charge as
    select location, sum(amount*charge)
    from sell s inner join dealer d on d.id = s.dealer_id
    group by location;

--e
create view location_sales as
    select location, count(s.id) sales, avg(amount), sum(amount) total
    from sell s inner join dealer d on d.id = s.dealer_id
    group by location
    order by location;

--f
create view city_expenses as
    select city, count(s.id) sales, avg(amount), sum(amount) total
    from sell s inner join client c on c.id = s.client_id
    group by city
    order by city;

--g
--views from tasks e and f: location_sales, city_expenses
create view expensed_cities as
    select city
    from city_expenses c left join location_sales l on c.city = l.location
    where c.total > l.total;
