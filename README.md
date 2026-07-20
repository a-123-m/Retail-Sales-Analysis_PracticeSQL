# Retail-Sales-Analysis_PracticeSQL
A SQL-based data analysis practice project focused on exploring retail sales data through data cleaning, exploratory data analysis (EDA), and business insights generation.<br>
<p align="center">
<img width="1024" height="500" alt="image" src="https://github.com/user-attachments/assets/8d1a3e47-1b07-4776-9112-3a857ce4c098" />
</p>

## 📊 Project Overview
This project analyzes a retail sales dataset using Microsoft SQL server. The objective is to practice data cleaning, exploratory data analysis (EDA) and business analysis by writing SQL queries that uncover various insights about customers, categories, sales etc.

## 🎯 Objectives
<ol>
  <li>Set up a retail sales database: Create and populate a retail sales database with the provided sales data.</li>
  <li>Data Cleaning - find missing values, NULL and do necessary replacements </li>
  <li>Exploratory data analysis - Perform basic EDA to understand the data better</li>
  <li>Business Analysis - Use SQL to answer specific business questions and derive insights from the sales data.</li>
</ol>

## 📁 Project Structure
### 1. Database and Table setup
   <ul>
     <li>Create database named : p1_retail_db</li>
     <li> A table named dbo.retail_stores is created to store sales data in it. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.</li>
   </ul>

### Database Schema
<img width="661" height="371" alt="image" src="https://github.com/user-attachments/assets/d0155baf-6661-4b35-9018-40f9833c7f20" />
<h4>dbo.retail_stores table</h4>
<img src="images/1.png">


### 2. Data cleaning and EDA
<p>Following data cleaning steps and EDA was performed to prepare the dataset for further analysis:</p>
1. Find total number of records in table <br>
<b>select COUNT(*) as total_records from dbo.retail_sales;</b>
<img src="images/2.png">
<br>
2. Find total unique customers<br>
<b>select COUNT(DISTINCT customer_id) as [Unique Customers] from dbo.retail_sales;</b>
<img src="images/3.png">
<br>
3. Identify all unique product categories in the dataset.<br>
<b>select DISTINCT category from dbo.retail_sales;</b>
<img src="images/4.png">
<br>
4. Check if any column has NULL<br>
<b>select * from dbo.retail_sales WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR 
age IS NULL OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;</b>
<img src="images/5.png">
<br>
5. Check if all columns have NULL<br>
<b>select * from dbo.retail_sales WHERE transactions_id IS NULL AND sale_date IS NULL AND sale_time IS NULL AND customer_id IS NULL AND gender IS NULL AND 
age IS NULL AND category IS NULL AND quantity IS NULL AND price_per_unit IS NULL AND cogs IS NULL AND total_sale IS NULL;</b>
<img src="images/6.png">
<br>
6. Find total nulls in each column<br>
<b>select
COUNT(CASE WHEN age IS NULL THEN 1 END) AS Age_null,
COUNT(CASE WHEN quantity IS NULL THEN 1 END) AS Quantity_null,
COUNT(CASE WHEN price_per_unit IS NULL THEN 1 END) AS price_per_unit_null,
COUNT(CASE WHEN cogs IS NULL THEN 1 END) AS cogs_null,
COUNT(CASE WHEN total_sale IS NULL THEN 1 END) AS totalsale_null
from dbo.retail_sales;</b>
<img src="images/7.png">
<br>
7. Find columns that have quantity,price_per_unit,cogs and total_sale all as NULL and remove them<br>
<b>select * from dbo.retail_sales WHERE quantity IS NULL AND price_per_unit IS NULL AND cogs IS NULL AND total_sale IS NULL;<br>
delete from dbo.retail_sales WHERE quantity IS NULL AND price_per_unit IS NULL AND cogs IS NULL AND total_sale IS NULL;</b>
<img src="images/8.png">
<br>
8. Replace NULL age with average age<br>
<b>select * from dbo.retail_sales WHERE age IS NULL;<br>
update dbo.retail_sales set age = (select AVG(CAST(age AS INT)) from dbo.retail_sales WHERE age IS NOT NULL) WHERE age IS NULL;</b><br>
<img width="426" height="407" alt="image" src="https://github.com/user-attachments/assets/cfc425cf-9841-4114-8495-70518915b410" />
<br><br>
9. Update sale time data type from TIME(7) to TIME(0) format<br>
<b>select sale_time, CAST(sale_time AS TIME(0)) as updated_time from dbo.retail_sales; <br>
alter table dbo.retail_sales alter column sale_time TIME(0); <br>
update dbo.retail_sales set sale_time = CAST(sale_time AS TIME(0)); <br>
select sale_time from dbo.retail_sales;</b>
<img src="images/9.png">

