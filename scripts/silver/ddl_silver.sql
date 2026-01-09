/*
============================================================
DDL Script: Create silver Tables
============================================================

Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'silver' Tables
============================================================
*/


IF object_id('silver.crm_cust_info', 'U') is not null 
	Drop TABLE silver.crm_cust_info
Create Table silver.crm_cust_info (
	cst_id INT,
	cst_key nvarchar(50),
	cst_firstname NVARCHAR(50),
	cst_lastname nVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gender NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);	

IF object_id('silver.crm_prd_info', 'U') is not null 
	Drop TABLE silver.crm_prd_info
create table silver.crm_prd_info (
	prd_id	INT,
	cat_id nvarchar(50),
	prd_key	nvarchar(50),
	prd_nm	NVARCHAR(50),
	prd_cost NVARCHAR(50),
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF object_id('silver.crm_sales_details', 'U') is not null 
	Drop TABLE silver.crm_sales_details
create table silver.crm_sales_details (
	sls_ord_num	NVARCHAR(50),
	sls_prd_key	nvarchar(50),
	sls_cust_id	int,
	sls_order_dt date,
	sls_ship_dt	date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF object_id('silver.erp_CUST_AZ12', 'U') is not null 
	Drop TABLE silver.erp_CUST_AZ12
create table silver.erp_CUST_AZ12 (
	CID	NVARCHAR(255),
	BDATE DATE,
	GEN nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF object_id('silver.erp_LOC_A101', 'U') is not null 
	Drop TABLE silver.erp_LOC_A101
create table silver.erp_LOC_A101 (
	CID	nvarchar(255),
	CNTRY nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF object_id('silver.erp_PX_CAT_G1V2', 'U') is not null 
	Drop TABLE silver.erp_PX_CAT_G1V2
create table silver.erp_PX_CAT_G1V2 (
	ID nvarchar(50),
	CAT	nvarchar(50),
	SUBCAT nvarchar(50),
	MAINTENANCE char(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
