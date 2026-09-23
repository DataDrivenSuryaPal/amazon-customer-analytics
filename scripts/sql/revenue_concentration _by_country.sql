/*
=======================================================================================
===============================================================

Revenue concentration by country & growth opportunity analysis

===============================================================
=======================================================================================
Purpose:
 -This report is about the revenue concentration by each country and also include 
  the growth opportunity 
Highlights:
 1. Gathering essential fields such as CustomerID, Country, Total Amount.
 2 Aggregates Customer level matrics
  -Revenue
  -CustomerCount
Sql function used:
  Aggregate function - SUM
  Window aggregate functions - SUM, AVG
  Window rank function - ROW_NUMBER
  Clauses - GROUP BY ()
  CASE WHEN Statement for growth report
=======================================================================================
*/
IF OBJECT_ID ('revenue_concentration','v')
IS NOT NULL
DROP VIEW revenue_concentration;
GO
CREATE VIEW revenue_concentration AS
WITH country_summary AS (
    SELECT
        c.Country,
        SUM(s.TotalAmount) AS Revenue,
        COUNT(DISTINCT c.CustomerID) AS CustomerCount
    FROM fact_sale AS s
    INNER JOIN dim_customer AS c 
    ON s.CustomerID = c.CustomerID
    GROUP BY c.Country
),

rank_revenue AS (
    SELECT
        Country,
        Revenue,
        CustomerCount,
        Revenue / NULLIF(CustomerCount, 0) AS RevenuePerCustomer,
        SUM(Revenue) OVER () AS TotalRevenue,
        AVG(Revenue) OVER () AS AvgCountryRevenue,
        AVG(CustomerCount) OVER () AS AvgCountryCustomerCount,
        AVG(Revenue * 1.0 / NULLIF(CustomerCount, 0)) OVER () AS AvgRevenuePerCustomer
    FROM country_summary
),

concentration AS (
    SELECT
        *,
        ROUND(Revenue * 100.0 / TotalRevenue, 2) AS RevenueSharePct,
        ROUND(100.0 * SUM(Revenue) OVER (ORDER BY Revenue DESC) / TotalRevenue, 2) AS CumulativeSharePct,
        ROW_NUMBER() OVER (ORDER BY Revenue DESC) AS RevenueRank
    FROM rank_revenue
)

SELECT
    Country,
    Revenue,
    CustomerCount,
    ROUND(RevenuePerCustomer, 2) AS RevenuePerCustomer,
    RevenueSharePct,
    CumulativeSharePct,
    RevenueRank,
    CASE
        WHEN RevenuePerCustomer > AvgRevenuePerCustomer AND CustomerCount < AvgCountryCustomerCount
            THEN 'High-value, low-reach: expand acquisition here'
        WHEN RevenuePerCustomer < AvgRevenuePerCustomer AND CustomerCount > AvgCountryCustomerCount
            THEN 'High-reach, low-value: improve conversion/pricing'
        WHEN Revenue < AvgCountryRevenue AND CustomerCount < AvgCountryCustomerCount
            THEN 'Underdeveloped: untapped market'
        ELSE 'Stable / core market'
    END AS OpportunityFlag
FROM concentration
