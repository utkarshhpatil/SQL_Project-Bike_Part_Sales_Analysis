# SQL_Project-Bike_Part_Sales_Analysis
This SQL analysis involves a series of queries performed on a 'sales' table to explore the data, assess data quality, and derive insights. Let's break down each step:

Importing Data: The query uses the COPY command to import data from a CSV file ('Sales.csv') into the 'sales' table. The DELIMITER specifies the column separator, and CSV HEADER indicates that the first row contains column headers.

Showing All Information: The SELECT statement retrieves all rows and columns from the 'sales' table, providing a comprehensive view of the data.

Counting Distinct Order Number: This query calculates the count of unique order numbers in the 'sales' table. It helps determine the number of distinct orders present in the dataset.

Retrieving Column Names and Data Types: The query retrieves the column names and data types for the columns in the 'sales' table using the INFORMATION_SCHEMA.COLUMNS system table. It provides information about the structure and data types of the table's columns.

Checking Constraint Names: This query retrieves the names of constraints applied to the 'sales' table using the information_schema.table_constraints system view. Constraints ensure data integrity, and knowing their names can be helpful for data validation purposes.

Checking Null Values: This query checks for null values in specific columns ('quantity', 'unit_price', 'total', 'payment', 'payment_fee') of the 'sales' table. It helps identify any missing or incomplete data in these columns.

Checking Null Values in Multiple Columns: This query checks for null values in multiple columns simultaneously using the COALESCE() function. It evaluates the 'quantity', 'unit_price', 'total', 'payment', and 'payment_fee' columns together, identifying rows where at least one of these columns has a null value.

Checking Date Range: This query determines the range of dates present in the 'sales' table by retrieving the minimum and maximum dates. It helps understand the time period covered by the sales data.

Checking Distinct Warehouse Locations: This query retrieves the distinct warehouse locations from the 'sales' table, providing insights into the different physical locations where sales transactions occurred.

Checking Distinct Client Types: The query identifies the distinct types of clients present in the 'sales' table. It helps analyze sales patterns based on client segmentation.

Checking Distinct Product Lines: This query retrieves the distinct product lines from the 'sales' table. It provides insights into the variety of products being sold.

Checking Different Types of Payment: This query retrieves the distinct payment methods used in the sales transactions from the 'sales' table. It allows for analysis of payment preferences or trends.

Checking Values Below or Equal to Zero: This query checks for values that are less than or equal to zero in the 'unit_price' and 'total' columns of the 'sales' table. Identifying such values is important for assessing data quality, as negative or zero values may indicate errors or anomalies.

Overall, this SQL analysis aims to explore the 'sales' table, evaluate data quality, and derive valuable insights from the dataset using a variety of queries and functions.

Description analyzes the constraints and columns in the 'sales' table, which is the database used for the analysis. Here is a breakdown of the findings:

Constraints Analysis:

PRIMARY KEY constraint: The 'order_number' column serves as the primary key, ensuring unique identification of each row in the table. This prevents duplicate entries and allows efficient data retrieval.

NOT NULL constraint: The 'date', 'quantity', 'unit_price', 'total', 'payment', and 'payment_fee' columns are designated as NOT NULL, meaning they cannot contain NULL values. 
This constraint ensures that all essential information for each order is present and prevents incomplete or invalid data.

CHECK constraint: The 'positive_value' constraint is applied to the 'unit_price' and 'total' columns, ensuring that their values are greater than 0. This constraint guarantees that all prices and totals entered in the table are positive and valid.

Column Analysis:

'order_number': There are 1000 unique rows, indicating that each order has a distinct order number.

'date': The number of rows is 1000, aligning with the total number of rows in the table. The data spans three months: June 2021, July 2021, and August 2021.

'warehouse': There are 1000 rows, indicating that each order is associated with a specific warehouse. The table includes three warehouse locations: 'West', 'North', and 'Central'.

'client_type': There are 1000 rows, indicating that each order is associated with a client type. The table contains two types of clients: 'Wholesale' and 'Retail'.

'product_line': There are 1000 rows, indicating that each order is associated with a product line. The table includes six types of product lines.

'quantity': The number of rows is as expected, with 1000 entries. This column represents the quantity associated with each order.

'unit_price': The number of rows is as expected, with 1000 entries. Each value in the 'unit_price' column is above 0, indicating positive prices.

'total': The number of rows is as expected, with 1000 entries. Each value in the 'total' column is above 0, indicating positive totals.

'payment': There are three types of payment: Cash, Transfer, and Credit Card. The column contains no NULL values, suggesting that each order has a payment type assigned.

