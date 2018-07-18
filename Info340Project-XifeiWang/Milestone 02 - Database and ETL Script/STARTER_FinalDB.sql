--*************************************************************************--
-- Title: Module08-Milestone02
-- Author: YourNameHere
-- Desc: This file is used to create a database for the Final
-- Change Log: When,Who,What
-- 2017-01-01,YourNameHere,Created File
--**************************************************************************--
-- Step 1: Create the Lab database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'MyLabsDB_YourNameHere')
 Begin 
  Alter Database [MyLabsDB_YourNameHere] set Single_user With Rollback Immediate;
  Drop Database MyLabsDB_YourNameHere;
 End
go

Create Database MyLabsDB_YourNameHere;
go
Use MyLabsDB_YourNameHere;
go

-- 1) Create the tables --------------------------------------------------------
-- 2) Create the constraints ---------------------------------------------------
-- 3) Create the views ---------------------------------------------------------
-- 4) Create the stored procedures ---------------------------------------------
-- 5) Set the permissions ------------------------------------------------------
-- 6) Test the views and stored procedures -------------------------------------

