-- Carate Database
CREATE DATABASE salesdatawalmart;

-- Create Table
CREATE TABLE sales (
         invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
         branch VARCHAR(5) NOT NULL,
         city  VARCHAR(30) NOT NULL,
         customer_type VARCHAR(30) NOT NULL,
         gender VARCHAR(10) NOT NULL,
         product_line VARCHAR(100) NOT NULL,
         unit_price DECIMAL(10, 2) NOT NULL,
         quntity INT NOT NULL,
         VAT FLOAT(6, 4) NOT NULL,
         total DECIMAL(12, 4) NOT NULL,
         date DATETIME NOT NULL,
         time TIME NOT NULL,
         payment_method VARCHAR(15) NOT NULL,
         cogs DECIMAL(10, 2) NOT NULL,
         gross_margin_pct FLOAT(11, 9),
         gross_income DECIMAL(12, 4) NOT NULL,
         rating FLOAT(2,1)
);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Feature Engineering-- 
-- Add new  column time_of_day--

SELECT time FROM sales;

SELECT time,
 (CASE
       WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
       WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
       ELSE "Evening"
       END) 
       time_of_day
       FROM sales;
       
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- To Update the Table turn off the safe mode for update
SET SQL_SAFE_UPDATES=0;

UPDATE sales SET time_of_day = (
CASE
       WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
       WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
       ELSE "Evening"
       END
);  

-- Add column day_name--

SELECT date FROM sales;
SELECT date,
dayname(date) AS day_name FROM sales; 

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales SET day_name = DAYNAME(date);

-- Add column month_name--

SELECT date,
monthname(date) AS month_name FROM sales; 

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales SET month_name = monthname(date);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------GENERIC QUESTIONS------------------------------------------------------

-- How many unique cities does the data have?
SELECT distinct city FROM sales;

-- In which city is each branch?
SELECT distinct city ,branch FROM sales;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------PRODUCT QUESTIONS------------------------------------------------------

-- How many unique product lines does the data have?
SELECT distinct product_line FROM sales;

-- What is the most selling product line
SELECT SUM(quntity) as qty, product_line FROM sales GROUP BY product_line ORDER BY qty DESC;
-- Most selling product line is Electronic accessories

-- What is the total revenue by month
SELECT month_name as month, SUM(total) as total_revenue FROM sales GROUP BY month_name ORDER BY total_revenue DESC;
-- January month expereinced max revenue followed by march & february

-- Which month had the largest COGS?
SELECT month_name as month, SUM(cogs) as cogs FROM sales GROUP BY month_name ORDER BY cogs DESC;
-- January month expereinced max cogs followed by march & february

-- Which product line had the largest revenue?
SELECT product_line, SUM(total) as total_revenue FROM sales GROUP BY product_line ORDER BY total_revenue DESC LIMIT 5;
-- Food & beverages had the largest revenue

-- Which is the city with the largest revenue?
SELECT city,branch, SUM(total) as total_revenue FROM sales GROUP BY city,branch ORDER BY total_revenue DESC;
-- Naypyitaw collected the largest revenue

-- Which product line had the largest VAT?
SELECT product_line, AVG(VAT) as AVG_VAT FROM sales GROUP BY product_line ORDER BY AVG_VAT DESC LIMIT 1;
-- Product line "Home & lifestyle" had the largest VAT

-- Which branch sold more products than average product sold?
SELECT AVG(quntity) FROM sales;
SELECT branch, AVG(quntity), SUM(quntity) as qty FROM sales GROUP BY branch HAVING SUM(quntity) > (SELECT AVG(quntity) FROM sales);
-- Branch "A" sold more products than average product sold

-- What is the most common product line by gender
SELECT gender,product_line, COUNT(gender) as total_cnt FROM sales GROUP BY gender,product_line ORDER BY total_cnt DESC LIMIT 5;
-- Common product line by gender is Fashion accessories

-- What is the average rating of each product line
SELECT AVG(rating) as avg_rating, product_line FROM sales GROUP BY product_line ORDER BY avg_rating DESC;

