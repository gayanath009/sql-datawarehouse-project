



CREATE VIEW [Gold].[Dim_Product] AS 
SELECT 
       ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key
      ,pn.[prd_id] AS product_id 	  
      ,pn.[prd_key] AS product_number
	  ,pn.cat_id  AS category_id 	  
	  ,pn.[prd_nm] AS product_name 	  
	  ,pc.cat AS catgory
	  ,pc.subcat as subcatgory
      ,pc.maintenance 
      ,pn.[prd_cost] AS cost
      ,pn.[prd_line] AS product_line 
      ,pn.[prd_start_dt] AS [start_date]
	  
  FROM [Silver].[crm_prd_info] pn
  LEFT OUTER JOIN [Silver].[erp_px_cat_g1v2] pc ON pn.cat_id = pc.id
  WHERE prd_end_dt IS NULL --Filter out Old historical Data

GO

/****** Object:  View [Gold].[Dim_Customer]    Script Date: 23/10/2025 11:09:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [Gold].[Dim_Customer]
AS 
SELECT 
      ROW_NUMBER() OVER (ORDER BY [cst_id]) AS customer_key
      ,ci.[cst_id] AS customer_id
      ,ci.[cst_key] AS customer_number 
      ,ci.[cst_firstname] AS first_name
      ,ci.[cst_lastname] AS last_name
	  ,lc.[cntry] AS country
      ,ci.[cst_marital_status] AS marital_status
      , CASE WHEN ci.[cst_gndr] != 'n/a' THEN ci.cst_gndr --CRM is the Master for Gender 
	    ELSE COALESCE(ca.gen, 'n/a') END AS gender
	  ,ca.bdate AS birthday	  
	  ,ci.[cst_create_date] AS create_date     
	  
	  
  FROM [Silver].[crm_cust_info] ci 
        LEFT OUTER JOIN [Silver].[erp_cust_az12] ca ON ci.cst_key = ca.cid
        LEFT OUTER JOIN [Silver].[erp_loc_a101] lc ON ci.cst_key = lc.cid


        
GO

/****** Object:  View [Gold].[Fact_Sales]    Script Date: 23/10/2025 11:09:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [Gold].[Fact_Sales]
AS 
SELECT 
       sl.sls_ord_num AS order_number
	  ,pd.product_key
	  ,cs.customer_key            
      ,sl.sls_order_dt AS order_date
      ,sl.sls_ship_dt AS shipping_date
      ,sl.sls_due_dt AS due_date
      ,sl.sls_sales AS sales_amount
      ,sl.sls_quantity AS quantity
      ,sl.sls_price AS price      
  FROM [Silver].[crm_sales_details] sl
  LEFT OUTER JOIN [Gold].Dim_Product pd  ON sl.sls_prd_key = pd.[product_number]
  LEFT OUTER JOIN [Gold].Dim_Customer cs  ON sl.sls_cust_id = cs.[customer_id]

GO


