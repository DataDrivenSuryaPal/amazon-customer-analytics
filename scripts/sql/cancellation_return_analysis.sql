/*
=======================================================================================
=========================================================================

Cancellation Or Return rate analysis

=========================================================================
=======================================================================================
Purpose:
 - This analysis is about the cancellation or return by region & payment methode 
   analysis.
Highlights:
 1. Gathering essential fields such as Country, Category, Paymentmethode,
    orderStatus.
 2. Aggregate values:
  - TotalStatus
SQL function used:
 - Aggregate function SUM()
 - Window aggregate function SUM()
=======================================================================================
*/
IF OBJECT_ID ('cancellation_returned_analysis','v')
IS NOT NULL
DROP VIEW cancellation_returned_analysis;
GO
CREATE VIEW cancellation_returned_analysis AS
WITH total_order_status AS
(
	SELECT
		c.Country,
		p.Category,
		s.PaymentMethode,
		s.OrderStatus,
		COUNT (OrderStatus) AS TotalStatus
	FROM fact_sale AS s
	INNER JOIN dim_customer AS c
		ON s.CustomerID = c.CustomerID
	INNER JOIN dim_product AS p
		ON s.ProductID = p.ProductID
	WHERE OrderStatus IN ('Cancelled','Returned')
	GROUP BY 
			c.Country,
			p.Category,
			s.PaymentMethode,
			s.OrderStatus
)
SELECT
	*,
	SUM (TotalStatus) OVER (PARTITION BY Country) AS RegionOrderStatus,
	SUM (TotalStatus) OVER (PARTITION BY Category) AS CategoryOrderStatus,
	SUM (TotalStatus) OVER (PARTITION BY PaymentMethode) AS PaymentMethodeOrderStatus
FROM total_order_status
