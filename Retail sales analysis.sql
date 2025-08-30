-- Data analysis

-- 1 Write sql query to retrieve all coulmns for sales made on '2022-11-05'.
SELECT * FROM RETAIL_SALES
WHERE SALE_DATE = '2022-11-05';

-- 2 Write sql query to retrieve all transcations where the category is 'clothing' and the quantity sold is more than 3 in the month 
-- november-2022.
select * from retail_sales
where category = 'Clothing'
and 
to_char(sale_date,'YYYY-MM') = '2022-11'
and
quantity >3;

--3 Write a query to calculate the total sales for each category.
select category,sum(total_sales) as total_sales, count(*) as total_orders
from retail_sales
group by category;

-- 4 Write a query to find average age of the customers who purchased items from the'Beauty' category
select ROUND(avg(age),2) as average_age from retail_sales
where category = 'Beauty';

-- 5 Write a query to find all transcation where total_sale is greater than 1000.
SELECT * FROM RETAIL_SALES 
WHERE Total_sales >1000;

-- 6 Write a query to  find all total number of transcation made by each gender in each category
select gender,category ,count(transcation_id)  as total_transcations from retail_sales
group by gender , category
order by gender asc;

-- 7 Write a query to calculate the average sale for each month.find out best selling month in each year.
select year ,month,avg_sale
from(
select 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	avg(total_sales) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) order by avg(total_sales) DESC) AS rank
from retail_sales
GROUP BY 1,2) AS table1
WHERE rank = 1;

-- 8 Write a query to find the top 5 customers based on the highest total_sales.
SELECT customer_id,sum(total_sales) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- 9 Write a query to find the number of unique customers who purchased items from each category.
select count(distinct(customer_id))as unique_customer,category
from retail_sales
group by category;

-- 10 Write a sql query to create each shift and number of orders(example morinig<=12,afternoon between 12&17,evening >17).
With hourly_sale
as
(
select *,
      case
	    when EXTRACT(HOUR FROM SALE_TIME)<12 THEN 'Morning'
		when EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'Afternoon'
		else 'Evening'
	  END AS shift
from retail_sales)
select shift,
       COUNT(*) AS total_orders
from hourly_sale
group by shift;

