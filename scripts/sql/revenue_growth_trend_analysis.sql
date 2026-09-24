/*
=======================================================================================
=======================================================================

Revenue Growth trend analysis

=======================================================================
=======================================================================================
Purpose:
 - This report is about yearly and monthly growth trend.
Highlights:
 1. Gathering the essential fields such as Year, Quarter, Months, TotalAmount
 2. Aggregate Values 
  - TotalRevenue
SQL functions used:
 - Aggregate Function SUM()
 - Windows function LAG() to find the previous record
 - Clause GROUP BY()
KPIs solved:
 - Previous quarter revenue
 - Previous quarter growth percentage
 - Previous month revenue
 - Previous month growth percentage
 - Previous year revenue
 - Previous year growth percentage
=======================================================================================
*/
IF OBJECT_ID ('monthly_yearly_revenue_trend','V')
	IS NOT NULL
DROP VIEW monthly_yearly_revenue_trend;
GO
CREATE VIEW monthly_yearly_revenue_trend AS
WITH monthly AS
(
	SELECT
		t.Year,
		t.Quarter,
		t.Month,
		SUM (s.TotalAmount) AS TotalRevenue
	FROM fact_sale AS s
	INNER JOIN dim_time AS t
		ON s.DateKey = t.DateKey
	GROUP BY t.Year, t.Quarter, t.Month
)
SELECT 
	Year,
	Quarter,
	Month,
	TotalRevenue,
	LAG (TotalRevenue,3) OVER (ORDER BY Year, Month) AS PrevQuarterRevenue,
	ROUND(((TotalRevenue - LAG (TotalRevenue,3) OVER (ORDER BY Year, Month))*100) / 
		NULLIF (LAG (TotalRevenue,3) OVER (ORDER BY Year, Month),0),2) PrevQuarterGrowthPct,
	LAG (TotalRevenue) OVER (ORDER BY Year, Month) AS PrevMonthRevenue,
	ROUND(((TotalRevenue - LAG (TotalRevenue) OVER (ORDER BY Year, Month))*100) / 
		NULLIF (LAG (TotalRevenue) OVER (ORDER BY Year, Month),0),2) PrevMonthGrowthPct,
	LAG (TotalRevenue,12) OVER (ORDER BY Year, Month) AS PrevYearRevenue,
	ROUND(((TotalRevenue - LAG (TotalRevenue,12) OVER (ORDER BY Year, Month))*100) / 
		NULLIF (LAG (TotalRevenue,12) OVER (ORDER BY Year, Month),0),2) AS PrevYearGrowthPct
FROM monthly
