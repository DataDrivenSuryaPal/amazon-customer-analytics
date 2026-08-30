# Amazon Customer Analytics

## 📌 Project Overview

This project analyzes Amazon customer order data to extract meaningful business insights using **Python, SQL, and Excel**.

The project follows a complete data analytics workflow, starting with an initial data audit and data cleaning in Python, followed by exploratory and business analysis using SQL, and finally presenting key findings through Excel-based reporting and visualization.

The main objective is to transform raw customer order data into a clean, structured, and analysis-ready dataset and use it to answer relevant business questions related to **customers, orders, products, sellers, sales, discounts, order status, and geographic performance**.

---

## 🎯 Business Objective

The objective of this project is to understand customer and order behavior and identify patterns that can support business decision-making.

The analysis focuses on questions such as:

* How many customers and orders are represented in the dataset?
* What is the overall order performance?
* Which products and categories perform best?
* Which brands and sellers generate the most sales?
* How do sales change over time?
* What percentage of orders are delivered or cancelled?
* How are orders distributed across countries?
* How do discounts affect sales?
* Which customer segments contribute the most to overall sales?

---

## 🛠️ Tools & Technologies

| Tool                 | Purpose                                            |
| -------------------- | -------------------------------------------------- |
| **Python**           | Data auditing, cleaning, feature engineering & EDA |
| **Pandas**           | Data manipulation and transformation               |
| **NumPy**            | Numerical calculations and validation              |
| **SQL**              | Business analysis and querying                     |
| **Excel**            | Reporting, visualization & dashboard               |
| **Jupyter Notebook** | Python analysis environment                        |

---

## 📂 Project Structure

```text
amazon-sales-customer-analytics/
│
├── README.md
│
├── data/
│   ├── raw/
│   │   └── Amazon.csv
│   └── processed/
│       └── Amazon_cleaned.csv
│
├── python/
│   ├── 01_data_profiling.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_sales_product_eda.ipynb
│   └── 04_customer_business_eda.ipynb
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_table_creation.sql
│   ├── 03_data_loading.sql
│   ├── 04_sales_analysis.sql
│   ├── 05_customer_analysis.sql
│   ├── 06_product_analysis.sql
│   ├── 07_category_analysis.sql
│   ├── 08_seller_analysis.sql
│   └── 09_kpi_report.sql
│
├── excel/
│   └── Amazon_Sales_Analytics.xlsx
│
├── reports/
│   ├── data_dictionary.md
│   └── business_insights.md
│
├── images/
│   ├── python_eda.png
│   ├── sql_analysis.png
│   └── excel_dashboard.png

```

> **Note:** Folder and file names can be adjusted as the project develops.

---

# 🔄 Project Workflow

```text
Raw Amazon Dataset
        │
        ▼
Data Audit
(Python)
        │
        ▼
Data Cleaning & Feature Engineering
(Python)
        │
        ▼
Cleaned Dataset
        │
        ├───────────────┐
        ▼               ▼
   SQL Analysis     Excel Analysis
        │               │
        └───────┬───────┘
                ▼
        Business Insights
```

---

# 1️⃣ Data Audit

The first stage of the project focuses on understanding the raw dataset before performing transformations.

The audit examines:

* Dataset structure
* Column names and data types
* Number of orders
* Number of customers
* Number of products
* Number of sellers
* Number of brands
* Number of categories
* Order date range
* Countries represented
* Delivered order percentage
* Cancelled order percentage

The purpose of this stage is to establish a baseline understanding of the dataset before cleaning and analysis.

Notebook:

`notebooks/amazon-customer_dataaudit.ipynb`

---

# 2️⃣ Data Cleaning & Feature Engineering

The second stage prepares the dataset for analysis.

The cleaning process includes:

* Checking for missing values
* Checking for duplicate records
* Checking for invalid values
* Converting `OrderDate` into datetime format
* Validating existing calculations
* Creating additional analytical features
* Performing final data-quality checks

### Feature Engineering

The following derived fields are created:

| Feature            | Description                           |
| ------------------ | ------------------------------------- |
| `GrossAmount`      | Order value before applying discounts |
| `DiscountedAmount` | Discount-related calculated amount    |
| `NetAmount`        | Final order value after discount      |
| `OrderYear`        | Year extracted from the order date    |
| `OrderMonth`       | Month extracted from the order date   |

