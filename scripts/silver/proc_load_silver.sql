/*
===============================================================================
Stored Procedure: Load Silver Layer (Source -> Bronze)
===============================================================================
This stored procedure performs the ETL (Extract,Transform,Load) process to populate the 'silver' schema tables from the 'bronze' schema
    It applies:
        - Data cleansing
        - Standardization
        - Deduplication
        - Business rule validation
	Actions performed:
		- Truncate Silver Tables
		- Insert transformed and cleansed data from bronze into silver tables
Parameters:
	None.
	This stored procedure does not accept any parameters or return any values.
Usage Example:
	EXEC Silver.load_silver
*/

create or alter procedure silver.load_silver as
BEGIN
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime
	begin try
		set @start_time = getdate();

		print '=========================================='
		print 'Loading Silver Layer'
		print '=========================================='

		print '-------------------------------------------'
		print 'Loading CRM Tables'
		print '-------------------------------------------'

		PRINT '>> Truncating Table: silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info

		PRINT '>> Inserting Data Into: silver.crm_cust_info'
		insert into silver.crm_cust_info (cst_id, 
		cst_key, 
		cst_firstname, 
		cst_lastname, 
		cst_marital_status, 
		cst_gender, 
		cst_create_date
		)
		select 
		cst_id,
		cst_key,
      
      -- Remove leading/trailing spaces for data consistency
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
      -- Standardize marital status codes to descriptive values
		case when upper(trim(cst_marital_status)) = 'S' then 'Single' 
			 when upper(trim(cst_marital_status)) = 'M' then 'Married'
			 else 'N/A'
			 end cst_marital_status,
      
      -- Standardize gender values
		case when upper(trim(cst_gender)) = 'F' then 'Female' 
			 when upper(trim(cst_gender)) = 'M' then 'Married'
			 else 'N/A'
			 end cst_gender,
      
      -- Preserve record creation date for auditing and lineage
		cst_create_date
		from (
      -- Deduplication logic:
      -- Assign a row number per customer ID
      -- Latest record is identified using the most recent create date
		select 
  		*,
  		row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info
		) t 
		where 
          -- Keep only the most recent record per customer
      flag_last = 1 
          -- Exclude invalid records without a customer ID
      and cst_id is not null


		PRINT '>> Truncating Table: silver.crm_prd_info'
			truncate table silver.crm_prd_info

		PRINT '>> Inserting Data Into: silver.crm_prd_info'
			insert into silver.crm_prd_info (prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
			select 
			prd_id,
			replace(substring(prd_key,1,5), '-', '_') as cat_id, -- Extracting Category ID
			substring(prd_key,7,len(prd_key)) as prd_key, -- Extracting product key
			prd_nm,
			isnull(prd_cost,0) as prd_cost,
			case upper(trim(prd_line)) 
				 when 'M' then 'Mountain'
				 when 'R' then 'Road'
				 when 'S' then 'Orher Sales'
				 when 'T' then 'Touring'
				 else 'N/A'
			end as prd_line, -- Map product line codes to descriptive values
			prd_start_dt,
			dateadd(day,-1,lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)) -- Calcule end date as one day before the next start  day 	
			as prd_end_dt
			from bronze.crm_prd_info

		PRINT '>> Truncating Table: silver.crm_sales_details'
			truncate table silver.crm_sales_details

		PRINT '>> Inserting Data Into: silver.crm_sales_details'
			insert into silver.crm_sales_details(sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price)
			select 
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				case when sls_order_dt = 0 or len(sls_order_dt) != 8 then null   --replacing invalid dates with null 
					else cast(cast(sls_order_dt as nvarchar) as date)
				end as sls_order_dt,
				case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null   --replacing invalid dates with null 
					else cast(cast(sls_ship_dt as nvarchar) as date)
				end as sls_ship_dt,
				case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null   --replacing invalid dates with null 
					else cast(cast(sls_due_dt as nvarchar) as date)
				end as sls_due_dt,
				case																	 
				when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)  
				then abs(sls_price) * sls_quantity 
				else sls_sales
			end as sls_sales,	-- Recalculating sales if original value is missing or incorrect
				sls_quantity,
				case
				when sls_price is null or sls_price <=0 
				then sls_sales / nullif(sls_quantity, 0)
				else sls_price 	-- Deriving price if original value is missing or incorrect
			end as sls_price
				from bronze.crm_sales_details


		print '-------------------------------------------'
		print 'Loading ERP Tables'
		print '-------------------------------------------'

		PRINT '>> Truncating Table: silver.erp_CUST_AZ12'
			truncate table silver.erp_cust_az12

		PRINT '>> Inserting Data Into: silver.erp_CUST_AZ12'
			insert into silver.erp_CUST_AZ12 (CID, BDATE, GEN)
			select 
			case when cid like 'NAS%' then substring(cid,4,len(cid))		 
				 else cid 
			end As cid,														-- Replacing the old cid (cust_key) that start with NAS
			case when bdate > GETDATE() then null
				 when bdate < '1926-01-01' then null
				 else bdate
			END bdate,														-- Replacing out of range Birthdates with Null Values
			case when trim(upper(gen)) in ('M','Male') then 'Male'
				 when trim(upper(gen)) in ('F','Female') then 'Female'
				 else 'N/A'													-- Data Standardization & Consistency
				 End GEN
			from bronze.erp_CUST_AZ12


		PRINT '>> Truncating Table: silver.erp_LOC_A101'
			truncate table silver.erp_loc_a101

		PRINT '>> Inserting Data Into: silver.erp_LOC_A101'
			insert into silver.erp_LOC_A101 (cid,cntry)
			select
          -- Normalize customer identifier:
          -- Remove hyphens to ensure consistency with other ERP/CRM keys
			replace (cid,'-','') CID ,
      
    -- Standardize country values:
    -- Convert country codes to full country names
    -- Handle missing or empty values explicitly
			case when trim(cntry) = 'DE' then 'Germany'
				 when trim(cntry) in ('USA','US') then 'United States'
				 when trim(cntry) = '' or cntry is null then 'N/A'
				 else trim(cntry)
			end CNTRY
			from bronze.erp_LOC_A101 
-- Note:
-- Country standardization ensures consistent geographic reporting
-- across ERP and CRM datasets in downstream analytics


		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2'
			TRUNCATE TABLE silver.erp_px_cat_g1v2

		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2'
			insert into silver.erp_px_cat_g1v2 (id,cat,SUBCAT,maintenance)
			select 
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
			from BRONZE.erp_PX_CAT_G1V2
		print '=========================================='
		print 'Loading Silver Layer Completed'
		print '=========================================='
		set @end_time = getdate();
		print 'Load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar)
	END TRY
	BEGIN CATCH
	set @batch_start_time = getdate();
	print '==============================';
	print 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	print '==============================';
	print 'Error Message: '+ Error_message();
	print 'Error Number: '+ cast(error_number() as nvarchar(255));
	print 'Error Line: ' + cast(error_line() as nvarchar(255))
	print 'Error State: ' + cast(error_state() as nvarchar(255))
	print '=============================='
	set @batch_end_time = getdate();
	print 'Catch duration: ' + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar)
	END catch
END
