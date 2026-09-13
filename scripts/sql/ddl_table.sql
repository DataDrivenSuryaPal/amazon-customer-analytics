/*
====================================================================================
====================================================================================

DDL Scripts : Creates dimension and fact tables

====================================================================================
====================================================================================

Scripts purpose:
	This script creates tables, dropping existing tables if they already exists.
	Run this script to re-define the DDl structure of dimension and fact tables.

====================================================================================
====================================================================================
*/
IF OBJECT_ID('dim_customer','U') IS NOT NULL
	DROP TABLE dim_customer;

CREATE TABLE dim_customer (
	CustomerID NVARCHAR (50),
	CustomerName NVARCHAR (50),
	City NVARCHAR (50),
	State NVARCHAR (50),
	Country NVARCHAR (50)
);

IF OBJECT_ID('dim_product','U') IS NOT NULL
	DROP TABLE dim_product;

CREATE TABLE dim_product (
	ProductID NVARCHAR (50),
	ProductName NVARCHAR (50),
	Category NVARCHAR (50),
	Brand NVARCHAR (50)
);

IF OBJECT_ID('dim_time','U') IS NOT NULL
	DROP TABLE dim_time;

CREATE TABLE dim_time (
	OrderDate DATETIME,
	DateKey INT,
	Year INT,
	Month INT,
	MonthName NVARCHAR (20),
	Quarter INT,
	Day INT
);

IF OBJECT_ID('fact_sale','U') IS NOT NULL
	DROP TABLE fact_sale;

CREATE TABLE fact_sale (
	OrderID NVARCHAR (50),
	DateKey INT,
	CustomerID NVARCHAR (50),
	ProductID NVARCHAR (50),
	SellerID NVARCHAR (50),
	Quantity INT,
	UnitPrice FLOAT,
	Discount FLOAT,
	Tax FLOAT,
	ShippingCost FLOAT,
	GrossAmount FLOAT,
	DiscountedAmount FLOAT,
	NetAmount FLOAT,
	TotalAmount FLOAT,
	PaymentMethode NVARCHAR (50),
	OrderStatus NVARCHAR(50)
);
