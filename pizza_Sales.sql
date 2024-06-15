
use project;

create table pizza_sales(
pizza_id int unique not null,
order_id int,
pizza_name_id varchar(255),
quantity int,
order_date date,
order_time time,
unit_price decimal (5,2),
total_price decimal (5,2),
pizza_size char,
pizza_category varchar(255),
pizza_ingredients varchar(255),
pizza_name varchar(255),
primary key(pizza_id)

);

select * from pizza_sales;
describe pizza_sales;

-- checking for the null values 
select count(*) , count(case when pizza_name is null then 1 end) from pizza_sales;
select count(*) , count(case when pizza_ingredients is null then 1 end) from pizza_sales;
select count(*) , count(case when pizza_category is null then 1 end) from pizza_sales;
select count(*) , count(case when pizza_size is null then 1 end) from pizza_sales;
select count(*) , count(case when total_price is null then 1 end) from pizza_sales;
select count(*) , count(case when unit_price is null then 1 end) from pizza_sales;
select count(*) , count(case when order_time is null then 1 end) from pizza_sales;
select count(*) , count(case when order_date is null then 1 end) from pizza_sales;
select count(*) , count(case when quantity is null then 1 end) from pizza_sales;
select count(*) , count(case when pizza_name_id is null then 1 end) from pizza_sales;
select count(*) , count(case when order_id is null then 1 end) from pizza_sales;
select count(*) , count(case when pizza_id is null then 1 end) from pizza_sales; -- there are no null values row wise
-- no null values are present

-- checking the duplicate row id
select pizza_id , count(pizza_id) as count_ from pizza_sales group by pizza_id having count_ > 1;

-- ****************************************************************************************************************************************************************************************************************

-- Business tasks:

-- ****************************************************************************************************************************************************************************************************************

-- 1) What days and times do we tend to be busiest?

with data_1 as (
select dayname(order_date) as day_ , count(pizza_id) as pizza_count , hour(order_time) as hour_ from pizza_sales group by day_ , hour_ ),
data_2 as (select data_1.*, row_number() over (partition by day_ order by pizza_count desc) as number_ from data_1),
data_3 as (select day_,hour_ from data_2 where number_ = 1)
select * from data_3; 


-- ********************************************************************************************************************************************************************************************************************

-- 2) How many pizzas are we making during peak periods?


with data_1 as (
select dayname(order_date) as day_ , count(pizza_id) as pizza_count , hour(order_time) as hour_ from pizza_sales group by day_ , hour_ ),
data_2 as (select data_1.*, row_number() over (partition by day_ order by pizza_count desc) as number_ from data_1),
data_3 as (select day_,hour_,pizza_count from data_2 where number_ = 1)
select * from data_3; 

-- **************************************************************************************************************************************************************************************************************************

-- 3) What are our best and worst-selling pizzas?

with data_1 as (
select pizza_name_id , count(pizza_id) as count_  from pizza_sales group by pizza_name_id),
data_2 as (
select pizza_name_id , 
 case
when count_ = (select max(count_) from data_1)
then 'best'
when count_ = (select min(count_) from data_1)
then 'worst'
end as category from data_1 where count_ = (select max(count_) from data_1) or count_  = (select min(count_) from data_1)
)
select * from data_2;

-- *********************************************************************************************************************************************************************************************************************

-- 4) What's our average Revenue?

-- calculating the avg revenue on day to day basis:-

with data_1 as (
select dayname(order_Date) as day_ , week(order_date) as week_  , sum(total_price) as revenue from pizza_sales group by day_,week_),
data_2 as (
select avg(revenue) as avg_revenue_by_day from data_1
)
select * from data_2;

-- calculating the revenue on weekly basis:-

with data_1 as (
select  week(order_date) as week_  , sum(total_price) as revenue from pizza_sales group by week_),
data_2 as (
select avg(revenue) as avg_revenue_by_week from data_1
)
select * from data_2;

-- calulating the revenue on monthly basis:-

with data_1 as (
select  month(order_date) as month_  , sum(total_price) as revenue from pizza_sales group by month_),
data_2 as (
select avg(revenue) as avg_revenue_by_month from data_1
)
select * from data_2;


-- *********************************************************************************************************************************************************************************************************************

-- 5) What is our monthly order performance?

select monthname(order_DAte) month_ , count(distinct order_id) as orders_ from pizza_Sales group by month_ order by orders_ desc;

-- *********************************************************************************************************************************************************************************************************************

-- 6) What is the order performance of our various pizza sizes?

select  pizza_Size , count(distinct order_id) as orders_ from pizza_sales group by pizza_size;

-- *********************************************************************************************************************************************************************************************************************


-- 7) Which of our Pizza Category is the most in demand?
with data_1 as (
select pizza_category , count(distinct order_id) as count_ from pizza_sales group by pizza_category),
data_2 as (select * from data_1 where count_ = (select max(count_) from data_1))
select * from data_2;

-- *********************************************************************************************************************************************************************************************************************


-- 8) What is our monthly revenue performance?
select  monthname(order_date) as month_  , sum(total_price) as revenue from pizza_sales group by month_;


-- *********************************************************************************************************************************************************************************************************************


