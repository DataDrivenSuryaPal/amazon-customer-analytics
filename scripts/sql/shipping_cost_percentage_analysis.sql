/*
===========================================================================================
=================================================================================

Shipping cost percentage analysis by country

=================================================================================
===========================================================================================
Purpose:
 - This report is about the shipping cost as a percentage of order value by country
Highlights:
 1. Gathering the essential fields such as Country, ShippingCost, TotalAmount.
 2. Aggregate the values
  - TotalShippingCost
  - TotalRevenue
SQL function used:
 - Aggregate function SUM()
 - Clause GROUP BY()
===========================================================================================
*/
IF OBJECT_ID ('shipping_cost_pct_analysis','v')
IS NOT NULL
DROP VIEW shipping_cost_pct_analysis;
GO
CREATE VIEW shipping_cost_pct_analysis AS
WITH total_cost AS
(
	SELECT
		c.Country,
		SUM (s.ShippingCost) AS TotalShippingCost,
		SUM (s.TotalAmount) AS TotalRevenue
	FROM fact_sale AS s
	INNER JOIN dim_customer AS c
		ON s.CustomerID = c.CustomerID
	GROUP BY c.Country
)
SELECT
	*,
	ROUND((TotalShippingCost * 100 / TotalRevenue),2) AS ShippingCostPercentage
FROM total_cost
