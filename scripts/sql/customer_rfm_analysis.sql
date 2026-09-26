/*
==============================================================================
==============================================================================

Customer recency_frequency_monetary analysis

================================================================================
================================================================================
Purpose:
 -This report shows the customer recency, frequency and monetary data
Highlights:
1. Gather essential fields such as CustomerID, CustomerName, orderdate, OrderID.
2.Segment Customer categories into Best Customer, At risk customer, Lost customer
  and others
3. Aggregates Customer level matrics :
 -Total Spend
 -Total orders
================================================================================
================================================================================
*/
IF OBJECT_ID ('customer_rfm_analysis','v')
    IS NOT NULL
    DROP VIEW customer_rfm_analysis;
GO
CREATE VIEW customer_rfm_analysis AS
WITH rfm_raw AS (
    SELECT
        s.CustomerID,
        c.CustomerName,
        DATEDIFF (Year,MAX(t.OrderDate),'2024-12-31') AS recency,
        COUNT (DISTINCT s.OrderID) AS frequency,
        SUM (s.TotalAmount) AS monetary
    FROM fact_sale AS s
    LEFT JOIN dim_time AS t
        ON s.DateKey = t.DateKey
    LEFT JOIN dim_customer AS c
     ON s.CustomerID = c.CustomerID
    GROUP BY s.CustomerID,
        c.CustomerName),
rfm_score AS (
    SELECT
        CustomerID,
        CustomerName,
        recency,
        frequency,
        monetary,
        NTILE (5) OVER (ORDER BY recency) AS r_score,
        NTILE (5) OVER (ORDER BY frequency) AS f_score,
        NTILE (5) OVER (ORDER BY monetary) AS m_score
    FROM rfm_raw),
rfm_final AS(
    SELECT 
        CustomerID,
        CustomerName,
        recency,
        frequency,
        monetary,
        r_score,
        f_score,
        m_score,
        CASE 
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Best Customers'
            WHEN r_score <= 3 AND f_score >= 3 AND m_score >= 3 THEN 'At-Risk Customers'
            WHEN r_score >= 4 AND f_score <= 4 AND m_score <= 1 THEN 'Promissing Customer'
            WHEN r_score <= 3 AND f_score <= 1 AND m_score <= 1 THEN 'Marginal'
            WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2 THEN 'Need Attention'
            WHEN r_score <= 1 AND f_score <= 1 AND m_score <= 1 THEN 'Lost Customer'
            ELSE 'Other'
        END AS CustomerSegment
    FROM rfm_score)
SELECT
*
FROM rfm_final
