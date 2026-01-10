/*
===============================================================================
Silver Layer Data Quality Audit
===============================================================================

Overview:
    This script conducts a series of data integrity checks across the 'silver' schema
    to ensure reliability, cleanliness, and consistency of the transformed datasets.

Validation Scope:
    - Detection of null or duplicate primary key values.
    - Identification of leading/trailing spaces in textual fields.
    - Enforcement of standardized formats and consistent data representations.
    - Verification of logical date sequences and valid temporal ranges.
    - Cross-field consistency checks to validate relational coherence.

Execution Notes:
    - Run this audit immediately after loading data into the Silver Layer.
    - Investigate and resolve any anomalies flagged during the validation process.
===============================================================================
*/

-- ============================================================
-- Checking 'silver.crm_cust_info'
-- ============================================================

-- Checking for nulls or duplicates in Primary Key
-- Expectation: No Result
select
count(*),
cst_id
from bronze.crm_cust_info  
group by cst_id
having count(*) > 1 or cst_id is null


-- focusing on one customer
select * from silver.crm_cust_info where cst_id = 29466

--Detecting the unwanted data
-- Expectation: No result
select *
from (
select 
*,
row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
from silver.crm_cust_info
) t 
where flag_last != 1 

-- Checking for unwanted spaces
-- Expectation: No Result
select * from silver.crm_cust_info 
where cst_firstname != trim(cst_firstname)
or cst_lastname != trim (cst_lastname)

-- Data Standardation & Consistency
select distinct cst_gender from silver.crm_cust_info
select distinct cst_marital_status from silver.crm_cust_info

select * from silver.crm_cust_info


-- ============================================================
-- Checking 'silver.crm_prd_info'
-- ============================================================

-- Checking for Duplicates or nulls
-- Expectation No result
select
count(*),
prd_id
from silver.crm_prd_info 
group by prd_id
having count(*) > 1 or prd_id is null

-- Checking for unwanted spaces 
-- Expectation: No result
select prd_nm 
from bronze.crm_prd_info
where prd_nm != trim(prd_nm)

-- Checking for nulls or unwanted numbers
-- Expectation: No Result
select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null

-- Data Standardization & Consistency
select distinct
prd_line
from silver.crm_prd_info

-- Check for invalid Date orders
select * from bronze.crm_prd_info
where prd_end_dt < prd_start_dt


-- ============================================================
-- Checking 'silver.crm_sales_details'
-- ============================================================

-- Checking for Invalid Dates
select 
sls_order_dt
from silver.crm_sales_details
where sls_order_dt <=0 or len(sls_order_dt) != 8
or sls_order_dt > 20500101
or sls_order_dt < 19000101

-- Checking for invalid order dates
select *
from bronze.crm_sales_details 
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt or sls_ship_dt > sls_due_dt 

-- Buisiness rule ∑Sales = Quantity * Price
-- Negative, Zeros, Nulls are not allowed

-- #1 Solution: Data issues will be fixed in the source system
-- #2 Solution: Data issues has to be fixed in the data warehouse

-- Rules: 
-- if Sales is negative, zero or null, derive it using quantity and price 
-- if price is zero or null, calculate it using Sales and quantity 
-- if price is negative then convert it to a positive value

select distinct
sls_sales as sls_sales,
sls_quantity,
sls_price as old_sls_price,
case 
	when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price) 
	then abs(sls_price) * sls_quantity 
	else sls_sales
end as sls_sales,
case 
	when sls_price is null or sls_price <=0 
	then sls_sales / nullif(sls_quantity, 0)
	else sls_price 
end as sls_price
from silver.crm_sales_details 
where sls_sales != sls_quantity * sls_price
or sls_quantity is null or sls_price is null or sls_sales is null
or sls_quantity <=0 or sls_price <=0 or sls_sales <=0 


-- ============================================================
-- Checking 'silver.erp_CUST_AZ12'
-- ============================================================

-- Checking for invalid or old cst_key(cid)
-- Expectation: no result for silver layer
select 
cid
from silver.erp_CUST_AZ12
where cid like 'NAS%'

-- Identifying out of range Birthdates
-- Expectation: no result for silver layer
select 
bdate,
case when bdate > GETDATE() then null
	 when bdate < '1926-01-01' then null
	 else bdate
END bdate
from silver.erp_CUST_AZ12
where bdate > GETDATE() or bdate < '1926-01-01'

-- Data Standardization & Consistency
-- Expectation: No result for silver layer
select *
from(
select gen as old_gen,
case when trim(upper(gen)) = 'M' then 'Male'
	 when trim(upper(gen)) = 'F' then 'Female'
	 when trim(upper(gen)) = 'Male' then gen
	 when trim(upper(gen)) = 'Female' then gen
	 else 'N/A'
	 End GEN
from silver.erp_CUST_AZ12 ) t where old_gen != GEN


-- ============================================================
-- Checking 'silver.erp_LOC_A101'
-- ============================================================

-- Expectation: No Result
select 
cid,
cntry
from silver.erp_LOC_A101 where cid not in (select cst_key from silver.crm_cust_info)

-- Data Standardization & Consistency
select* 
from (select
cntry as old_country,
case when trim(cntry) = 'DE' then 'Germany'
	 when trim(cntry) in('USA','US') then 'United States'
	 when trim(cntry) = '' or cntry is null then 'N/A'
	 else trim(cntry)
end CNTRY
from silver.erp_LOC_A101 ) t
where old_country != cntry


-- ============================================================
-- Checking 'silver.erp_PX_CAT_G1V2'
-- ============================================================

-- check for unwanted spaces
select * from bronze.erp_PX_CAT_G1V2 where trim(maintenance) != maintenance

-- Data Standardization & Consistency
select distinct
MAINTENANCE
from bronze.erp_PX_CAT_G1V2 