### 3. Data analysis using SQL queries
<ol>
  <li>What were all the sales transactions that occurred on November 5, 2022?</li>
  <p>select * from dbo.retail_sales WHERE sale_date = '2022-11-05';</p>
  <img src="images/10.png">
  <br>
  
  <li>Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022</li>
  <p>select * from dbo.retail_sales WHERE category = 'Clothing' AND quantity >= 4 AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';</p>
  <img src="images/11.png">
  <br>
  
  <li>Calculate the total sales and total orders for each category</li>
  <p>select category,SUM(total_sale) as [Total Sales], COUNT(*) as [Total Orders] from dbo.retail_sales
GROUP BY category;</p>
  <img src="images/12.png">
  <br>
  
  <li>Find the average age of customers who purchased items from the 'Beauty' category.</li>
  <p>select AVG(age) as [Average age] from dbo.retail_sales WHERE category = 'Beauty';</p>
<img width="245" height="96" alt="image" src="https://github.com/user-attachments/assets/808fffe2-33de-424f-b73d-739fbc811204" />
<br>
  
<li>Find all transactions where the total_sale is greater than 1000</li>
  <p>select * from dbo.retail_sales WHERE total_sale > 1000;</p>
  <img src="images/14.png">
<br>
  
  <li>Find the total number of transactions (transaction_id) made by each gender in each category.</li>
  <p>select gender,category, COUNT(transactions_id) as [Total number of Transactions] from dbo.retail_sales
GROUP BY gender,category
ORDER BY gender,category DESC;</p>
  <img src="images/15.png">
  <br>

  <li>Calculate the average sale for each month. Find out best selling month in each year</li>
  <p>WITH BestMonth_CTE AS
(
select YEAR(sale_date) as year, DATENAME(MONTH,sale_date) as month, AVG(total_sale) as average_sale, 
DENSE_RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank
from dbo.retail_sales
GROUP BY YEAR(sale_date),DATENAME(MONTH,sale_date)
)

select month,year, average_sale from BestMonth_CTE WHERE rank = 1;</p>
<img width="432" height="137" alt="image" src="https://github.com/user-attachments/assets/df723337-309d-4af0-b181-8caa492ccbf4" />
<br>

<li>Find the top 5 customers based on the highest total sales</li>
  <p>WITH top5_cte AS
(
select customer_id,SUM(total_sale) as total_sales, DENSE_RANK() OVER(ORDER BY SUM(total_sale) DESC) as rank from dbo.retail_sales
GROUP BY customer_id
)
select * from top5_cte where rank<=5</p>
<img width="442" height="210" alt="image" src="https://github.com/user-attachments/assets/777f4683-818e-4206-bd91-e60971a0b310" />
<br>

<li>Find the number of unique customers who purchased items from each category</li>
  <p>select category,COUNT(DISTINCT(customer_id)) [Total Unique customers] from dbo.retail_sales
GROUP BY category;</p>
<img width="501" height="162" alt="image" src="https://github.com/user-attachments/assets/88e7acbb-0c6b-4607-b67b-53a260674391" />
<br>

<li>Create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)</li>
  <p>select * from dbo.retail_sales

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
GROUP BY shift;</p>
<img width="317" height="147" alt="image" src="https://github.com/user-attachments/assets/e82b2ce7-a8a4-4c58-a159-e91e887a7efe" />
<br>

<li>Find the customer who spent the most in each month.</li>
<p>WITH Monthlycustomersale_cte AS
(
select customer_id,SUM(total_sale) as total_sales,DATEPART(YEAR,sale_date) as year,DATEPART(MONTH,sale_date) as month,
DENSE_RANK() OVER(PARTITION BY DATEPART(YEAR,sale_date),DATEPART(MONTH,sale_date) ORDER BY SUM(total_sale) DESC) as rn
from dbo.retail_sales
GROUP BY customer_id,DATEPART(YEAR,sale_date),DATEPART(MONTH,sale_date)
)
select customer_id,total_sales,year,month from Monthlycustomersale_cte WHERE rn=1
ORDER BY year,month;</p>
<img width="691" height="522" alt="image" src="https://github.com/user-attachments/assets/2b5eb86b-849e-4694-955d-9b05fde04bd3" />
<br>

