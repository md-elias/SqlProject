--Database Create With Properties
--==================================
USE master
DROP DATABASE IF EXISTS STMS_IsDB
GO
--=========================
Use master
Create database STMS_IsDB
Go
--========================================
ALTER DATABASE STMS_IsDB MODIFY FILE 
(NAME=N'STMS_IsDB_DATA', Size=25MB, MaxSize=100MB, FileGrowth=5% )
GO
ALTER DATABASE STMS_IsDB MODIFY FILE 
( NAME=N'STMS_IsDB_LOG', Size = 10MB, MaxSize = 100MB, FileGrowth = 1MB)
GO

--===============================================
IF  NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'TouristAndHospitalityManagement')
    BEGIN
        CREATE DATABASE [TouristAndHospitalityManagement]
    END;
GO
--======================================================
Use master
Create database STMS_IsDB
on primary
(
Name='STMS_IsDB_Data',Filename='C:\idb_c#\ELIAS\SQL SERVER\1257168\STMS_IsDB_Data.Mdf',size=10mb,maxsize=100mb,FileGrowth=5%
)
Log On
(
Name='STMS_IsDB_Log',Filename='C:\idb_c#\ELIAS\SQL SERVER\1257168\STMS_IsDB_Log.Ldf',size=5mb,maxsize=10mb,FileGrowth=5%
)
Go 
--================================     
--Create Table
--================================
Use STMS_IsDB
CREATE TABLE RoundInfo
(
RoundID int Identity primary Key,
RoundNo varchar(20)
);
GO

Use STMS_IsDB
CREATE TABLE Circular
(
CircularID int Identity primary Key,
CircularNo int,
CircularType varchar(20),
CircularDate  Date,
Deadline Date,
RoundID int foreign key references RoundInfo(RoundID)
);
GO
 
CREATE TABLE TraineeInfo
(
TraineeID int Identity primary Key,
Name varchar(20)  not null,
FathersName varchar(20),
MothersName  varchar(20),
ContanctNo char(30) not null CHECK ((ContanctNo Like '[0][1][0-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')),
[Address] varchar(20),
EmailID varchar(20),
NID varchar(20),
EducationalBacground varchar(20),
Religon varchar(20),
TransactionNumber varchar(20),
RoundID int foreign key references RoundInfo(RoundID)
);
GO

Use STMS_IsDB
CREATE TABLE ScheduleInfo
(
ScheduleID int Identity primary Key,
ScheduleDay varchar(30),
ScheduleTime varchar(20)
);
GO                          

Use STMS_IsDB
CREATE TABLE ExamInfo
(
ExamID int Identity primary Key,
ExamName varchar(20),
ScheduleID int foreign key references ScheduleInfo(ScheduleID)
);
GO

--Alter Table(Add Column)
Alter Table ExamInfo
Add ExamDate Date;

Use STMS_IsDB
CREATE TABLE ExamStatus
(
ExamID int foreign key references ExamInfo(ExamID),
TraineeID int foreign key references TraineeInfo(TraineeID) ON DELETE CASCADE,
MarksInMcq int,
MarksInViba int,
IsSelected bit
);
GO

Use STMS_IsDB
CREATE TABLE BatchInfo
(
BatchID int Identity primary Key,
ScheduleID int foreign key references ScheduleInfo(ScheduleID)
);
GO

Use STMS_IsDB
CREATE TABLE TSPInfo
(
TSPID int Identity primary Key,
TSPName varchar(20),
Location  varchar(20)
);

GO

Use STMS_IsDB
CREATE TABLE InstractorInfo
(
InstractorId int Identity primary Key,
InstractorName varchar(20)
);
GO

Use STMS_IsDB
CREATE TABLE BatchAssign
(
TraineeID int foreign key references TraineeInfo(TraineeID),
TSPID int foreign key references TSPInfo(TSPID) ON UPDATE CASCADE
);
GO

Use STMS_IsDB
CREATE TABLE AttendenceStatus
(
TraineeID int foreign key references TraineeInfo(TraineeID),
Entrytime time,
ExitTime time,
ClassDate  datetime Not Null CONSTRAINT CN_ClassDate DEFAULT (getdate()) CHECK ((ClassDate<=getdate()))
);
GO

--=======================================
--Create Clustered Index Question no 2
--=======================================
Create Clustered Index cl_ExmSts On ExamStatus(ExamID)
Go

--=======================================
--Create Non Clustered Index Question no 3
--=======================================
Create NonClustered Index nc_AttSta on AttendenceStatus(Entrytime)
Go 

--=====================================
--          view
--=====================================
Create View vw_Schmbd
With Schemabinding
AS 
Select TraineeID as ID,CircularType as CT
From dbo.TraineeInfo join dbo.Circular
On TraineeInfo.TraineeID=Circular.CircularID
Go

Select * From vw_Schmbd
GO

--Create View vw_TrineeInfo
--With Encryption
--AS 
--Select TraineeID,Name,EducationalBacground
--From TraineeInfo
--Go

--============================
--          Trigger
--============================
Create Table Schedule_Info_History
(
ScheduleID int,
ScheduleDay varchar(30),
ScheduleTime varchar(20),
AudtiAction varchar(30),
AuditTimeStamp datetime
)
Go

