/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Script Purpose:

    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from CSV Files to bronze tables.

Parameters:

    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:

    EXEC bronze.load_bronze;

===============================================================================
*/


create or alter procedure bronze.load_bronze as
begin
declare @start_time	date, @end_time date
set @start_time = getdate();
	BEGIN TRY
		print '=========================================='
		print 'Loading Bronze Layer'
		print '=========================================='

		print '-------------------------------------------'
		print 'Loading CRM Tables'
		print '-------------------------------------------'

		print '>> Truncating Table: bronze.crm_cust_info'
		truncate table bronze.crm_cust_info

		print '>> Inserting Data Into: bronze.crm_cust_info'
		Bulk insert bronze.crm_cust_info
		from 'C:\Users\ahmed\OneDrive\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			tablock
		);


		print '>> Truncating Table: bronze.crm_prd_info'
		truncate table bronze.crm_prd_info

		print '>> Inserting Data Into: bronze.crm_prd_info'
		Bulk insert bronze.crm_prd_info
		from 'C:\Users\ahmed\OneDrive\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			tablock
		);


		print '>> Truncating Table: bronze.crm_sales_details'
		truncate table bronze.crm_sales_details

		print '>> Inserting Data Into: bronze.crm_sales_details'
		Bulk insert bronze.crm_sales_details
		from 'C:\Users\ahmed\OneDrive\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			tablock
		);


			print '-------------------------------------------'
			print 'Loading ERP Tables'
			print '-------------------------------------------'


		print '>> Truncating Table: bronze.erp_CUST_AZ12'
		truncate table bronze.erp_CUST_AZ12

		print '>> Inserting Data Into: bronze.erp_CUST_AZ12'
		Bulk insert bronze.erp_CUST_AZ12
		from 'C:\Users\ahmed\OneDrive\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			tablock
		);


		print '>> Truncating Table: bronze.erp_LOC_A101'
		truncate table bronze.erp_LOC_A101

		print '>> Inserting Data Into: bronze.erp_LOC_A101'
		Bulk insert bronze.erp_LOC_A101
		from 'C:\Users\ahmed\OneDrive\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			tablock
		);



		print '>> Truncating Table: bronze.erp_PX_CAT_G1V2'
		truncate table bronze.erp_PX_CAT_G1V2

		print '>> Inserting Data Into: bronze.erp_PX_CAT_G1V2'
		Bulk insert bronze.erp_PX_CAT_G1V2
		from 'C:\Users\ahmed\OneDrive\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			tablock
		);
		print '=========================================='
		print 'Loading Bronze Layer Completed'
		print '=========================================='
set @end_time = getdate();
print 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as nvarchar)
	END TRY
	BEGIN CATCH
	print '==============================';
	print 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	print '==============================';
	print 'Error Message: '+ Error_message();
	print 'Error Number: '+ cast(error_number() as nvarchar(255));
	print 'Error Line: ' + cast(error_line() as nvarchar(255))
	print 'Error State: ' + cast(error_state() as nvarchar(255))
	print '=============================='
	END catch

end
