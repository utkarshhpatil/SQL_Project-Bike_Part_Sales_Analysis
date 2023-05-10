-- Write a query to create a table named 'sales' with necessary data_types.
CREATE TABLE sales (
					order_number VARCHAR(10)    PRIMARY KEY,
					date 		 DATE           NOT NULL,
					warehouse 	 VARCHAR(20),
					client_type  VARCHAR(20),
					product_line VARCHAR(50),
					quantity 	 INT            NOT NULL,
					unit_price   DECIMAL(10,2)  NOT NULL, 
					total 		 NUMERIC(15,2)  NOT NULL,
					payment 	 VARCHAR(20)    NOT NULL,
					payment_fee  DECIMAL(10,2)  NOT NULL,
								 CONSTRAINT positive_value
							     CHECK (unit_price > 0  AND total > 0));
	
--Write a query to import all the data into sales table.
      COPY sales FROM 'F:\Sales.csv'
 DELIMITER ','
CSV HEADER;

--Write a query a to show all information from Sales table.
SELECT * FROM sales;

--Write a query to count distinct order number.
SELECT COUNT(order_number) 
  FROM sales;

--Write a query to retrieve the column names and data types for the sales 
SELECT column_name, data_type
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'sales';

--Checked the names of the constraints in the table sales.
SELECT table_name,
       constraint_type,
       constraint_name
  FROM information_schema.table_constraints
 WHERE table_name = 'sales';

--Write a query to check null values in quantity, unit_price, total, payment, payment_fee.
SELECT *
  FROM sales
 WHERE quantity IS NULL
    OR unit_price IS NULL
    OR total IS NULL
    OR payment IS NULL
    OR payment_fee IS NULL;



-- What a query to check for null values in (in quantity, unit_price, total, payment, payment_fee) multiple columns at once.
SELECT *
  FROM orders
 WHERE COALESCE(quantity, unit_price, total, payment, payment_fee) IS NULL;
 
SELECT MIN(date), MAX(date) 
  FROM sales;-- Checked the range of date

SELECT DISTINCT(warehouse) 
  FROM sales; -- Checked distinct warehouse

SELECT DISTINCT(client_type) 
  FROM sales; -- Checked distinct client type

SELECT DISTINCT(product_line) 
  FROM sales; -- Checked distinct product_line

SELECT DISTINCT payment 
  FROM sales; -- Checked for different types of payment

SELECT unit_price, 
	   total 
  FROM sales
 WHERE unit_price <= 0 
 	OR total <= 0;-- Checked for values below or equal to zero in unit_price and total column.



/*Detail analysis description as per below.
There are a total of 1000 rows and 10 columns in the sales table, which is the database for this analysis.

Constraints analysis:
PRIMARY KEY constraint: The order_number column is designated as the primary key for the table. 
						This ensures that each row in the table is uniquely identified by its order_number value and prevents duplicate entries.
NOT NULL constraint: The date, quantity, unit_price, total, payment, and payment_fee columns cannot contain NULL values. 
					 This ensures that all required information is present for each order and prevents incomplete or invalid data in the table.
CHECK constraint: The positive_value constraint ensures that the unit_price and total columns have values greater than 0. 
				  This ensures that all prices and totals entered into the table are positive and prevents incorrect or invalid data.

Column Analysis:
1. order_number: There are 1000 unique rows.
2. date: The number of rows is 1000, as expected. The table contains data for three months: June 2021, July 2021, and August 2021.
3. warehouse: There are 1000 rows & three locations for warehouses 'West', 'North', and 'Central'.
4. client_type: There are 1000 rows & two types of clients, 'Wholesale' and 'Retail'.
5. product_line: There are 1000 rows & six types of product_line.
6. quantity: As expected, there are 1000 rows.
7. unit_price: As expected, there are 1000 rows. Each value of unit_price is above 0.
8. total: As expected, there are 1000 rows. Each value is above 0.
9. payment: There are three types of payment  Cash, Transfer, and Credit Card. This list contains no null values.
10.payment_fee: There are 1000 rows without null.*/


--Write a query that shows the total amount by month and order by month in ascending order.
  SELECT TO_CHAR(date, 'Month') AS month, 
	     SUM(total) AS total
    FROM sales
GROUP BY month, EXTRACT(Month FROM date)
ORDER BY EXTRACT(Month FROM date);


--Write a query that shows the total amount by month and week per month and order by month and week.
   SELECT TO_CHAR(date, 'Month') AS month, 
	     'Week ' || TO_CHAR(date, 'w') AS week, 
	     SUM(total) AS total
    FROM sales
GROUP BY month, EXTRACT(Month FROM date), week
ORDER BY EXTRACT(Month FROM date), week;


--Write a query that shows the total avg amount by month and week per month and order by month and week.
SELECT TO_CHAR(date, 'Month') AS month, 
'Week ' || TO_CHAR(date, 'w') AS week, 
	   ROUND(AVG(total),2) AS total_avg
  FROM sales
