/*
=======================================================================================================
======================================================================================

Create DataBase

=======================================================================================================
======================================================================================

Script Purpose:

 This script create a new database named 'amazon_customer_end_to_end_analysis' after checking if it already exists.
 If the database exists, it is dropped and recreated.

Warning:
 
 Running this script will drop the entire 'amazon_customer_end_to_end_analysis' database if it exists.
 All data in the database will be permanently deleted. proceed with caution and ensure you have proper backups before 
running this script.
*/

USE master ;
GO
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'amazon_customer_end_to_end_analysis')
BEGIN
	ALTER DATABASE amazon_customer_end_to_end_analysis SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE amazon_customer_end_to_end_analysis;
END
GO
USE master;
CREATE DATABASE amazon_customer_end_to_end_analysis;
GO
