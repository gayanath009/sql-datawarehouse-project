


CREATE OR ALTER PROCEDURE Bronze.load_bronze_layer 
AS 
/* DDL Scripts to Create the Tables */
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
				SET @start_time = GETDATE();

				PRINT '========================================================'
				PRINT '               Loading Bronze Layer                     '
				PRINT '========================================================'

				PRINT '--------------------------------------------------------'
				PRINT '               Creating CRM Tables                       '
				PRINT '--------------------------------------------------------'
		
		        
		
				IF OBJECT_ID ('Bronze.crm_cust_info', 'U') IS NOT NULL
				  DROP TABLE Bronze.crm_cust_info

        
				CREATE TABLE Bronze.crm_cust_info
				(
					cst_id	INT, 
					cst_key NVARCHAR(50),
					cst_firstname NVARCHAR(50),	
					cst_lastname NVARCHAR(50),	
					cst_marital_status NVARCHAR(50),	
					cst_gndr NVARCHAR(50),
					cst_create_date DATE
				)

		
				IF OBJECT_ID ('Bronze.crm_prd_info', 'U') IS NOT NULL
				  DROP TABLE Bronze.crm_prd_info
 

				 CREATE TABLE Bronze.crm_prd_info
				(
					 prd_id INT,
					 prd_key NVARCHAR(50),
					 prd_nm NVARCHAR(50),
					 prd_cost DECIMAL,	
					 prd_line NVARCHAR(50),	
					 prd_start_dt DATE,
					 prd_end_dt DATE 
				)

 
				IF OBJECT_ID ('Bronze.crm_sales_details', 'U') IS NOT NULL
				  DROP TABLE Bronze.crm_sales_details
 
				 CREATE TABLE Bronze.crm_sales_details
				(
					sls_ord_num	NVARCHAR(50), 
					sls_prd_key	 NVARCHAR(50),
					sls_cust_id INT,
					sls_order_dt NVARCHAR(50),
					sls_ship_dt NVARCHAR(50),
					sls_due_dt	NVARCHAR(50),
					sls_sales DECIMAL,
					sls_quantity INT, 
					sls_price DECIMAL
				)


				IF OBJECT_ID ('Bronze.erp_cust_az12', 'U') IS NOT NULL
				  DROP TABLE Bronze.erp_cust_az12

				 CREATE TABLE Bronze.erp_cust_az12
				(
					cid NVARCHAR(50), 
					bdate DATE,
					gen NVARCHAR(50)
				)

				IF OBJECT_ID ('Bronze.erp_loc_a101', 'U') IS NOT NULL
				  DROP TABLE Bronze.erp_loc_a101


				 CREATE TABLE Bronze.erp_loc_a101
				(
					cid NVARCHAR(50), 
					cntry NVARCHAR(100), 
				)


				IF OBJECT_ID ('Bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
				  DROP TABLE Bronze.erp_px_cat_g1v2
  
				 CREATE TABLE Bronze.erp_px_cat_g1v2
				(
					id NVARCHAR(50),	
					cat NVARCHAR(50),	
					subcat NVARCHAR(50),
					maintenance NVARCHAR(50)
				)



				/* DML Scripts to  Load the Data from CSV to Tables */

				PRINT '>> Truncating Table : Bronze.crm_cust_info '
				TRUNCATE TABLE Bronze.crm_cust_info; 

				PRINT '>> Bulk Inserting Table : Bronze.crm_cust_info '

				BULK INSERT Bronze.crm_cust_info 
				FROM 'D:\Gayanath\Learnings\Data Eng Projects\04_SQL Server\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
				WITH (
				   FIRSTROW = 2,
				   FIELDTERMINATOR = ',',
				   TABLOCK  
				)

				PRINT '>> Truncating Table : Bronze.crm_prd_info '
				TRUNCATE TABLE Bronze.crm_prd_info; 

				PRINT '>> Bulk Inserting Table : Bronze.crm_prd_info '
				BULK INSERT Bronze.crm_prd_info
				FROM 'D:\Gayanath\Learnings\Data Eng Projects\04_SQL Server\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
				WITH (
				   FIRSTROW = 2,
				   FIELDTERMINATOR = ',',
				   TABLOCK  
				)

				PRINT '>> Truncating Table : Bronze.crm_sales_details '
				TRUNCATE TABLE Bronze.crm_sales_details; 
		
		
				PRINT '>> Bulk Inserting Table : Bronze.crm_sales_details '
				BULK INSERT Bronze.crm_sales_details
				FROM 'D:\Gayanath\Learnings\Data Eng Projects\04_SQL Server\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
				WITH (
				   FIRSTROW = 2,
				   FIELDTERMINATOR = ',',
				   TABLOCK  
				)

				PRINT '>> Truncating Table : Bronze.erp_cust_az12'
				TRUNCATE TABLE Bronze.erp_cust_az12; 


				PRINT '>> Bulk Inserting Table : Bronze.erp_cust_az12'
				BULK INSERT Bronze.erp_cust_az12
				FROM 'D:\Gayanath\Learnings\Data Eng Projects\04_SQL Server\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
				WITH (
				   FIRSTROW = 2,
				   FIELDTERMINATOR = ',',
				   TABLOCK  
				)

				PRINT '>> Truncating Table : Bronze.erp_loc_a101'
				TRUNCATE TABLE Bronze.erp_loc_a101; 


				PRINT '>> Bulk Inserting Table : Bronze.erp_loc_a101'
				BULK INSERT Bronze.erp_loc_a101
				FROM 'D:\Gayanath\Learnings\Data Eng Projects\04_SQL Server\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
				WITH (
				   FIRSTROW = 2,
				   FIELDTERMINATOR = ',',
				   TABLOCK  
				)


				PRINT '>> Truncating Table : Bronze.erp_px_cat_g1v2'
				TRUNCATE TABLE Bronze.erp_px_cat_g1v2; 
		
		
				PRINT '>> Bulk Inserting Table : Bronze.erp_px_cat_g1v2'
				BULK INSERT Bronze.erp_px_cat_g1v2
				FROM 'D:\Gayanath\Learnings\Data Eng Projects\04_SQL Server\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
				WITH (
				   FIRSTROW = 2,
				   FIELDTERMINATOR = ',',
				   TABLOCK  
				)

				SET @end_time = GETDATE();
				PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time , @end_time) AS VARCHAR) + ' seconds';

    END TRY

	BEGIN CATCH

			PRINT '========================================================'
			PRINT '   Error Occured During the Loading Bronze Layer        '
			PRINT '   Error Message : '  + ERROR_MESSAGE()
			PRINT '========================================================'

	END CATCH
	

END

