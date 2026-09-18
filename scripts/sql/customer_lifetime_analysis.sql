/*
=========================================================================================
=========================================================================================

Customer lifetime analysis

=========================================================================================
=========================================================================================
Purpose:
 -this report shows lifetime spend of a customer.
Highlights:
1. Gather essential fields such as Customer Name, CustomerID, Totalamount.
2. Segments customer into categories based on spend ranks VIP, Special, Regular 
   and Others.
3. Aggregate Customer level marics:
 -Total Spends
 -Rank based on spend
*/

IF OBJECT_ID ('customer_lifetime_analysis','v')
	IS NOT NULL
	DROP VIEW customer_lifetime_analysis
GO
CREATE VIEW customer_lifetime_analysis AS
WITH customer_spend AS
	(SELECT
		f.CustomerID,
		c.CustomerName,
		SUM (TotalAmount) AS total_spend
	FROM fact_sale AS f
	LEFT JOIN dim_customer AS c
		ON f.CustomerID = c.CustomerID
	GROUP BY f.CustomerID,
			c.CustomerName)
SELECT
	CustomerID,
	CustomerName,
	total_spend,
	RANK () OVER (ORDER BY total_spend DESC) AS spend_rank, 
	NTILE (4) OVER (ORDER BY total_spend DESC) AS quartile_spend,
	NTILE (10) OVER (ORDER BY total_spend DESC) AS decile_spend,
	ROUND (total_spend*100 / SUM(total_spend) OVER (),5) AS spend_percentage,
	CASE WHEN RANK () OVER (ORDER BY total_spend DESC) <= 50 THEN 'VIP customer'
		WHEN RANK () OVER (ORDER BY total_spend DESC) <= 100 THEN 'Special Customer'
		WHEN RANK () OVER (ORDER BY total_spend DESC) <= 500 THEN 'Regular Cuatomer'
		ELSE 'Others'
	END AS customer_segment
FROM customer_spend