'payment_fee': There are 1000 rows without NULL values. This column likely represents the payment fee associated with each order.

Overall, this analysis provides insights into the constraints applied to the 'sales' table and the characteristics of each column. Understanding these constraints and column attributes is crucial for data validation, quality assurance, and subsequent analysis of the 'sales' data.


1. Query to show the total amount by month, ordered by month in ascending order:
   This query calculates the total amount of sales for each month and presents the results in ascending order of the month. The 'TO_CHAR' function is used to format the 'date' column as the month name ('Month'), and the 'SUM' function calculates the total amount. The results are grouped by month and sorted by the month in ascending order.

2. Query to show the total amount by month and week per month, ordered by month and week:
   This query extends the previous query by including the week number within each month. It calculates the total amount of sales for each month and week, presenting the results in ascending order of both the month and week. The 'TO_CHAR' function is used to format the 'date' column as the month name ('Month') and the week number ('w') within the month.

3. Query to show the average total amount by month and week per month, ordered by month and week:
   This query is similar to the previous one but calculates the average (avg) total amount instead of the sum. The 'ROUND' function is used to round the average amount to two decimal places.

4. Query to show the minimum and maximum total amounts for each month, along with the dates when those totals were achieved:
   This query uses a common table expression (CTE) named 'monthly' to first calculate the minimum and maximum total amounts for each month. The 'ROW_NUMBER' function is used to assign a row number to each month in chronological order. Then, the main query joins the 'sales' table twice, once for the minimum total and once for the maximum total, using the common table expression to match the respective totals. The results are ordered by the row number of the month.

5. Query to retrieve the warehouse, product line, and total amount for sales records matching specific criteria:
   This query retrieves sales records for the "North" warehouse, the "Frame & body" product line, and the month of August. It calculates the total amount of sales for each combination of warehouse and product line. The results are grouped by the warehouse and product line.

6. Query to show which warehouse has billed the most amount and quantity, ordered by the total amount:
   This query calculates the total quantity and total amount of sales for each warehouse. The results are ordered by the total amount in descending order, showing which warehouse has billed the highest amount.

7. Query to show which client type has the most amount and quantity, ordered by the total amount:
   This query calculates the total quantity and total amount of sales for each client type. The results are ordered by the total amount in descending order, showing which client type has the highest amount.

   These queries provide insights into various aspects of the sales data, such as monthly sales trends, warehouse performance, product line performance, and client type performance.
   
   The first query is used to retrieve the warehouse, client type, total quantity, and total amount for sales records. It uses the ROLLUP function to generate subtotals and a grand total. The results are grouped by the warehouse and client type and sorted in ascending order based on the warehouse and client type.

8.  The query retrieves the warehouse, client type, product line, total quantity, and total amount for sales records. It also includes subtotals and a grand total. The results are grouped by warehouse, client type, and product line. The query sorts the results in ascending order based on the warehouse, client type, and product line.

9.  The query retrieves various statistical measures (such as minimum, maximum, average, percentiles, and standard deviation) for the total amount of sales for each month of the year. The results are grouped by month (extracted from the date) and sorted in ascending order based on the month.

10.  The query retrieves all columns from the "sales" table for sales records where the total amount is greater than the average total amount of all sales. The results are sorted in ascending order based on the order numbers.

11.  The query retrieves the total number of sales and the total amount for each day of the week. It considers only sales with a total amount greater than the average total amount of all sales. The results are sorted in descending order based on the number of sales for each day, and if the number of sales is the same, it sorts by the total amount in descending order.

12.  The query retrieves the total number of sales, the percentage of sales (rounded to two decimal places), and the total amount for each day of the week. The results are sorted in descending order based on the number of sales for each day, and if the number of sales is the same, it sorts by the total amount in descending order.

13.  The query retrieves the month, warehouse, client type, product line, and total quantity of sales with the maximum quantity for each month. It only includes records where the total quantity matches the maximum quantity for each respective month.

14.  The query retrieves the month, week, warehouse, client type, product line, and total quantity of sales for each week. It only includes records with the maximum total quantity of sales for each week and month. The results are sorted in ascending order based on the month and week.

15.  The query retrieves the product line and the total quantity of sales for each product line. The results are sorted in descending order based on the total quantity of sales.

16.  The query retrieves the payment type and the total amount of sales for each payment type. The results are sorted in descending order based on the total amount of sales.

Each query serves a specific purpose in analyzing and summarizing sales data from the "sales" table, providing insights into different aspects of the data such as totals, statistics, subtotals, and rankings.







