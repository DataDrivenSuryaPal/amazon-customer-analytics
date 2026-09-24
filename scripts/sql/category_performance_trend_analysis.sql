/*
==========================================================================================
=============================================================================

Category performance trend analysis

=============================================================================
==========================================================================================
Perpose:
 - This report is about which categories are growing or declining year over year.
Highlight:
 1. Gathering essential fields like Year, ProductID, Category, TotalAmount
 2. Aggregate Value
  - TotalRevenue
SQL function used:
 - Aggregate function SUM()
 - Window value function LAG()
 - Clause GROUP BY()
 - Joining function INNER JOIN
 - CASE WHEN for segmentation
KPIs solved:
 - Year over year growth of categories
==========================================================================================
*/
/*Category performance trends — which categories are growing/declining YoY*/
IF OBJECT_ID ('category_performance_trend','v')
	IS NOT NULL
DROP VIEW category_performance_trend;
GO
CREATE VIEW category_performance_trend AS
WITH category_year AS
(
	SELECT
		t.Year,
		p.ProductID,
		p.Category,
		SUM (s.TotalAmount) AS TotalRevenue
	FROM fact_sale AS s
	INNER JOIN dim_product AS p
		ON s.ProductID = p.ProductID
	INNER JOIN dim_time AS t
		ON s.DateKey = t.DateKey
	GROUP BY t.Year, p.ProductID, p.Category
),
yoy AS
(
SELECT
	*,
	LAG (TotalRevenue) OVER 
		(PARTITION BY Category ORDER BY Year) AS PrevRevenue
FROM category_year
)
SELECT
	*,
	ROUND((TotalRevenue-PrevRevenue)*100 / 
		NULLIF (PrevRevenue,0),2) AS YoyGrowth,
	CASE WHEN PrevRevenue IS NULL THEN 'N/A'
		 WHEN TotalRevenue > PrevRevenue THEN 'Growing'
		 WHEN TotalRevenue < PrevRevenue THEN 'Declining'
		 ELSE 'Flat'
	END AS YoyTrend
FROM yoy
