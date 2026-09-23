/*
===================================================================================================
==================================================================================

Discount Effectiveness Analysis

==================================================================================
===================================================================================================
Purpose:
 - This report is about the effectiveness of the given discounts.
Highlights:
 1. Gathering essential fields such as Discount, Quantity, Grossamount,
    UnitPrice.
 2. Aggregate values
  - OrderCount
  - TotalQuantity
  _ TotalGrossRevenue
 3. Segrigate the Discount
Calculate valuable KPIs:
 - Average quantity per order,
 - Net revenue after discount,
 - Total discount given
SQL function used:
 - Aggregate function SUM() , Count()
 - Clauses GROUP BY()
===================================================================================================
*/
IF OBJECT_ID ('discount_effectiveness_analysis','V')
	IS NOT NULL
DROP VIEW discount_effectiveness_analysis;
GO
CREATE VIEW discount_effectiveness_analysis AS
SELECT
	CASE WHEN Discount = 0 THEN '0% to no discount'
		 WHEN Discount <= 0.10 THEN '1-10%'
		 WHEN Discount <= 0.20 THEN '11-20%'
		 WHEN Discount <= 0.30 THEN '21-30%'
		 ELSE '31% +'
	END AS DiscountBand,
	COUNT (*) OrderCount,
	SUM (Quantity) AS TotalQuantity,
	ROUND (AVG (Quantity * 1.0),3) AS AvgQtyPerOrder,
	ROUND (SUM (GrossAmount),2) AS TotalGrossRevenue,
	ROUND (SUM (Quantity * UnitPrice * (1-Discount)),2) AS NetRevenueAfterDiscount,
	ROUND (SUM (Quantity * UnitPrice * Discount),2) AS Total_Discount_given
FROM fact_sale
GROUP BY 
	CASE WHEN Discount = 0 THEN '0% to no discount'
		 WHEN Discount <= 0.10 THEN '1-10%'
		 WHEN Discount <= 0.20 THEN '11-20%'
		 WHEN Discount <= 0.30 THEN '21-30%'
		 ELSE '31% +'
	END
