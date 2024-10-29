use sql_project;

-- READ THE DATASET --
select * from cust_dimen;
select * from market_fact_full;
select * from orders_dimen;
select * from prod_dimen;
select * from shipping_dimen;

-- DATA EXPLORATION --
describe cust_dimen;
describe market_fact_full;
describe order_dimen;
describe prod_dimen;
describe shipping_dimen;

-- There are tables in this database (customer, market, order, product & shippping) tables.

-- DESCRIBE DATASET --
select 
sum(table_rows) as total_records
from information_schema.tables
where table_schema = 'sql_project' ; 

-- THERE ARE TOTAL 15901 RECORDS PRESENT IN THIS DATABASE -- 

-- DATA CLEANING --

-- Customer table --
select count(*)  from cust_dimen where Customer_Name is null;
select count(*)  from cust_dimen where City is null;
select count(*)  from cust_dimen where State is null;
select count(*)  from cust_dimen where Customer_Segment is null;


-- Market table --
select count(*) from market_fact_full where Prod_id is null ;
select count(*) from market_fact_full where Prod_id is null ;
select count(*) from market_fact_full where Ship_id is null ;
select count(*) from market_fact_full where Cust_id is null ;
select count(*) from market_fact_full where Sales is null ;
select count(*) from market_fact_full where Discount is null ;
select count(*) from market_fact_full where Order_Quantity is null ;
select count(*) from market_fact_full where Profit is null ;
select count(*) from market_fact_full where Shipping_Cost is null ;
select count(*) from market_fact_full where Product_Base_Margin is null ;

-- Order table --
select count(*) from orders_dimen where Order_Number is null ;
select count(*) from orders_dimen where Order_Date is null ;
select count(*) from orders_dimen where Order_Priority is null ;

-- there are no null values in order table.


-- Product table --
select count(*) from prod_dimen where Product_Category is null ;
select count(*) from prod_dimen where Product_Sub_Category is null ;
select count(*) from prod_dimen where Manu_Id is null ;

-- THERE ARE 13 NULL VALUES IN THE MANU_ID COL -- 



-- Shipping table -- 
select count(*) from shipping_dimen where Order_Number is null ;
select count(*) from shipping_dimen where Ship_Mode is null ;
select count(*) from shipping_dimen where Ship_Date is null ;

-- There are no null values in this column.

-- DATA ANALYSIS/ BUSINESS PROBLEMS --


-- 1. Find the total number of customers in the database: -- 
select count(*) as total_records
from cust_dimen;

-- There are  1832 Total records in the database.



-- 2. Find the top 5 States with the highest number of customers:
select count(*) as customer_count, State
from cust_dimen
group by State
order by customer_count desc
limit 5; 

-- Top 5 states with their respective customer count
--  Karnataka - 425 (highest count) 
--  Tamil Nadu - 425
-- Kerela - 302
-- Maharashtra - 286 
-- Delhi - 187


-- 3. Find the average shipping cost by shipping mode:
select s.Ship_id, s.Ship_Mode, round(avg(m.Shipping_Cost), 4) as avg_ship_cost
from shipping_dimen as s
join market_fact_full as m
on s.Ship_id = m.Ship_id
group by s.Ship_id
order by avg_ship_cost;

-- The average cost -
-- REGULAR AIR is 2.7667
-- EXPRESS AIR is 6.1500
-- DELIVERY TRUCK is 36.0900


-- 4. Find the total number of products in the product dimension:
select count(*) as total_products
from prod_dimen;

-- There are total 17 products --

-- 5. Find the total revenue generated by all orders:
select round(sum(Sales),4) as total_revenue
from market_fact_full;

-- So, The total Revenue is 24878.1055.


-- 6.  Find the month with the highest number of orders:
select extract(month from o.Order_Date) as order_month, count(o.Ord_id) as total_order
from orders_dimen as o
group by order_month
order by total_order desc
limit 1;

-- July Month has the highest number of orders 505.

-- 7. Find the top-selling products based on order quantity:
select p.Product_Category, sum(m.Order_Quantity) as total_order_quantity
from prod_dimen as p
join market_fact_full as m
on  p.Prod_id = m.Prod_id
group by p.Product_Category 
order by total_order_quantity desc
limit 1;

-- Top - Selling products is the OFFICE SUPPLIES with the 256 order quantity 


-- 8. Find the shipping modes with the highest total sales:
select s.Ship_Mode, round(sum(m.Sales),4) as total_sales
from shipping_dimen s
join market_fact_full  as m
on s.Ship_id = m.Ship_id
group by  s.Ship_Mode
order by total_sales desc;

-- So there are 3 ship modes  
-- 1. DELIVERY TRUCK = 9008.3280
-- 2. REGULAR AIR = 8623.9075
-- 3. EXPRESS AIR = 7245.8700
-- HIGHEST SALES IS OF THE DELIVERY TRUCK 

-- 9. Find the average order value:
select round(avg(m.Sales),4) as avg_order_value
from market_fact_full  as m;

-- Average order value is 1658.5404

-- 10. Find the top 2 customers based on revenue generated:
select c.Customer_Name,c.Cust_id, round(sum(m.Sales),4) as total_revenue
from cust_dimen as  c
join market_fact_full as m
on c.cust_id = m.cust_id
group by  c.Customer_Name, c.Cust_id
order by  total_revenue desc
limit 2;

-- The top 2 customes who have spent highest revenue are -
-- AARON BERGMAN have the higheset revenue (11615.8300)
-- 	AARON HAWKINS have the second highest revenue (7701.3875)


