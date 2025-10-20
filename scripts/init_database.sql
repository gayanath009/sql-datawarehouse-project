
/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DWH_DataEng1' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DWH_DataEng1' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DWH_DataEng1')
BEGIN
    ALTER DATABASE DWH_DataEng1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DWH_DataEng1;
END;
GO

-- Create the 'DWH_DataEng1' database
CREATE DATABASE DWH_DataEng1;
GO

USE DWH_DataEng1;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
