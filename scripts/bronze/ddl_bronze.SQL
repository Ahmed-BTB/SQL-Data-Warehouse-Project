/*
============================================================
DDL Script: Create Bronze Tables
============================================================

Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
============================================================
*/


IF object_id('Bronze.crm_cust_info', 'U') is not null 
	Drop TABLE Bronze.crm_cust_info
Create Table Bronze.crm_cust_info (
	cst_id INT,
	cst_key nvarchar(50),
	cst_firstname NVARCHAR(50),
	cst_lastname nVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gender NVARCHAR(50),
	cst_create_date DATE
);	

IF object_id('Bronze.crm_prd_info', 'U') is not null 
	Drop TABLE Bronze.crm_prd_info
create table Bronze.crm_prd_info (
	prd_id	INT,
	prd_key	nvarchar(50),
	prd_nm	NVARCHAR(50),
	prd_cost NVARCHAR(50),
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);

IF object_id('Bronze.crm_sales_details', 'U') is not null 
	Drop TABLE Bronze.crm_sales_details
create table Bronze.crm_sales_details (
	sls_ord_num	NVARCHAR(50),
	sls_prd_key	nvarchar(50),
	sls_cust_id	int,
	sls_order_dt bigint,
	sls_ship_dt	bigint,
	sls_due_dt bigint,
	sls_sales int,
	sls_quantity int,
	sls_price int
);

IF object_id('Bronze.erp_CUST_AZ12', 'U') is not null 
	Drop TABLE Bronze.erp_CUST_AZ12
create table bronze.erp_CUST_AZ12 (
	CID	NVARCHAR(255),
	BDATE DATE,
	GEN nvarchar(50)
);

IF object_id('Bronze.erp_LOC_A101', 'U') is not null 
	Drop TABLE Bronze.erp_LOC_A101
create table bronze.erp_LOC_A101 (
	CID	nvarchar(255),
	CNTRY nvarchar(50)
);

IF object_id('Bronze.erp_PX_CAT_G1V2', 'U') is not null 
	Drop TABLE Bronze.erp_PX_CAT_G1V2
create table Bronze.erp_PX_CAT_G1V2 (
	ID nvarchar(50),
	CAT	nvarchar(50),
	SUBCAT nvarchar(50),
	MAINTENANCE char(50)
);
