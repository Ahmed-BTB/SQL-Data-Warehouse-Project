# Data Warehouse and Analytics Project 🚀

This repository showcases a complete **data warehousing and analytics solution**.  
It is designed as a portfolio project to demonstrate expertise in **data engineering, SQL development, and analytics**.

---

## 🏗️ Data Architecture
The project follows the **Medallion Architecture** with three layers:

- **Bronze Layer**: Raw ERP & CRM CSV data ingested into SQL Server.  
- **Silver Layer**: Cleansing, deduplication, and normalization for consistency.  
- **Gold Layer**: Business-ready star schema optimized for analytical queries and reporting.
![Data Architecture Diagram](./scripts/bronze/Data%20Architecture.drawio.png)

---

## 📖 Project Overview
- **ETL Pipelines**: Extract, transform, and load ERP & CRM data into SQL Server.  
- **Data Modeling**: Design of fact and dimension tables for efficient querying.  
- **Analytics & Reporting**: SQL-based insights into customer behavior, product performance, and sales trends.  

---

## 🚀 Project Requirements
- Import ERP & CRM CSV files (external datasets referenced in documentation).  
- Cleanse and resolve data quality issues before analysis.  
- Integrate both sources into a unified star schema.  
- Deliver SQL queries that provide actionable business insights.  
- Document the data model for both technical and business stakeholders.  

---

## 🎯 Skills Demonstrated
- SQL Development & Optimization  
- ETL Pipeline Design  
- Data Modeling (Star Schema)  
- Analytical Reporting  

---

## 🛠️ Tools & Resources
- SQL Server Express  
- SQL Server Management Studio (SSMS)  
- GitHub for version control  
- Draw.io for architecture diagrams  
- Notion for project documentation  

---

## 📂 Repository Structure
data-warehouse-project/
│
├── datasets/                           # Raw datasets (ERP and CRM CSV files)
│
├── docs/                               # Documentation & architecture diagrams
│   ├── data_architecture.drawio        # Medallion architecture (Bronze, Silver, Gold)
│   ├── data_flow.drawio                # Data flow diagram
│   ├── data_models.drawio              # Star schema model (fact & dimension tables)
│   ├── data_catalog.md                 # Dataset catalog with field descriptions
│   ├── naming-conventions.md           # Guidelines for table/column naming
│
├── scripts/                            # SQL ETL scripts
│   ├── bronze/                         # Load raw ERP & CRM data
│   ├── silver/                         # Cleanse & transform data
│   ├── gold/                           # Create analytical star schema
│
├── tests/                              # Data quality checks & validation queries
│
├── README.md                           # Project overview & instructions
├── LICENSE                             # MIT License
├── .gitignore                          # Git ignore rules
└── requirements.txt                    # Dependencies (SQL Server, SSMS, etc.)


---

## 📊 Example Insights
High-level SQL analytics include:  
- **Customer Behavior**: Identify top customers by revenue and purchasing frequency.  
- **Product Performance**: Evaluate best-selling products and categories.  
- **Sales Trends**: Track monthly growth and seasonal variations.  

---

## 🌟 About Me
I’m **Ahmed Bettaieb**, passionate about **data science** and currently **building strong expertise in data engineering as the backbone of advanced analytics and machine learning**.  
My goal is to transform **raw data into strategic insights**, preparing for complex analytical and data science challenges.  

---

## ☕ Stay Connected
- [LinkedIn](https://www.linkedin.com/in/ahmed-bettaieb-926b0a356/)  
- [GitHub](https://github.com/Ahmed-BTB)  

---

## 🛡️ License
This project is licensed under the **MIT License**.  
You are free to use, modify, and share this project with proper attribution.