GROUP BY month, EXTRACT(Month FROM date), week
ORDER BY EXTRACT(Month FROM date), week;


--Write a query to show min and max total from each month along with the date when the total was minimum and maximum.
WITH monthly AS(
				SELECT TO_CHAR(date, 'Month') AS month, 
	  				   MIN(total) AS min_total, MAX(total) AS max_total,
	   				   ROW_NUMBER() OVER(ORDER BY EXTRACT(Month FROM date)) AS month_wise
 				  FROM sales
			  GROUP BY month, EXTRACT(Month FROM date))
	 SELECT month, min_total, 
	 		min_s.date AS min_total_date, 
			max_total, max_s.date AS max_date 
	   FROM monthly AS m
			INNER JOIN sales AS min_s 
			ON m.min_total = min_s.total
			INNER JOIN sales AS max_s 
			ON m.max_total = max_s.total
   ORDER BY m.month_wise;

/*Write a query to retrieve the warehouse, product line, and total amount for sales records. 
The results should include only sales for the "North" warehouse, 
the "Frame & body" product line, and the month of August. 
Group the results by the warehouse and product line.*/
  SELECT warehouse, 
	     product_line, SUM(total) AS total_amount
    FROM sales
   WHERE warehouse = 'North' 
     AND product_line = 'Frame & body' 
	 AND EXTRACT(MONTH FROM date) = '8'
GROUP BY warehouse, product_line;

--Write a query that shows which warehouse has billed more amount and quantity. Order in large amounts first.
  SELECT warehouse, 
		 SUM(quantity) AS total_quantity, SUM(total) AS total_amount
    FROM sales
GROUP BY warehouse
ORDER BY total_amount DESC;

--Write a query that shows which client has more amount and quantity. Order in large amounts first.
  SELECT client_type, 
  		 SUM(quantity) AS total_quantity, SUM(total) AS total_amount
	FROM sales
GROUP BY client_type
ORDER BY total_amount DESC;

/*Write a query to retrieve the warehouse, client type, total quantity, and total amount for sales records.
The results should include subtotals and a grand total. Group the results by the warehouse and client type using the ROLLUP function. 
The query should sort the results in ascending order based on the warehouse and client type.*/
  SELECT COALESCE(warehouse, '>>Total') AS warehouse, 
  		 COALESCE(client_type, '>>Total') AS client_type, 
		 SUM(quantity) AS total_quantity, SUM(total) AS total_amount
    FROM sales
GROUP BY ROLLUP(warehouse, client_type)
ORDER BY warehouse, client_type;


/*Write a query to retrieve the warehouse, client type, product line, total quantity, and total amount for sales records.
The results should include subtotals and a grand total. 
Group the results by warehouse, client type, and product line. 
The query should sort the results in ascending order based on the warehouse, client type, 
and product line.*/
  SELECT COALESCE(warehouse, 'Overall Total>>') AS warehouse, 
	  	 COALESCE(client_type, '>>Total>> ') AS client_type, 
	     COALESCE(product_line, 'Total>>') AS product_line, 
		 SUM(quantity) AS total_quantity, SUM(total) AS total_amount
    FROM sales
GROUP BY GROUPING SETS((warehouse, client_type, product_line),(warehouse, product_line),())
ORDER BY warehouse, client_type, product_line;

/*Write a query to retrieve the month, minimum total amount, maximum total amount, average total amount, 
25th percentile total amount, median total amount, 75th percentile total amount, 95th percentile total amount, 
and standard deviation of the total amount for each month of the year. 
Group the results by month, extracted from the date. 
Sort the results in ascending order based on the month.*/
  SELECT TO_CHAR(date, 'Month') AS month,
	     MIN(total) AS minimum,
	     MAX(total) AS maximum,
	     ROUND(AVG(total),2) AS avg_total,
	     PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY total) AS percentile_25,
	     PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY total) AS median_total,
	     PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY total) AS percentile_75,
	     PERCENTILE_DISC(0.95) WITHIN GROUP(ORDER BY total) AS percentile_95,
	     ROUND(STDDEV(total),2) AS std_deviation
  	FROM sales
GROUP BY month, EXTRACT(Month FROM date)
ORDER BY EXTRACT(Month FROM date);

/*The above query is performing statistical analysis on the "total" column of the "sales" table.
Specifically, it is calculating the minimum, maximum, average, 25th percentile, median (50th percentile), 75th percentile, 
95th percentile, and standard deviation of the "total" column for each month.
The results are then grouped and ordered by month. 
This analysis provides insights into the central tendency, variability, and range of the "total" column for each month.

The "minimum" column shows the lowest total for each month, and it ranges from 10.35 to 10.92.
The "maximum" column shows the highest total for each month, and it ranges from 1827.04 to 2546.33.
The "average total" column shows the average value of the "total" column for each month, and it ranges from 271.15 to 316.23.
The "percentile_25" column shows the 25th percentile of the "total" column for each month, and it ranges from 89.80 to 95.52.
The "median_total" column shows the median value (50th percentile) of the "total" column for each month, and it ranges from 169.96 to 183.99.
The "percentile_75" column shows the 75th percentile of the "total" column for each month, and it ranges from 319.72 to 323.88.
The "percentile_95" column shows the 95th percentile of the "total" column for each month, and it ranges from 981.40 to 1213.13.
The "std_deviation" column shows the standard deviation of the "total" column for each month, and it ranges from 301.39 to 399.16.
*/

