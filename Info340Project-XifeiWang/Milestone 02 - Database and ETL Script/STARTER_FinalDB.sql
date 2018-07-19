--*************************************************************************--
-- Title: Module08-Milestone02
-- Author:Xifei Wang
-- Desc: This file is used to create a database for the Final
-- Change Log: When,Who,What
-- 2017-01-01,XifeiWang,Created File
--**************************************************************************--
-- Step 1: Create the Lab database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'MyLabsDB_XifeiWang')
 Begin 
  Alter Database [MyLabsDB_XifeiWang] set Single_user With Rollback Immediate;
  Drop Database MyLabsDB_XifeiWang;
 End
go

Create Database MyLabsDB_XifeiWang;
go
Use MyLabsDB_XifeiWang;
go

-- 1) Create the tables --------------------------------------------------------
Create -- drop
Table Doctor(
	DoctorID int Primary Key Identity(1,1)
,	DoctorFirstName nVarChar(100) Not Null
,	DoctorLastName nVarChar(100) Not Null
,	DoctorPhoneNumber nVarChar(100)	Not Null Check (DoctorPhoneNumber like
	 '([0-9][0-9][0-9])-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,	DoctorStreet nVarChar(100) Not Null
,	DoctorCity nVarChar(100) Not Null
,	DoctorState nChar(2) Not Null
,	DoctorZipCode nVarchar(10) Not Null Check(DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]' or
	DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
);
Go



Create -- drop
Table Clinics (
	ClinicID int  Primary Key Identity(1,1)
,	ClinicName nVarchar(100) Not Null Unique
,	ClinicPhoneNumber nVarchar(100) Not Null Check (ClinicPhoneNumber like
	 '([0-9][0-9][0-9])-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,	ClinicAddress nVarchar(100) Not Null
,	ClinicCity nVarchar(100) Not Null
,	ClinicState nChar(2) Not Null
,	ClinicZip nVarchar(10) Not Null Check(ClinicZip like '[0-9][0-9][0-9][0-9][0-9]' or
	ClinicZip like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,	DoctorID int Not Null Foreign Key references Doctor(DoctorID)
);
Go

Create Table Patient (
	PatientID int Primary Key Identity(1, 1)
,	PatientFirstName nVarChar(100)	Not Null
,	PatientLastName	nVarChar(100)	Not Null
,	PatientPhoneNumber nVarChar(100)	Not Null Check (PatientPhoneNumber like
	 '([0-9][0-9][0-9])-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,	PatientStreet nVarChar(100)	Not Null
,	PatientCity	nVarChar(100)	Not Null
,	PatientState nChar(2)	Not Null
,	PatientZipCode nVarchar(10)	Not Null Check (PatientZipCode like '[0-9][0-9][0-9][0-9][0-9]' or
	PatientZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,	PatientGender	nChar(1)	Not Null Check (PatientGender in ('M', 'F'))
);
Go

Create Table Appointment (
	AppointmentID int Primary Key Identity(1,1)
,	AppointmentTime	DateTime Not Null
,	AppointmentStreet nVarChar(100)	Not Null
,	AppointmentCity	nVarChar(100)	Not Null
,	AppointmentState nChar(2)	Not Null
,	AppointmentZipCode nVarchar(10)	Not Null Check(AppointmentZipCode like '[0-9][0-9][0-9][0-9][0-9]' or
	AppointmentZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,	DoctorID int Not Null Foreign Key references Doctor(DoctorID)
,	PatientID int Not Null Foreign Key references Patient(PatientID)
);
Go

-- 2) Create the constraints ---------------------------------------------------
-- 3) Create the views ---------------------------------------------------------
Create View vPatient
as
Select * From
Patient
Go

Create View vAppointment
as
Select * From
Appointment
Go

Create View vDoctor
as
Select * From
Doctor
Go

Create View vClinics
as
Select * From
Clinics
Go
Select * From vAppointment;
Go
Select * From vClinics;
Go
Select * From vDoctor;
Go
Select * From vPatient;
Go
-- 4) Create the stored procedures ---------------------------------------------
-- 5) Set the permissions ------------------------------------------------------
-- 6) Test the views and stored procedures -------------------------------------

