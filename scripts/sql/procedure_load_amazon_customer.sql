/*
====================================================================================================
====================================================================================================

Stored procedure : Load amazon_customer_analysis tables

====================================================================================================
====================================================================================================
Scripts purpose:
	This stored procedure loades data into dimension and fact tables from external csv files.
	It performs the followeing actions:
	- Truncates the tables before loading data.
	- Uses the 'BULK INSERT' command to load data from csv files to the tables.

Parameters:
	None.
	
	this stored procedure does not accept any parameters or return any values.

Usage Example:
	EXEC load_amazon_customer

====================================================================================================
====================================================================================================
*/

CREATE OR ALTER PROCEDURE load_amazon_customer AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,
			@batch_starttime DATETIME, @batch_endtime DATETIME;
	BEGIN TRY
		SET @batch_starttime = GETDATE();
		PRINT '===================================================================================';
		PRINT 'Loading amazon_customer_analysis_tables';
		PRINT '===================================================================================';
		PRINT '-----------------------------------------------------------------------------------';
		PRINT 'Loading dimention tables';
		PRINT '-----------------------------------------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT ' >> Truncating Table : dim_customer';
		TRUNCATE TABLE dim_customer;
		PRINT ' >> Inserting data into dim_customer';
		BULK INSERT dim_customer
		FROM 'D:\DATA ANALYST\Projects\amazon_customer_project\datasets\dim_customer.csv'
		WITH (
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT ' >>Load duration:' + CAST (DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'Seconds';

		SET @start_time = GETDATE();
		PRINT ' >> Truncating Table : dim_product';
		TRUNCATE TABLE dim_product;
		PRINT ' >> Inserting data into dim_product';
		BULK INSERT dim_product
		FROM 'D:\DATA ANALYST\Projects\amazon_customer_project\datasets\dim_product.csv'
		WITH (
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT ' >>Load duration:' + CAST (DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'Seconds';

		SET @start_time = GETDATE();
		PRINT ' >> Truncating Table : dim_time';
		TRUNCATE TABLE dim_time;
		PRINT ' >> Inserting data into dim_product';
		BULK INSERT dim_time
		FROM 'D:\DATA ANALYST\Projects\amazon_customer_project\datasets\dim_time.csv'
		WITH (
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >>Load duration:' + CAST (DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'Seconds';

		PRINT '-----------------------------------------------------------------------------------';
		PRINT 'Loading fact tables';
		PRINT '-----------------------------------------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT ' >> Truncating Table : fact_sale';
		TRUNCATE TABLE fact_sale;
		PRINT ' >> Inserting data into fact_sale';
		BULK INSERT fact_sale
		FROM 'D:\DATA ANALYST\Projects\amazon_customer_project\datasets\fact_sale.csv'
		WITH (
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT ' >>Load duration:' + CAST (DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + 'Seconds';
		SET @batch_endtime = GETDATE()
		PRINT '===================================================================================';
		PRINT 'Loading amazon_customer_analysis table complete';
		PRINT 'Total Load Duration:' + CAST (DATEDIFF(second,@batch_starttime,@batch_endtime)AS NVARCHAR) + 'Seconds';
		PRINT '===================================================================================';
	END TRY
	BEGIN CATCH
		PRINT '===================================================================================';
		PRINT 'ERROR OCCURED DURING LOADING amazon_customer_analysis tables';
		PRINT 'ERROR MASSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '===================================================================================';
	END CATCH
END
