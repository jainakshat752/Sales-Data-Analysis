-- Create database
CREATE DATABASE IF NOT EXISTS amazon;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),sales
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

# 1 What is the count of distinct cities in the dataset?
SELECT 
	count(DISTINCT city)
FROM sales;

# 2 For each branch, what is the corresponding city?
SELECT 
	DISTINCT city,
    branch
FROM sales;

# 3 What is the count of distinct product lines in the dataset?
SELECT
	count(DISTINCT product_line)
FROM sales;

# 4 Which payment method occurs most frequently? 
SELECT payment
FROM sales
GROUP BY payment;


# 5 Which product line has the highest sales?
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

# 6 How much revenue is generated each month?
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue DESC;

# 7 In which month did the cost of goods sold reach its peak?
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    SUM(cogs) AS total_cogs
FROM sales
GROUP BY year, month
ORDER BY total_cogs DESC
LIMIT 1;

# 8 Which product line generated the highest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

# 9 In which city was the highest revenue recorded?
SELECT city
FROM sales
GROUP BY city
ORDER BY SUM(total) DESC
LIMIT 1;

# 10 Which product line incurred the highest Value Added Tax?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

# 11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

# 12 Identify the branch that exceeded the average number of products sold.
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

# 13 Which product line is most frequently associated with each gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

# 14 Calculate the average rating for each product line.
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

# 15 Count the sales occurrences for each time of day on every weekday.
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

# 16 Identify the customer type contributing the highest revenue.
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;
-- Member contributing the highest revenue

# 17 Determine the city with the highest VAT percentage.
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;
-- Naypyitaw city has highest VAT percentage

# 18 Identify the customer type with the highest VAT payments.
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
-- Member customer type has the highest VAT payments

# 19 What is the count of distinct customer types in the dataset
SELECT
	DISTINCT customer_type
FROM sales;
-- Member and Normal

# 20 What is the count of distinct payment methods in the dataset?
SELECT
	DISTINCT payment
FROM sales;
-- Ewallet , cash ,credit card


# 21 Which customer type occurs most frequently
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;
-- Member

# 22 Identify the customer type with the highest purchase frequency.
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


# 23 Determine the predominant gender among customers.
SELECT
	gender
FROM sales
GROUP BY gender;
-- Female is the predominant gender among customers


# 24 Examine the distribution of genders within each branch.
SELECT branch,
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY branch,gender
ORDER BY branch,gender_cnt DESC;


# 25 Identify the time of day when customers provide the most ratings. 
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


# 26 Determine the time of day with the highest customer ratings for each branch.
SELECT branch,
	time_of_day,
	count(rating) rating_count
FROM sales
GROUP BY branch,time_of_day
ORDER BY rating_count DESC;


# 27 Identify the day of the week with the highest average ratings.
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings

# 28 Determine the day of the week with the highest average ratings for each branch.
SELECT branch, 
	day_name,avg(rating) average_rating
FROM sales
GROUP BY branch,day_name
ORDER BY branch,average_rating DESC;


-- CONCLUSION:-

-- For Product Analysis:

##. The dataset consists of 6 unique product lines, with 'Food and Beverages' generating the highest cumulative sales.

##. Food and Beverages also receives the highest revenue in total, suggesting a high demand for food-related products.

##. It can be inferred that focusing on food and beverage products could potentially lead to higher sales and revenue.

-- For Sales Analysis:

##. 'Naypyitaw' (Branch C) generates the highest revenue among the three cities, indicating a significant market presence or higher purchasing power in that location.

##. 'Member' customers contribute the most to revenue, indicating the importance of loyalty programs or incentives to retain customers.

-- For Customer Analysis:


##. Despite a relatively balanced gender distribution, females contribute slightly more to revenue than males, implying potential opportunities for targeted marketing or product offerings.

##. Afternoon is the time when most ratings are provided across all branches, suggesting that customers are actively engaging with the products or services during this time period.











