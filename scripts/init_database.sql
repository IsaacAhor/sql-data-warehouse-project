
/*
=================================================================================================
Create Database and Schemas
=================================================================================================
Description
This SQL script is designed to:

Check if the Datawarehouse database exists.
If it exists, it forcefully sets it to SINGLE_USER mode (rolling back any active transactions) and drops it.
It then recreates the database if it does not exist.
Finally, it creates three schemas within the Datawarehouse database:
bronze
silver
gold
This follows a bronze-silver-gold data architecture pattern commonly used in data warehousing.

Key Features:
Ensures the Datawarehouse database is always freshly created.
Implements a structured schema for data processing.
⚠️ Warnings & Considerations
Irreversible Action:

Dropping the database permanently deletes all data inside it. Ensure you backup any necessary data before running this script.
Single-User Mode Impact:

The ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE command forcibly disconnects all other users from the database.
If other processes rely on this database, they will be interrupted.
Permissions:

You must have sufficient DBA privileges to execute this script.
Execution Order:

The script uses GO statements to ensure proper execution order.
Running only a partial script may leave the database in an unintended state.
Initial Check Issue:

The first check only prints "Database exists" instead of proceeding with the drop.
The drop operation always runs regardless of the check. If the intent was to avoid dropping when the database exists, an ELSE condition should be added.
How to Use
Run this script in SQL Server Management Studio (SSMS) or any SQL execution tool that supports GO batch processing.

Suggested Improvements
Consider adding a backup step before dropping the database.
Modify the drop logic so that it only executes when necessary (e.g., using an ELSE clause).
*/


USE master;
SELECT name from sys.databases;

-- Drop & re-create 'Datawarehouse' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN 
	PRINT 'Database exists';
END;

BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE Datawarehouse
END;

SELECT name FROM sys.databases;

GO

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN 
	CREATE DATABASE Datawarehouse;
END;

GO

SELECT name FROM sys.databases;
GO

-- Create Schemas

USE Datawarehouse;
GO

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
