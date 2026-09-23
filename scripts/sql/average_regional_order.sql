/*
=======================================================================================
====================================================================

Average regional order value by Payment methode

====================================================================
=======================================================================================
Purpose:
 - This report is about the average regional ordervalue by payment methode.
Highlights:
 1. Gathering essential fields such as PaymentMethode, Country, OrderID,
    TotalAmount
 2. Aggregate values
  - TotalOrder
  - TotalRevenue
SQL function used:
 - Aggregate Functions SUM(), COUNT()
 - Clauses GROUP BY()
=======================================================================================

*/
IF OBJECT_ID ('regional_avg_order', 'V')
	IS NOT NULL
DROP VIEW regional_avg_order;
GO
CREATE VIEW regional_avg_order AS
SELECT
	s.PaymentMethode,
	c.Country,
	COUNT (DISTINCT s.OrderID) AS TotalOrder,
	SUM(TotalAmount) AS TotalRevenue,
	ROUND (SUM(TotalAmount) * 1.0 / 
		COUNT (DISTINCT s.OrderID),2) AS AvgOrderValue
FROM fact_sale AS s
LEFT JOIN dim_customer AS c
	ON s.CustomerID = c.CustomerID
GROUP BY s.PaymentMethode,c.Country
