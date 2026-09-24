/*
=====================================================================================
=======================================================================

Slow & fast moving products analysis

=======================================================================
=====================================================================================
Purpose:
 - This report is about the slow and fast moving products over time trend analysis.
Hilights:
 1. Gathering essential fields like Year, Month, productID, ProductName, Quantity.
 2. Aggregate product level matrics
  - Monthly total quantity sold
  - Total quantity
  - average quantity
SQL function used:
 - Aggregate function SUM(), AVG()
 - Window rank function NTILE()
 - Clause GROUP BY()
 - Joining function INNER JOIN()
 - CASE WHEN for product segments
=====================================================================================
*/
IF OBJECT_ID ('product_quantity_sold_trend','v')
	IS NOT NULL
DROP VIEW product_quantity_sold_trend;
GO
CREATE VIEW product_quantity_sold_trend AS
WITH monthly_quantity_sold AS(
	SELECT
		t.Year,
		t.Month,
		p.ProductID,
		p.ProductName,
		SUM (s.Quantity) AS MonthlyQuantity
	FROM fact_sale AS s
	INNER JOIN dim_product AS p
		ON s.ProductID = p.ProductID
	INNER JOIN dim_time AS t
	ON s.DateKey = t.DateKey
	GROUP BY p.ProductID, p.ProductName,t.Year,t.Month
),
product_summary AS
(
	SELECT 
		ProductID,
		ProductName,
		SUM(MonthlyQuantity) AS TotalQuantity,
		AVG(MonthlyQuantity) AS AverageQuantity
	FROM monthly_quantity_sold
	GROUP BY ProductID, ProductName
),
segmented AS
(
	SELECT
		*,
		NTILE (5) OVER (ORDER BY TotalQuantity DESC) AS Quantile
	FROM product_summary
)
SELECT
	m.Year,
	m.Month,
	s.ProductID,
	s.ProductName,
	s.Quantile,
	CASE WHEN s.Quantile = 1 THEN 'Fast moving'
		 WHEN s.Quantile = 5 THEN 'Slow moving'
		 ELSE 'Medium'
	END AS ProductSegment
FROM segmented AS s
INNER JOIN monthly_quantity_sold AS m
	ON s.ProductID = m.ProductID