SELECT ROUND(AVG(rating), 2) as avg_rating, product_line FROM sales GROUP BY product_line ORDER BY avg_rating DESC;


-- -----------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------CUSTOMER QUESTIONS------------------------------------------------------

-- How many unique customer types does the data have?
SELECT  DISTINCT customer_type FROM sales;

SELECT customer_type,COUNT(customer_type) as CNT FROM sales GROUP BY customer_type;

-- How many unique payment methods does the data have?

SELECT payment_method, COUNT(payment_method) as CNT FROM sales GROUP BY payment_method;
SELECT payment_method, COUNT(*) as CNT FROM sales GROUP BY payment_method;
-- total 3 unique payment methods are there in the data


-- What is the most common customer type?
SELECT customer_type, COUNT(*) as count FROM sales GROUP BY customer_type ORDER BY count DESC;
-- common customer type is "Member"

-- Which customer type buys the most?
SELECT customer_type, SUM(quntity), AVG(quntity) as qnt FROM sales GROUP BY customer_type ORDER BY qnt DESC ;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) as gender_cnt FROM sales GROUP BY gender  ORDER BY gender_cnt;

-- What is the gender distribution per branch?
SELECT gender, COUNT(*) as gender_cnt,branch  FROM sales WHERE branch = "C" GROUP BY gender  ORDER BY gender_cnt DESC;
SELECT gender, COUNT(*) as gender_cnt,branch FROM sales WHERE branch = "B" GROUP BY gender  ORDER BY gender_cnt DESC;
SELECT gender, COUNT(*) as gender_cnt,branch FROM sales WHERE branch = "A" GROUP BY gender  ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) as AVG_Rating FROM sales GROUP BY time_of_day ORDER BY AVG_Rating DESC;
-- Ans-Afternoon

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, AVG(rating) as AVG_Rating, branch FROM sales WHERE branch = "A" GROUP BY time_of_day ORDER BY AVG_Rating DESC;
SELECT time_of_day, AVG(rating) as AVG_Rating, branch FROM sales WHERE branch = "B" GROUP BY time_of_day ORDER BY AVG_Rating DESC;
SELECT time_of_day, AVG(rating) as AVG_Rating, branch FROM sales WHERE branch = "C" GROUP BY time_of_day ORDER BY AVG_Rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) as AVG_Rating FROM sales GROUP BY day_name ORDER BY AVG_Rating DESC;
-- Ans- Monday

-- Which day of the week has the best average ratings per branch?
SELECT day_name, AVG(rating) as AVG_Rating,branch FROM sales WHERE branch = "A" GROUP BY day_name ORDER BY AVG_Rating DESC;
SELECT day_name, AVG(rating) as AVG_Rating,branch FROM sales WHERE branch = "B" GROUP BY day_name ORDER BY AVG_Rating DESC;
SELECT day_name, AVG(rating) as AVG_Rating,branch FROM sales WHERE branch = "C" GROUP BY day_name ORDER BY AVG_Rating DESC;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------SALES QUESTIONS--------------------------------------------------------


-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) as  total_sales FROM sales WHERE day_name = "Saturday" GROUP BY time_of_day ORDER BY  total_sales DESC;
-- All weekdays shown maximum number of sales made in evening Except wednesday & Friday. For those 2 days maximum sales observed in afternoon

-- Which of the customer types brings the most revenue?
SELECT customer_type, COUNT(total) as total_revenue FROM sales GROUP BY customer_type ORDER BY total_revenue DESC;
-- Memeber of  the walmart brought more revenue than Normal type customer.alter

-- Which city has the largest tax/VAT percent?
SELECT city, ROUND(AVG(VAT), 2) as AVG_VAT FROM sales GROUP BY city ORDER BY AVG_VAT DESC;
-- City "Naypyitaw" has the largest tax/VAT percent

-- Which customer type pays the most in VAT?
SELECT customer_type, ROUND(AVG(VAT), 2) as AVG_VAT FROM sales GROUP BY customer_type ORDER BY AVG_VAT DESC;
-- Member of walmart pays more VAT than Normal customer type