The final cleaned dataset is saved separately from the raw dataset so that the original source data remains unchanged.

Notebook:

`notebooks/amazon_customer_data_cleaning.ipynb`

---

# 3️⃣ SQL Analysis

After preparing the cleaned dataset, SQL is used to perform business-oriented analysis.

The SQL stage focuses on answering questions related to:

### Customer Analysis

* Number of unique customers
* Customer order activity
* Customer sales contribution
* Top customers by revenue

### Product Analysis

* Top-performing products
* Product sales
* Product quantity sold
* Product performance by category

### Category & Brand Analysis

* Category-level sales
* Brand-level sales
* Top categories
* Top brands

### Seller Analysis

* Seller performance
* Sales contribution by seller
* Top-performing sellers

### Sales Analysis

* Total sales
* Average order value
* Sales trends
* Order volume
* Discount analysis

### Order Status Analysis

* Delivered orders
* Cancelled orders
* Order-status distribution

### Geographic Analysis

* Sales by country
* Orders by country
* Customer distribution by location

---

# 4️⃣ Excel Analysis & Dashboard

Excel is used to transform the analytical results into an easy-to-understand business report/dashboard.

The Excel stage will focus on:

* KPI reporting
* Sales performance
* Customer performance
* Product and category performance
* Order-status analysis
* Geographic analysis
* Time-based trends
* Interactive visualizations

The dashboard is designed to provide a concise overview of the most important business metrics and trends.

---

# 📊 Key Metrics

The project focuses on metrics such as:

* Total Orders
* Total Customers
* Total Sales
* Average Order Value
* Total Quantity Sold
* Delivered Order %
* Cancelled Order %
* Total Products
* Total Sellers
* Total Brands
* Total Categories
* Sales by Country
* Sales by Category
* Sales by Brand

---

# 📈 Expected Business Insights

The completed analysis will help identify:

* High-value customers
* Best-performing products
* Top-performing categories
* Strong and weak brands
* Top sellers
* Sales trends over time
* Order-status patterns
* Geographic sales patterns
* Discount and pricing patterns
* Areas that may require further investigation

---

# 📁 Dataset

The project uses an Amazon customer order dataset containing information related to:

* Orders
* Customers
* Products
* Categories
* Brands
* Sellers
* Quantity
* Unit price
* Discount
* Tax
* Shipping cost
* Total amount
* Payment method
* Order status
* City
* State
* Country

A detailed description of the fields is provided in:

`docs/data_dictionary.md`

---

# 🧹 Data Quality Approach

Data quality is treated as an important part of the analytical workflow.

The project follows these principles:

1. Preserve the original raw dataset.
2. Audit the dataset before transformation.
3. Identify potential data-quality issues.
4. Clean and transform the data systematically.
5. Validate calculated fields.
6. Create documented derived features.
7. Perform final validation.
8. Use the cleaned dataset for downstream analysis.

This approach helps ensure that the business insights are based on a reliable dataset.

---


# 📚 Skills Demonstrated

This project demonstrates practical skills in:

### Python

* Pandas
* NumPy
* Data cleaning
* Data validation
* Feature engineering
* Exploratory analysis

### SQL

* Data querying
* Aggregations
* Filtering
* Grouping
* Ranking
* Business analysis
* Analytical SQL

### Excel

* Data analysis
* KPI development
* Pivot tables
* Charts
* Dashboard creation
* Business reporting

### Data Analytics

* Data-quality assessment
* Business-question formulation
* Data transformation
* Analytical thinking
* Insight generation
* Data storytelling

---

# 👤 About Me

**Surya Pal*

Persuing Data Analyst passionate about transforming raw data into meaningful business insights using **Python, SQL, and Excel**.

### Connect With Me

* **Email:** palsurya.947@gmail.com

---

# ⭐ Project Goal

The goal of this project is not only to analyze an Amazon customer dataset, but to demonstrate a complete **end-to-end data analytics workflow** — from raw data and data quality assessment to cleaning, analysis, visualization, and business insights.
