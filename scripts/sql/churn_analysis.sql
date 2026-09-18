/*=================================================================================
  =================================================================================

  Churned Customer Report

  =================================================================================
  =================================================================================
  Purpose:
  -This report is about the churned customers
  Highlights:
  1. Gathering essential fields such as Orderdate, CustomerID, TotalAmount.
  2. Aggregate Customer level matrics
   -Total order amount
   -Last order date
   -Average total spend
  3. Calculate valuable KPIs
   -Overall Churn rate
   -Revenue at risk
   -Churn rate by spend decile
  =================================================================================
  =================================================================================
*/
CREATE OR ALTER PROCEDURE churn_customer_report AS
/*=================================================================================
 
 Query 1: Overall Churn rate

 ==================================================================================
*/

    WITH max_date AS
        (SELECT
            MAX(OrderDate) AS max_order_date 
        FROM dim_time ),

    last_order AS
        (SELECT
            s.CustomerID,
            MAX (t.OrderDate) AS last_order_date,
            SUM (s.TotalAmount) AS total_spend
        FROM fact_sale AS s
        LEFT JOIN dim_time AS t
            ON s.DateKey = t.DateKey
        GROUP BY s.CustomerID),

    churn_list AS (
        SELECT
            l.CustomerID,
            l.last_order_date,
            l.total_spend
        FROM max_date AS m
        CROSS JOIN last_order AS l
        WHERE l.last_order_date < DATEADD (MONTH, -10,m.max_order_date))
    --Overall churn rate
    SELECT 
        (SELECT COUNT(*) FROM churn_list) AS churned_customers,
        (SELECT COUNT(*) FROM last_order) AS total_customers,
        (CAST((SELECT COUNT(*) FROM churn_list) AS FLOAT) 
            / (SELECT COUNT(*) FROM last_order) * 100) AS churn_rate_pct;

/*=================================================================================
 
 Query 2: Revenue at risk

 ==================================================================================
*/

    WITH max_date AS
        (SELECT
            MAX(OrderDate) AS max_order_date 
        FROM dim_time ),

    last_order AS
    (SELECT
        s.CustomerID,
            MAX (t.OrderDate) AS last_order_date,
            SUM (s.TotalAmount) AS total_spend
        FROM fact_sale AS s
        LEFT JOIN dim_time AS t
            ON s.DateKey = t.DateKey
        GROUP BY s.CustomerID),

    churn_list AS (
        SELECT
            l.CustomerID,
            l.last_order_date,
            l.total_spend
        FROM max_date AS m
        CROSS JOIN last_order AS l
        WHERE l.last_order_date < DATEADD (MONTH, -10,m.max_order_date))
    --Revenue at risk
    SELECT
        ROUND(SUM(total_spend),2) AS revenue_at_risk,
        ROUND(AVG(total_spend),2) AS avg_spend_per_churned_customer,
        COUNT(*) AS churn_customer_count
    FROM churn_list;

/*=================================================================================
 
 Query 3: Churn rate by spend decile

 ==================================================================================
*/
    WITH max_date AS
    (SELECT
        MAX(OrderDate) AS max_order_date 
    FROM dim_time ),

    last_order AS
        (SELECT
            s.CustomerID,
            MAX (t.OrderDate) AS last_order_date,
            SUM (s.TotalAmount) AS total_spend
        FROM fact_sale AS s
        LEFT JOIN dim_time AS t
            ON s.DateKey = t.DateKey
        GROUP BY s.CustomerID),

    churn_list AS (
        SELECT
            l.CustomerID,
            l.last_order_date,
            l.total_spend
        FROM max_date AS m
        CROSS JOIN last_order AS l
        WHERE l.last_order_date < DATEADD (MONTH, -10,m.max_order_date)),

    decile AS (
        SELECT 
            CustomerID,
            total_spend,
            NTILE(10) OVER (ORDER BY total_spend DESC) AS spend_decile
        FROM last_order
    )
    SELECT 
        d.spend_decile,
        COUNT(*) AS total_customers_in_decile,
        COUNT(c.CustomerID) AS churned_in_decile,
        CAST(COUNT(c.CustomerID) AS FLOAT) / COUNT(*) * 100 AS churn_rate_pct
    FROM decile AS d
    LEFT JOIN churn_list AS c ON d.CustomerID = c.CustomerID
    GROUP BY d.spend_decile
    ORDER BY d.spend_decile;
