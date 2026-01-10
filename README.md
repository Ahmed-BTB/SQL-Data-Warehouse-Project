# Data Warehouse and Analytics Project 🚀

This repository showcases a complete **data warehousing and analytics solution**.  
It is designed as a portfolio project to demonstrate expertise in **data engineering, SQL development, and analytics**.

---

## 🏗️ Data Architecture
The project follows the **Medallion Architecture** with three layers:

- **Bronze Layer**: Raw ERP & CRM CSV data ingested into SQL Server.  
- **Silver Layer**: Cleansing, deduplication, and normalization for consistency.  
- **Gold Layer**: Business-ready star schema optimized for analytical queries and reporting.

![Data Architecture Diagram](docs/Data_Architecture.png)

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
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```

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

