USE superstore;
SELECT * FROM vrinda_store;

# Q1)   What percentage of total orders recieved by the different channels?

select channel, count(Channel) as Count, (count(Channel)/(select count(Channel) from vrinda_store) * 100) as percentage
from vrinda_store
group by channel;

# Q2)   Name top 3 customers with highest total value of orders?

SELECT Channel, sum(Sales) as Total_sales
FROM vrinda_store
group by Channel
order by Total_sales desc
limit 3;


# Q3) Find the top 5 category with the highest average sales per day?

SELECT category, round(avg(Sales),2) as Avg_sales
FROM vrinda_store
GROUP BY Category
ORDER BY Avg_sales desc
LIMIT 5;

# Q4) Write a query to find the average sales value for each category, and rank the category by their average sales value?

with table1 as(
SELECT category, round(avg(Sales),2) as Avg_sales
FROM vrinda_store
GROUP BY Category
ORDER BY Avg_sales desc
)
SELECT Avg_sales,
RANK() OVER(ORDER BY Avg_sales desc) AS "RANK"
FROM table1;


# Q5) Give the name of channel through which costumers ordered highest and lowest orders from each city?
with table0 as(
with table1 as(
select ship_city,channel,count(order_id) as "max_order",
rank() over(partition by ship_city order by count(order_id) desc) as "city_rank"
from vrinda_store
group by ship_city,channel
)
select ship_city, channel,max_order
from table1
where city_rank = 1
),
table2 as (
with table3 as(
select ship_city,channel,count(order_id) as "min_order",
rank() over(partition by ship_city order by count(order_id)) as "city_rank"
from vrinda_store
group by ship_city,channel
)
select ship_city, channel,min_order
from table3
where city_rank = 1
)
select * from table0 as t0
inner join table2 as t2
on t0.ship_city = t2.ship_city;


# Q6) What is the most used channel by the senior age category costumers?

SELECT Age_category, Channel, count(Channel) as count
FROM vrinda_store
WHERE Age_category = "senior"
GROUP BY Channel
ORDER BY count desc
limit 1;

# Q7) Which Month has the highest sales? 

SELECT Month, sum(Sales) as Total_sales
FROM vrinda_store
GROUP BY Month
ORDER BY Total_sales Desc
LIMIT 1;


# Q8) Which City has the highest cumulative sales value?

SELECT Ship_city, sum(Sales) as Total_sales
FROM vrinda_store
GROUP BY Ship_city
ORDER BY Total_sales DESC
LIMIT 1;

# Q9) Which city is least contributing to total revenue?

select ship_city, sum(Sales) as Total_sales
from vrinda_store
group by ship_city
order by Total_sales
limit 1;

 # Q10) Which category places the highest number of orders from each state and which segment places the largest individual orders from each state?

with cte1 as(
select ship_state, category, count(order_id) as order_num,
rank() over(partition by ship_state order by count(order_id) desc) as 'state_rank'
from vrinda_store
group by ship_state, category
)
select ship_state,category,order_num
from cte1
where state_rank = 1;


