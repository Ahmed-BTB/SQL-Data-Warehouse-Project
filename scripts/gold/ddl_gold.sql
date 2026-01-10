/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer delivers the finalized star schema — dimension and fact views
    designed for high-quality analytics and reporting.
 Process:
    - Applies transformations and joins on Silver layer tables.
    - Produces curated, standardized, and business-ready datasets.
    - Ensures the data model aligns with analytical best practices.

Usage:
    - Query these views directly for dashboards, BI tools, or advanced reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
-- dimensions
-- frinedly names
-- Data integration
-- Creating surrogate keys

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

create view gold.dim_customers as
select
	row_number() over (order by cst_id) as customer_key,    -- Surrogate key
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	ci.cst_marital_status as marital_status,
	case when ci.cst_gender != 'N/A' then ci.cst_gender     -- CRM is the master of gender info
		 else coalesce (ca.gen,'N/A') end as gender,		      -- Fallback to ERP data
	isnull(ca.BDATE, '2000-05-30') as birthdate,
	ci.cst_create_date as create_date,
	la.CNTRY as country
FROM SILVER.crm_cust_info ci
left join silver.erp_CUST_AZ12 ca on ci.cst_key = ca.cid
left join silver.erp_LOC_A101 la on ci.cst_key = la.CID

GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
-- dimensions
-- frinedly names
-- creating surrogate primary keys

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

create view gold.dim_products as
select 
	row_number() over (order by pn.prd_start_dt, pn.prd_key) as product_key,    -- Surrogate key
    pn.prd_id as product_id,
    pn.prd_key as product_number,
    pn.prd_nm as product_name,
    pn.cat_id as category_id,
    pc.cat as category,
    pc.subcat as subcategory,
    pc.maintenance,
    pn.prd_cost as cost,
    pn.prd_line as product_line,
    pn.prd_start_dt as product_start_date 
from silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
where prd_end_dt is null   -- Filters out all historical dates

GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
-- Building fact use the dimension's surrogate keys instead of IDS to easily connect facts with dimensions 
-- in star schema the realtion between fact and dimension is one to many (1:N)
-- friendly names
-- joining dimension tables in order to get surrogate keys

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

create view gold.fact_sales as
select 
	sd.sls_ord_num as order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date, 
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_products pr on sd.sls_prd_key =  pr.product_number
left join gold.dim_customers cu on sd.sls_cust_id = cu.customer_id