/*Write a query to retrieve all the columns from the "sales" table for sales records,
where the total amount is greater than the average total amount of all sales. 
Sort the results in ascending order based on the order numbers.*/
  SELECT * 
    FROM sales
   WHERE total > (SELECT AVG(total) 
				    FROM sales)
ORDER BY order_number ASC;

/*Write a query to retrieve the total number of sales and the total amount for each day of the week, 
but only for sales with a total amount greater than the average total amount of all sales. 
Sort the results in descending order based on the number of sales for each day and, 
if the number of sales is the same, sort by the total amount in descending order. 
Query should display the day, the number of days with sales, and the total amount for each day.*/
  SELECT TO_CHAR(date,'Day') AS day, 
         COUNT(date) no_of_days, 
		 SUM(total) AS total
	FROM (
 		  SELECT * 
            FROM sales
           WHERE total > (SELECT AVG(total) 
					        FROM sales)
			    		ORDER BY order_number) AS subquery
GROUP BY day
ORDER BY no_of_days DESC, total DESC;

/*Write a query to retrieve the total number of sales, percentage of sales (rounded to two decimal places), 
and the total amount for each day of the week.
Sort the results in descending order based on the number of sales for each day and, 
if the number of sales is the same, sort by the total amount in descending order. 
Query should display the day, the number of days with sales, the percentage of sales, and the total amount for each day.*/
  SELECT TO_CHAR(date,'Day') AS day, 
	     COUNT(date) no_of_days, 
	     ROUND((100*COUNT(date)::NUMERIC/(SELECT COUNT(date) FROM sales)),2) AS percentage,
	     SUM(total) AS total
    FROM sales
GROUP BY day
ORDER BY no_of_days DESC, total DESC;

  SELECT TO_CHAR(date, 'Month') AS month, 
	     warehouse, 
	     client_type, product_line, 
	     SUM(quantity) AS total_quantity
    FROM sales
   WHERE client_type = 'Retail'
GROUP BY month, warehouse, client_type, product_line
ORDER BY month, warehouse;

/*Write a query to retrieve the month, warehouse, client type, product line, and total quantity of sales
with the maximum quantity for each month from the "sales" table. 
The results should include only the records where the total quantity matches the maximum quantity 
for each respective month.*/
WITH monthly_sale_qty AS (SELECT TO_CHAR(date, 'Month') AS month, 
						  		 warehouse, client_type, product_line, 
						  		 SUM(quantity) AS total_quantity
 							FROM sales
						GROUP BY month, warehouse, client_type, product_line)

	SELECT month, warehouse, client_type, product_line, total_quantity AS max_quantity_sale
	  FROM monthly_sale_qty
     WHERE total_quantity IN (SELECT quantity 
							    FROM (SELECT month, 
									    	 MAX(total_quantity) AS quantity
										FROM monthly_sale_qty
									   GROUP BY month) AS subquery);

/*Write a query to retrieve the month, week, warehouse, client type, product line, and total quantity of sales for each week.
The results should include only the records with the maximum total quantity of sales for each week and 
month. Sort the results in ascending order based on the month and week.*/
WITH total_qty AS (SELECT TO_CHAR(date, 'Month') AS month, 
				   		  CONCAT('Week ',TO_CHAR(date, 'W')) AS week, 
				   		  warehouse, client_type, product_line, 
				   		  SUM(quantity) AS total_quantity
					 FROM sales
					GROUP BY month, week, warehouse, client_type, product_line),
       max_qty AS (SELECT month, week, 
				   		  MAX(total_quantity) 
				     FROM total_qty
   					GROUP BY month, week)

SELECT t.month, t.week, 
	   t.warehouse, t.client_type, t.product_line, 
	   t.total_quantity
  FROM total_qty AS t
	   INNER JOIN max_qty AS m
	   ON t.total_quantity = m.max
          AND t.week = m.week
	          AND t.month = m.month
 ORDER BY month, week;

/*Write a query to retrieve the product line and the total quantity of sales for each product line from 
the "sales" table. 
The results should be sorted in descending order based on the total quantity of sales.*/
  SELECT product_line, 
	     SUM(quantity) AS total_quantity
    FROM sales
GROUP BY product_line
ORDER BY total_quantity DESC;

/*Write a query to retrieve the payment type and the total amount of sales for each payment type from 
the "sales" table. 
The results should be sorted in descending order based on the total amount of sales.*/
  SELECT payment, 
  		 SUM(total) AS total_amount 
	FROM sales
GROUP BY payment
ORDER BY total_amount DESC;