Create Trigger tr_After_Insert_Schedule on dbo.ScheduleInfo
For Insert
As
Declare @scheduleid int, @scheduleday varchar(30),@scheduletime varchar(20),@auditaction varchar(30)
Select @scheduleid=i.ScheduleID from inserted as i;
Select @scheduleday=i.ScheduleDay from inserted as i;
Select @scheduletime=i.ScheduleTime from inserted as i;
Set @auditaction='Row has been Inserted in ScheduleInfo Table';
Insert Into Schedule_Info_History(ScheduleID,ScheduleDay,ScheduleTime,AudtiAction,AuditTimeStamp)
Values(@scheduleid,@scheduleday,@scheduletime,@auditaction,getdate());
Print 'After Trigger Fired For Insert'
Go

--Instead of Trigger
Create Trigger trg_forupdatedelete on TSPInfo
Instead of Update, Delete
AS
Declare @rowcount int
Set @rowcount=@@ROWCOUNT
IF(@rowcount>1)
				BEGIN
				Raiserror('You cannot Update or Delete more than 1 Record',16,1)
				END
Else 
	Print 'Update or Delete Successful'
GO

--===============================
--        Store Procedure
--===============================
CREATE PROC spModifyTSPInfo
@tspid int,
@tspname varchar(20),
@location  varchar(20),
@tablename varchar(25),
@operationname varchar(25)
AS
BEGIN
	IF(@tablename='TSPInfo' AND @operationname='INSERT')
		BEGIN
			INSERT TSPInfo VALUES (@tspname,@location)
		END
	IF(@tablename='TSPInfo' AND @operationname='UPDATE')
		BEGIN
			UPDATE TSPInfo SET TSPName=@tspname WHERE TSPID=@tspid
		END
	IF(@tablename='TSPInfo' AND @operationname='DELETE')
		BEGIN
			DELETE FROM TSPInfo WHERE TSPID=@tspid
		END
END
GO
EXEC spModifyTSPInfo 3,'Macro','WASA','TSPInfo','INSERT'

EXEC spModifyTSPInfo 3,'BiconIT','GEC','TSPInfo','UPDATE'

EXEC spModifyTSPInfo 3,'Macro','WASA','TSPInfo','DELETE'

SELECT * FROM TSPInfo
GO

--Using seed value and self reference
Use STMS_IsDB
Create Table Employees
(
[EmployeeID] [int] Identity(5,3) Not Null Primary key,
[Employee Name] [nvarchar](25) sparse Null,
[Designation] [nvarchar](25)  Null,
[Join Date] [datetime],
[Salary] [money],
[Income Tax]  as ([Salary]*.04),
[Is Active] [bit],
[Termination Date] [datetime] CONSTRAINT CN_Defaultdate DEFAULT ('UNKNOWN'),
[Coordinator ID] [int] Foreign Key References Employees([EmployeeID])
);
Go

--===============================================================
--Scaler Function
--===============================================================
CREATE FUNCTION dbo.fn_Tax(@empl_id int)
RETURNS int
AS
BEGIN
	RETURN
	(SELECT SUM([Income Tax]) FROM Employees WHERE [EmployeeID]=@empl_id)
END
GO
PRINT dbo.fn_Tax(5)
GO

--===============================================================
--Scaler Function
--===============================================================
CREATE FUNCTION dbo.fn_TotalTax2()
RETURNS int
AS
BEGIN
	RETURN
	(SELECT SUM([Income Tax]) FROM Employees)
END
GO
PRINT dbo.fn_TotalTax2()
GO
--Tabular Function
--====================================================================
CREATE FUNCTION dbo.fn_TableForName(@tnm varchar(20))
RETURNS TABLE 
AS
RETURN
(SELECT TraineeInfo.TraineeID,TraineeInfo.Name,TraineeInfo.ContanctNo,Circular.CircularID
FROM TraineeInfo
Join Circular
ON TraineeInfo.RoundID=Circular.RoundID
WHERE Name=@tnm
)
GO
SELECT * FROM dbo.fn_TableForName('Arefin')
GO

--Throw statement
--==============================================
BEGIN TRY
    INSERT INTO InstractorInfo(InstractorId) VALUES(1);
    --  cause error
    INSERT INTO InstractorInfo(InstractorId) VALUES(1);
END TRY
BEGIN CATCH
    PRINT('Raise the caught error again');
    THROW;
END CATCH

--====================
--Temporary Table
--=====================
Create Table #Course
(
CourseID int Identity Primary Key,
CourseName varchar(30) not null,
CourseDuration varchar(30),
VendorCirtification bit
);
Go

Insert Into #Course Values('C#','14 Month',1),('NT','14 Month',0),('Python','12 Month',1),('GAVE','13 Month',0);
Go

Use STMS_IsDB
Truncate Table #Course
select * from #Course

--Temporary Table (Global)
Create Table ##Cost
(
CostID int Identity Primary Key,
CostType varchar(30) not null,
Cost money
);
Go

Insert Into ##Cost Values('TSP Payment',200000),('Book Print',50000),('Employees Salary',1200000),('Vendor Exam ',5200000);
Go

select * from ##Cost











































