<li>Find the top 3 customers (by total sales) within each product category.</li>
<p>WITH top3cte AS
(
select category,customer_id,SUM(total_sale) AS total_sales,
DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(total_sale) DESC) AS rank
from dbo.retail_sales
GROUP BY category, customer_id
)
SELECT category, customer_id,total_sales FROM top3cte
WHERE rank <= 3;
</p>
<img width="607" height="305" alt="image" src="https://github.com/user-attachments/assets/944ffcb9-2ddb-4f5b-96e5-cddde747e34b" />
<br>

<li>Find all customers whose total sales are greater than the average total sales across all customers.</li>
<p>WITH customer_cte AS(
select customer_id, SUM(total_sale) as total_sales
from dbo.retail_sales
GROUP BY customer_id
)
select customer_id,total_sales from customer_cte WHERE total_sales > (select AVG(total_sales) from customer_cte)
ORDER BY total_sales DESC;</p>
<img width="417" height="332" alt="image" src="https://github.com/user-attachments/assets/c938142c-ca2d-4911-9d6c-f395bcc4c0eb" />
<br>

<li>Find the highest-value transaction in each category.</li>
<p>WITH category_cte AS
(
select transactions_id,category,customer_id,total_sale,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sale DESC) as rn from dbo.retail_sales
)
select transactions_id,category,customer_id,total_sale from category_cte WHERE rn=1</p>
<img width="520" height="147" alt="image" src="https://github.com/user-attachments/assets/1b8ac5c1-c573-477f-a474-b8c8b95c651b" />
<br>

<li>Find the top 3 highest-value transactions in each category.</li>
<p>with Transaction_cte AS(
select transactions_id, customer_id, category,total_sale, 
ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sale DESC) as rn from dbo.retail_sales)
select * from Transaction_cte WHERE rn<=3;</p>
<img width="610" height="302" alt="image" src="https://github.com/user-attachments/assets/a511f8dd-f9d4-47cb-a35b-58d0981e33d6" />
</ol>

## 💡 Insights
★ **Electronics** generated the highest **total sales revenue**, while **Clothing** recorded the highest **number of orders**.

★ Customers purchasing **Beauty** products had an average age of **40 years**.

★ **Clothing** was the most popular category among both **male** and **female** customers, followed by **Electronics** and **Beauty**.

★ **July 2022** was the best-selling month of 2022, with an average sales value of **₹541.34**. In **2023**, **February** was the best-selling month, with an average sales value of **₹535.53**.

★ The **top five customers** by total sales were **Customer IDs 3, 1, 5, 2, and 4**.

★ **Clothing** attracted the highest number of unique customers (**149**), followed by **Electronics (144)** and **Beauty (141)**.

★ The **Evening shift (after 5:00 PM)** recorded the highest order volume with **1,062 orders**, followed by the **Morning** and **Afternoon** shifts.

★ **Top-performing customers by category**
- **Beauty:** Customer IDs **1, 3, 4**
- **Clothing:** Customer IDs **5, 1, 3**
- **Electronics:** Customer IDs **3, 5, 2**

★ **Highest-value transactions by category**
- **Beauty:** Transaction ID **74**
- **Clothing:** Transaction ID **269**
- **Electronics:** Transaction ID **152**

★ **Top three highest-value transactions by category**
- **Beauty:** Transaction IDs **74, 93, 139**
- **Clothing:** Transaction IDs **269, 253, 166**
- **Electronics:** Transaction IDs **152, 155, 157**


<br>
<p>If you found this project helpful, consider giving it a ⭐ on GitHub!<br> Thank you❤️</p>
<div>
  <h2>Connect with Me</h2>
<a href="mailto:aiswarya2000mohan@gmail.com">
  <img src="https://img.shields.io/badge/-Gmail-red?style=for-the-badge&logo=gmail&logoColor=white" alt="Gmail">
</a>
<a href="https://www.linkedin.com/in/aiswarya-mohan-950948221/">
  <img src="https://img.shields.io/badge/-LinkedIn-blue?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
</a>
</div>
 
