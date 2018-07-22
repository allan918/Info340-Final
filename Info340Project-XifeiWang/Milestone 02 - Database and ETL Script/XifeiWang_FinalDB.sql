--*************************************************************************--
-- Title: Module08-Milestone02
-- Author:Xifei Wang
-- Desc: This file is used to create a database for the Final
-- Change Log: When,Who,What
-- 2018-07-21,XifeiWang,Created File
-- Class: Info 340
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
Table Clinics (
	ClinicID int  Primary Key Identity(1,1)
,	ClinicName nVarchar(100) Not Null Unique
,	ClinicPhoneNumber nVarchar(100) Not Null Check (ClinicPhoneNumber like
	 '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,	ClinicAddress nVarchar(100) Not Null
,	ClinicCity nVarchar(100) Not Null
,	ClinicState nChar(2) Not Null
,	ClinicZip nVarchar(10) Not Null Check(ClinicZip like '[0-9][0-9][0-9][0-9][0-9]' or
	ClinicZip like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
);
Go

Create -- drop
Table Doctor(
	DoctorID int Primary Key Identity(1,1)
,	DoctorFirstName nVarChar(100) Not Null
,	DoctorLastName nVarChar(100) Not Null
,	DoctorPhoneNumber nVarChar(100)	Not Null Check (DoctorPhoneNumber like
	 '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,	DoctorStreet nVarChar(100) Not Null
,	DoctorCity nVarChar(100) Not Null
,	DoctorState nChar(2) Not Null
,	DoctorZipCode nVarchar(10) Not Null Check(DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]' or
	DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
,   ClinicID int Not Null Foreign Key references Clinics(ClinicID)

);
Go





Create Table Patient (
	PatientID int Primary Key Identity(1, 1)
,	PatientFirstName nVarChar(100)	Not Null
,	PatientLastName	nVarChar(100)	Not Null
,	PatientPhoneNumber nVarChar(100)	Not Null Check (PatientPhoneNumber like
	 '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
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

Create View vAppointmentsByPatientsDoctorsAndClinics
as
Select 
	 c.ClinicID
	,ClinicName
	,ClinicPhoneNumber
	,ClinicAddress
	,ClinicCity
	,ClinicState
	,ClinicZip
	,p.PatientID
	,PatientFirstName
	,PatientLastName
	,PatientPhoneNumber
	,PatientStreet
	,PatientCity
	,PatientState
	,PatientZipCode
	,PatientGender
	,d.DoctorID
	,DoctorFirstName
	,DoctorLastName
	,DoctorPhoneNumber
	,DoctorStreet
	,DoctorCity
	,DoctorState
	,DoctorZipCode
	,AppointmentID
	,AppointmentTime
	,AppointmentStreet
	,AppointmentCity
	,AppointmentState
	,AppointmentZipCode
From Patient as p Join Appointment as a
On p.PatientID = a.PatientID
Join Doctor as d on
d.DoctorID = a.DoctorID
Join Clinics as c
on d.ClinicID = c.ClinicID
Go

Select * From vAppointment;
Go
Select * From vClinics;
Go
Select * From vDoctor;
Go
Select * From vPatient;
Go
Select * From vAppointmentsByPatientsDoctorsAndClinics;
Go
-- 4) Create the stored procedures ---------------------------------------------
Create Procedure pInsDoctor
(
@DoctorID	int out, 
@DoctorFirstName	nVarChar(100)	  ,
@DoctorLastName	nVarChar(100)		  ,
@DoctorPhoneNumber	nVarChar(100)	  ,
@DoctorStreet	nVarChar(100)		  ,
@DoctorCity	nVarChar(100)			  ,
@DoctorState	nChar(2)			  ,
@DoctorZipCode	nVarchar(10)		  ,
@ClinicID int
)
/* Author: Xifei Wang
** Desc: Processes add data on doctor table
** Change Log: When,Who,What
** 2018-07-19,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Insert into Doctor(
		 DoctorFirstName
		,DoctorLastName	
		,DoctorPhoneNumber
		,DoctorStreet	
		,DoctorCity	
		,DoctorState	
		,DoctorZipCode
		,ClinicID)
	Values(
		 @DoctorFirstName
		,@DoctorLastName	
		,@DoctorPhoneNumber
		,@DoctorStreet	
		,@DoctorCity	
		,@DoctorState	
		,@DoctorZipCode
		,@ClinicID
	)
	Set @DoctorID = @@identity;
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsPatient					
(	
	 @PatientID int out
	,@PatientFirstName nVarchar(100)
	,@PatientLastName nVarchar(100)
	,@PatientPhoneNumber nVarchar(100)
	,@PatientStreet nVarchar(100)
	,@PatientCity nVarchar(100)
	,@PatientState nChar(2)
	,@PatientZipCode nVarchar(10)
	,@PatientGender	nChar(1)
)
/* Author: Xifei Wang
** Desc: Processes add data on Patient table
** Change Log: When,Who,What
** 2018-07-19,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Insert into Patient(
		 PatientFirstName 
		,PatientLastName 
		,PatientPhoneNumber
		,PatientStreet 
		,PatientCity 
		,PatientState 
		,PatientZipCode 
		,PatientGender
		)
	Values(
		 @PatientFirstName 
		,@PatientLastName 
		,@PatientPhoneNumber
		,@PatientStreet 
		,@PatientCity 
		,@PatientState 
		,@PatientZipCode 
		,@PatientGender
	)
	Set @PatientID = @@identity;
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsAppointment					
(	
	@AppointmentID	int out
,	@AppointmentTime	DateTime
,	@AppointmentStreet	nVarChar(100)
,	@AppointmentCity	nVarChar(100)
,	@AppointmentState	nChar(2)
,	@AppointmentZipCode	nVarchar(10)
,	@DoctorID	int
,	@PatientID	int
)
/* Author: Xifei Wang
** Desc: Processes add data on Appointment table
** Change Log: When,Who,What
** 2018-07-19,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Insert into Appointment(
		 AppointmentTime
		,AppointmentStreet
		,AppointmentCity
		,AppointmentState
		,AppointmentZipCode
		,DoctorID
		,PatientID
		)
	Values(
		 @AppointmentTime
		,@AppointmentStreet
		,@AppointmentCity
		,@AppointmentState
		,@AppointmentZipCode
		,@DoctorID
		,@PatientID
	)
	Set @AppointmentID = @@identity;
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsClinics					
(	
	 @ClinicID	int out
	,@ClinicName	nVarchar(100)
	,@ClinicPhoneNumber	nVarchar(100)
	,@ClinicAddress	nVarchar(100)
	,@ClinicCity	nVarchar(100)
	,@ClinicState	nChar(2)
	,@ClinicZip	nVarchar(10)
)
/* Author: Xifei Wang
** Desc: Processes add data on Appointment table
** Change Log: When,Who,What
** 2018-07-19,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Insert into Clinics(
		 ClinicName
		,ClinicPhoneNumber
		,ClinicAddress
		,ClinicCity
		,ClinicState
		,ClinicZip
		)
	Values(
		 @ClinicName
		,@ClinicPhoneNumber
		,@ClinicAddress
		,@ClinicCity
		,@ClinicState
		,@ClinicZip
	)
	Set @ClinicID = @@identity;
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdDoctor
(
	@DoctorID	int out, 
	@DoctorFirstName	nVarChar(100)	  ,
	@DoctorLastName	nVarChar(100)		  ,
	@DoctorPhoneNumber	nVarChar(100)	  ,
	@DoctorStreet	nVarChar(100)		  ,
	@DoctorCity	nVarChar(100)			  ,
	@DoctorState	nChar(2)			  ,
	@DoctorZipCode	nVarchar(10)		  ,
	@ClinicID int
 )
/* Author: Xifei Wang
** Desc: update data on Doctor table
** Change Log: When,Who,What
** 2018-07-12,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Update Doctor
	Set DoctorFirstName = @DoctorFirstName,
		DoctorLastName = @DoctorLastName,
		DoctorPhoneNumber= @DoctorPhoneNumber,
		DoctorStreet = @DoctorStreet,
		DoctorCity = @DoctorCity,
		DoctorState = @DoctorState,
		DoctorZipCode = @DoctorZipCode,
		ClinicID = @ClinicID
	Where DoctorID = DoctorID
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdPatient
(
	 @PatientID	int
	,@PatientFirstName	nVarChar(100)
	,@PatientLastName	nVarChar(100)
	,@PatientPhoneNumber	nVarChar(100)
	,@PatientStreet	nVarChar(100)
	,@PatientCity	nVarChar(100)
	,@PatientState	nChar(2)
	,@PatientZipCode	nVarchar(10)
	,@PatientGender	nChar(1)
 )
/* Author: Xifei Wang
** Desc: update data on Patient table
** Change Log: When,Who,What
** 2018-07-12,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Update Patient
	Set 
	 PatientFirstName = @PatientFirstName	
	,PatientLastName	= @PatientLastName	
	,PatientPhoneNumber = @PatientPhoneNumber
	,PatientStreet = @PatientStreet	
	,PatientCity = @PatientCity	
	,PatientState = @PatientState	
	,PatientZipCode = @PatientZipCode	
	,PatientGender = @PatientGender	
	Where PatientID = PatientID
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdAppointment
(
	 @AppointmentID	int
	,@AppointmentTime	DateTime
	,@AppointmentStreet	nVarChar(100)
	,@AppointmentCity	nVarChar(100)
	,@AppointmentState	nChar(2)
	,@AppointmentZipCode	nVarchar(10)
	,@DoctorID	int
	,@PatientID	int
 )
/* Author: Xifei Wang
** Desc: update data on Appointment table
** Change Log: When,Who,What
** 2018-07-12,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Update Appointment
	Set 	
	   AppointmentTime	= @AppointmentTime	
	  ,AppointmentStreet = @AppointmentStreet	
	  ,AppointmentCity	= @AppointmentCity
	  ,AppointmentState = @AppointmentState
	  ,AppointmentZipCode = @AppointmentZipCode
	  ,DoctorID = @DoctorID
	  ,PatientID = @PatientID
	Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdClinics
(
	 @ClinicID	int
	,@ClinicName	nVarchar(100)
	,@ClinicPhoneNumber	nVarchar(100)
	,@ClinicAddress	nVarchar(100)
	,@ClinicCity	nVarchar(100)
	,@ClinicState	nChar(2)
	,@ClinicZip	nVarchar(10)
 )
/* Author: Xifei Wang
** Desc: update data on Clinics table
** Change Log: When,Who,What
** 2018-07-12,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Update Clinics
	Set 	
	 ClinicName = @ClinicName	
	,ClinicPhoneNumber = @ClinicPhoneNumber
	,ClinicAddress = @ClinicAddress	
	,ClinicCity = @ClinicCity	
	,ClinicState = @ClinicState	
	,ClinicZip = @ClinicZip
	Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelAppointment
(@AppointmentID int)
/* Author: Xifei Wang
** Desc: Delete data on Appointment table
** Change Log: When,Who,What
** 2018-07-12,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Delete From Appointment
	Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelDoctor
(@DoctorID int)
/* Author: Xifei Wang
** Desc: Delete data on Doctor table
** Change Log: When,Who,What
** 2018-07-12,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Delete From Doctor
	Where DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelClinics
(@ClinicID int)
/* Author: Xifei Wang
** Desc: Delete data on Clinics table
** Change Log: When,Who,What
** 2018-07-12,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Delete From Clinics
	Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelPatient
(@PatientID int)
/* Author: Xifei Wang
** Desc: Delete data on Patient table
** Change Log: When,Who,What
** 2018-07-12,Xifei Wang,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
	Delete From Patient
	Where PatientID = @PatientID
   Commit Transaction
   Set @RC = +100
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -100
  End Catch
  Return @RC;
 End
Go
-- 5) Set the permissions ------------------------------------------------------
Grant 
Select on vPatient to public;
Go
Grant Execute on pInsPatient to public;
Go
Grant Execute on pUpdPatient to public;
Go
Grant Execute on pDelPatient to public;
Go
Deny Select, Update, Delete, Insert on Patient to Public;
Go

Grant 
Select on vDoctor to public;
Go
Grant Execute on pInsDoctor to public;
Go
Grant Execute on pUpdDoctor to public;
Go
Grant Execute on pDelDoctor to public;
Go
Deny Select, Update, Delete, Insert on Doctor to Public;
Go

Grant 
Select on vAppointment to public;
Go
Grant Execute on pInsAppointment to public;
Go
Grant Execute on pUpdAppointment to public;
Go
Grant Execute on pDelAppointment to public;
Go
Deny Select, Update, Delete, Insert on Appointment to Public;
Go

Grant 
Select on vClinics to public;
Go
Grant Execute on pInsClinics to public;
Go
Grant Execute on pUpdClinics to public;
Go
Grant Execute on pDelClinics to public;
Go
Deny Select, Update, Delete, Insert on Clinics to Public;
Go

Grant
Select on vAppointmentsByPatientsDoctorsAndClinics to Public;

-- 6) Test the views and stored procedures -------------------------------------
Declare @Status int, @ClinicID int; 
Exec @Status = pInsClinics
	 @ClinicID	= @ClinicID out
	,@ClinicName	= 'abc'
	,@ClinicPhoneNumber	= '610-570-6768'
	,@ClinicAddress	= 'a'
	,@ClinicCity	= 'Seattle'
	,@ClinicState	= 'WA'
	,@ClinicZip	= '98103'
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pInsClinic Status];
Select @ClinicID as [Inserted ID]
Go

Declare @Status int, @DoctorID int; 
Exec @Status = pInsDoctor 
		 @DoctorID = @DoctorID out
		,@DoctorFirstName = 'a'
		,@DoctorLastName	= 'b'
		,@DoctorPhoneNumber = '619-570-6745'
		,@DoctorStreet	= 'asdasfaffa'
		,@DoctorCity	= 'asd'
		,@DoctorState	= 'wa'
		,@DoctorZipCode	= '98108-1234'
		,@ClinicID = 1
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pInsDoctor Status];
Select @DoctorID as [Inserted ID]
Go


Declare @Status int; 
Declare @PatientID int;
Exec @Status = pInsPatient
		 @PatientID = @PatientID out
		,@PatientFirstName = 'a'
		,@PatientLastName	= 'b'
		,@PatientPhoneNumber = '619-570-6745'
		,@PatientStreet	= 'asdasfaffa'
		,@PatientCity	= 'asd'
		,@PatientState	= 'wa'
		,@PatientZipCode	= '98108-1234'
		,@PatientGender = 'm'
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pInsPatient Status];
Select @PatientID as [Inserted ID]
Go

Declare @Status int, @AppointmentID int; 
Exec @Status = pInsAppointment
		@AppointmentID = @AppointmentID out
	,	@AppointmentTime = '1997-09-18'
	,	@AppointmentStreet = 'a'
	,	@AppointmentCity = 'b'
	,	@AppointmentState = 'c'
	,	@AppointmentZipCode = '98105'
	,	@DoctorID = '1'
	,	@PatientID = '1'
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pInsAppointment Status];
Select @AppointmentID as [Inserted ID]
Go



Select * From vAppointment;
Go
Select * From vClinics;
Go
Select * From vDoctor;
Go
Select * From vPatient;
Go
Select * From vAppointmentsByPatientsDoctorsAndClinics;
Go

Declare @Status int;
Exec @Status = pUpdClinics
	 @ClinicID	= 1
	,@ClinicName	= 'Changed'
	,@ClinicPhoneNumber	= '610-570-6768'
	,@ClinicAddress	= 'a'
	,@ClinicCity	= 'Seattle'
	,@ClinicState	= 'WA'
	,@ClinicZip	= '98103'
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pUpdClients Status];
Go

Declare @Status int;
Exec @Status = pUpdDoctor
		 @DoctorID = 1
		,@DoctorFirstName = 'changed'
		,@DoctorLastName	= 'bv'
		,@DoctorPhoneNumber = '619-590-6745'
		,@DoctorStreet	= 'asda'
		,@DoctorCity	= 'asdd'
		,@DoctorState	= 'PA'
		,@DoctorZipCode	= '98108-1134'
		,@ClinicID = 1
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pUpdDoctor Status];
Go

Declare @Status int;
Exec @Status = pUpdPatient
		 @PatientID = 1
		,@PatientFirstName = 'changed'
		,@PatientLastName	= 'b'
		,@PatientPhoneNumber = '619-570-6745'
		,@PatientStreet	= 'asdasfaffa'
		,@PatientCity	= 'asd'
		,@PatientState	= 'wa'
		,@PatientZipCode	= '98108-1234'
		,@PatientGender = 'm'
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pUpdPatient Status];
Go

Declare @Status int;
Exec @Status = pUpdAppointment
		@AppointmentID = 1
	,	@AppointmentTime = '1997-09-19'
	,	@AppointmentStreet = 'changed'
	,	@AppointmentCity = 'bc'
	,	@AppointmentState = 'cc'
	,	@AppointmentZipCode = '98101'
	,	@DoctorID = '1'
	,	@PatientID = '1'
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pUpdAppointment Status];
Go

Select * From vAppointment;
Go
Select * From vClinics;
Go
Select * From vDoctor;
Go
Select * From vPatient;
Go

Declare @Status int;
Exec @Status = pDelAppointment
		@AppointmentID = 1
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pDelAppointment Status];
Go

Declare @Status int;
Exec @Status = pDelDoctor
		@DoctorID = 1
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pDelDoctor Status];
Go

Declare @Status int;
Exec @Status = pDelClinics
		@ClinicID = 1
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pDelClinics Status];
Go

Declare @Status int;
Exec @Status = pDelPatient
		@PatientID = 1
Select Case @Status 
	when 100 Then 'Operation successful!'
	when -100 Then 'Operation failed!'
	End As [pDelPatient Status];
Go

Select * From vAppointment;
Go
Select * From vClinics;
Go
Select * From vDoctor;
Go
Select * From vPatient;
Go




