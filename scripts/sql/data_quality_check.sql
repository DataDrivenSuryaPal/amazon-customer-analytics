/*
===================================================================================

Checking the Data quality

===================================================================================

Purpose :
	This scripts check for Data quality,
	- Null or duplicate values in primary keys
	- Check for unwanted spaces in String columns
	- Check for invalid date
	- Check for Data consistancy
*/

-- First check for the null or duplicate values in the primary key
--dim_Customer
SELECT
	COUNT (*)
FROM dim_customer
GROUP BY CustomerID
HAVING COUNT(*) >1 OR CustomerID IS NULL;

--dim_product
SELECT
	COUNT(*)
FROM dim_product
GROUP BY ProductID
HAVING COUNT(*) > 1 OR ProductID IS NULL;

--dim_time
SELECT
	COUNT(*)
FROM dim_time
GROUP BY DateKey
HAVING COUNT (*) > 1 OR DateKey IS NULL;

--Check for unwanted spaces in the string values
--dim_customer
SELECT
	CustomerName,
	City,
	State,
	Country
FROM dim_customer
WHERE CustomerName != TRIM(CustomerName) AND
	  City != TRIM(City) AND
	  State != TRIM(State) AND
	  COUNTRY != TRIM(Country);

--dim_product
SELECT
	ProductName,
	Category,
	Brand
FROM dim_product
WHERE ProductName != TRIM(ProductName) AND
	  Category != TRIM(Category) AND
	  Brand != TRIM(Brand);

--Check for invalid dates
SELECT
	OrderDate
FROM dim_time
WHERE OrderDate <= 0;
--Check the DateKey
SELECT
	DateKey
FROM dim_time
WHERE DateKey > 20270101
	  OR DateKey < 20191231;
-- Check the data consistancy in TotalAmount column 
SELECT DISTINCT
	Quantity,
	UnitPrice,
	Discount,
	Tax,
	ShippingCost,
	GrossAmount,
	DiscountedAmount,
	NetAmount,
	TotalAmount
FROM fact_sale
WHERE ABS(TotalAmount - ((Quantity * UnitPrice - DiscountedAmount) + Tax + ShippingCost)) > 0.02
	  OR TotalAmount IS NULL
	  OR TotalAmount <= 0;
