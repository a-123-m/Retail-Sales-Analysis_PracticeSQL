-- ******** SQL RETAIL SALES ANALYSIS SQL PROJECT **********

use p1_retail_db; -- create and use database

-- create and insert data into table by importing data from csv file

select * from dbo.retail_sales;

-- Data cleaning and exploration
EXEC sp_rename 'dbo.retail_sales.quantiy', 'quantity', 'COLUMN'; -- change incorrect spelling of quantity
select COUNT(*) as total_records from dbo.retail_sales; -- total number of records in the dataset
select COUNT(DISTINCT customer_id) as [Unique Customers] from dbo.retail_sales; -- total unique customers in the database
select DISTINCT category from dbo.retail_sales; -- identify all unique product categories in the dataset.

-- NULL value check

select * from dbo.retail_sales WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR 
age IS NULL OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL; -- check any column has NULL

select * from dbo.retail_sales WHERE transactions_id IS NULL AND sale_date IS NULL AND sale_time IS NULL AND customer_id IS NULL AND gender IS NULL AND 
age IS NULL AND category IS NULL AND quantity IS NULL AND price_per_unit IS NULL AND cogs IS NULL AND total_sale IS NULL; -- check if all columns have NULL

-- total nulls in each column
select
COUNT(CASE WHEN age IS NULL THEN 1 END) AS Age_null,
COUNT(CASE WHEN quantity IS NULL THEN 1 END) AS Quantity_null,
COUNT(CASE WHEN price_per_unit IS NULL THEN 1 END) AS price_per_unit_null,
COUNT(CASE WHEN cogs IS NULL THEN 1 END) AS cogs_null,
COUNT(CASE WHEN total_sale IS NULL THEN 1 END) AS totalsale_null
from dbo.retail_sales;

select * from dbo.retail_sales WHERE quantity IS NULL AND price_per_unit IS NULL AND cogs IS NULL AND total_sale IS NULL;
delete from dbo.retail_sales WHERE quantity IS NULL AND price_per_unit IS NULL AND cogs IS NULL AND total_sale IS NULL;

select * from dbo.retail_sales WHERE age IS NULL;
update dbo.retail_sales set age = (select AVG(CAST(age AS INT)) from dbo.retail_sales WHERE age IS NOT NULL) WHERE age IS NULL; -- replace NULL age with average values

select sale_time, CAST(sale_time AS TIME(0)) as updated_time from dbo.retail_sales; 
alter table dbo.retail_sales alter column sale_time TIME(0); -- alter column data type
update dbo.retail_sales set sale_time = CAST(sale_time AS TIME(0)); -- update from TIME(7) to TIME(0) format
select sale_time from dbo.retail_sales;

-- Data Analysis and Findings

-- 1. What were all the sales transactions that occurred on November 5, 2022?
select * from dbo.retail_sales WHERE sale_date = '2022-11-05';

-- 2. Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from dbo.retail_sales WHERE category = 'Clothing' AND quantity >= 4 AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- 3. Calculate the total sales and total orders for each category
select category,SUM(total_sale) as [Total Sales], COUNT(*) as [Total Orders] from dbo.retail_sales
GROUP BY category;

-- 4. Find the average age of customers who purchased items from the 'Beauty' category.
select customer_id,AVG(age) as [Average age] from dbo.retail_sales WHERE category = 'Beauty'
GROUP BY customer_id;

-- 5. Find all transactions where the total_sale is greater than 1000
select * from dbo.retail_sales WHERE total_sale > 1000;

-- 6. Find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category, COUNT(transactions_id) as [Total number of Transactions] from dbo.retail_sales
GROUP BY gender,category
ORDER BY gender,category DESC;

-- 7. Calculate the average sale for each month. Find out best selling month in each year

WITH BestMonth_CTE AS
(
select YEAR(sale_date) as year, DATENAME(MONTH,sale_date) as month, AVG(total_sale) as average_sale, 
DENSE_RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank
from dbo.retail_sales
GROUP BY YEAR(sale_date),DATENAME(MONTH,sale_date)
)

select month,year, average_sale from BestMonth_CTE WHERE rank = 1;

-- 8. Find the top 5 customers based on the highest total sales
WITH top5_cte AS
(
select customer_id,SUM(total_sale) as total_sales, DENSE_RANK() OVER(ORDER BY SUM(total_sale) DESC) as rank from dbo.retail_sales
GROUP BY customer_id
)
select * from top5_cte where rank<=5

-- 9. Find the number of unique customers who purchased items from each category
select category,COUNT(DISTINCT(customer_id)) [Total Unique customers] from dbo.retail_sales
GROUP BY category;

-- 10. Create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
select * from dbo.retail_sales

WITH shift_cte AS
(
select *,
CASE
WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END as shift
from dbo.retail_sales
)
select shift, COUNT(*) as total_orders from shift_cte
GROUP BY shift;

-- 11. Find the customer who spent the most in each month.

WITH Monthlycustomersale_cte AS
(
select customer_id,SUM(total_sale) as total_sales,DATEPART(YEAR,sale_date) as year,DATEPART(MONTH,sale_date) as month,
DENSE_RANK() OVER(PARTITION BY DATEPART(YEAR,sale_date),DATEPART(MONTH,sale_date) ORDER BY SUM(total_sale) DESC) as rn
from dbo.retail_sales
GROUP BY customer_id,DATEPART(YEAR,sale_date),DATEPART(MONTH,sale_date)
)
select customer_id,total_sales,year,month from Monthlycustomersale_cte WHERE rn=1
ORDER BY year,month;

-- 12. Find the top 3 customers (by total sales) within each product category.
WITH top3cte AS
(
select category,customer_id,SUM(total_sale) AS total_sales,
DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(total_sale) DESC) AS rank
from dbo.retail_sales
GROUP BY category, customer_id
)
SELECT category, customer_id,total_sales FROM top3cte
WHERE rank <= 3;

-- 13. Find all customers whose total sales are greater than the average total sales across all customers.

WITH customer_cte AS(
select customer_id, SUM(total_sale) as total_sales
from dbo.retail_sales
GROUP BY customer_id
)
select customer_id,total_sales from customer_cte WHERE total_sales > (select AVG(total_sales) from customer_cte)
ORDER BY total_sales DESC;

-- 14. Find the highest-value transaction in each category.
WITH category_cte AS
(
select transactions_id,category,customer_id,total_sale,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sale DESC) as rn from dbo.retail_sales
)
select transactions_id,category,customer_id,total_sale from category_cte WHERE rn=1

-- 15. Find the top 3 highest-value transactions in each category.
with Transaction_cte AS(
select transactions_id, customer_id, category,total_sale, 
ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sale DESC) as rn from dbo.retail_sales)
select * from Transaction_cte WHERE rn<=3;