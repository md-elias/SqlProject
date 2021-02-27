--Insert Values into Tables
USE STMS_IsDB
GO

Insert into RoundInfo values('One'), ('Two'), ('Three'), ('Four'), ('Five');
GO

Insert into Circular values(1,'IT Scholarship','1-1-2019','3-31-2019',1),
                           (2,'Vocational','4-1-2019','6-30-2019',1),
						   (1,'Tender','6-1-2019','8-31-2019',2)
Go

insert into TraineeInfo values('Raju','Abul Kalam','Rehana Begum','01836 851 784','Cumilla', 'raju82@gmail.com','4165657686','BBA','Islam','123451',1),
                              ('Arefin','Md Ashraful','Nova Akter','01736 851 384','Chandpur', 'arefin90@gmail.com','5165657686','MSC','Islam','123452',1),
							  ('Sayeed','Nur Kalam','Mukta Begum','01936 851 384','Chittagong', 'sayeed@gmail.com','6165657686','BBA','Islam','123453',2),
							  ('Fardu','Shamsul Arefin','Rokeya','01636 851 384','Dhaka', 'fardu@gmail.com','7165657686','MBA','Islam','123454',4),
							  ('Nehal','Md Arif','Nishita','01536 851 384','Cumilla', 'raju82@gmail.com','8165657686','BBA','Islam','123455',1)
Go

Insert Into ScheduleInfo Values('Saturday','10 AM'),('Thursday','3 PM');
GO


Insert into ExamInfo values('MCQ',1,'4-1-2019'),('Viva',1,'4-1-2019');
Go

Insert Into ExamStatus Values(1,3,60,70,1),(1,4,40,70,0),(2,5,66,80,1);
Go

Insert Into BatchInfo Values(1),(2);
GO

Insert Into TSPInfo Values('NVIT','Sholoshohor'),('Defodil Institute','Agrabad');
GO

Insert Into InstractorInfo Values('Foysal Wahid'),('Md Shorif');
GO

Insert Into BatchAssign Values(3,1),(4,2);
GO

Insert Into AttendenceStatus Values(3,'8:45 am','1:10 pm','4-1-2019'),
                                    (4,'8:45 am','1:10 pm','5-1-2019');
GO

Insert into Employees values('Md Raihan','Coordinator', '1-1-2007',100000,0,'12-31-2019',5),
                            ('Md Kader','Consaltant', '1-1-2007',75000,1,'1-1-1900',5), 
							('Mayeen Chowdhory','CM', '1-1-1996',65000,0,'12-31-2019',8),
							('Foysal Rasel','Instractor', '1-1-2016',50000,1,'1-1-1900',5)
GO

--Select Value
--=============
select * from RoundInfo
select * from Circular
select * from TraineeInfo
select * from ScheduleInfo
select * from ExamInfo
select * from ExamStatus
select * from BatchInfo
select * from TSPInfo
select * from InstractorInfo
select * from BatchAssign
select * from AttendenceStatus
select * from Employees

GO

--Inner Join
--=============
USE STMS_IsDB
GO
Select RoundInfo.RoundID,RoundInfo.RoundNo,TraineeInfo.Name,TraineeInfo.EmailID,ExamStatus.ExamID,ExamStatus.IsSelected
From RoundInfo 
Join TraineeInfo
On RoundInfo.RoundID=TraineeInfo.RoundID
Join ExamStatus
On TraineeInfo.TraineeID=ExamStatus.TraineeID
Go

--Left Outer Join
--=============
SELECT TraineeInfo.TraineeID,TraineeInfo.Name,AttendenceStatus.TraineeID,AttendenceStatus.ClassDate
FROM TraineeInfo
LEFT JOIN AttendenceStatus
ON TraineeInfo.TraineeID=AttendenceStatus.TraineeID
GO

--Right Outer Join
--=============
SELECT RoundInfo.RoundID,RoundInfo.RoundNo,TraineeInfo.Name
From RoundInfo
RIGHT JOIN TraineeInfo
ON RoundInfo.RoundID=TraineeInfo.RoundID
GO

--Full Outer Join
--===============
SELECT RoundInfo.RoundID,RoundInfo.RoundNo,TraineeInfo.Name,TraineeInfo.TraineeID,TraineeInfo.TransactionNumber
FROM RoundInfo
FULL JOIN TraineeInfo
ON RoundInfo.RoundID=TraineeInfo.RoundID
GO

--Cross Join
--=============
SELECT RoundInfo.RoundID,RoundInfo.RoundNo,TraineeInfo.Name,TraineeInfo.TraineeID,TraineeInfo.NID
FROM RoundInfo
CROSS JOIN TraineeInfo
GO

--Self Join
--=============
SELECT E.[Employee Name],E.[Is Active],F.Salary,F.[Income Tax]
FROM Employees AS E,Employees AS F
WHERE E.EmployeeID<>F.EmployeeID
GO

--Union
--=============
SELECT [EmployeeID] AS EI FROM Employees
UNION 
SELECT RoundID AS RI FROM RoundInfo
GO

--Union All
--=============
SELECT RoundID AS RID FROM RoundInfo
UNION All
SELECT TraineeID AS TID FROM TraineeInfo
GO

-- Basic Six Clauses
--====================================================================
SELECT EducationalBacground,COUNT(TraineeID) AS EDB
FROM TraineeInfo
WHERE EducationalBacground='BBA'
GROUP BY EducationalBacground
HAVING COUNT(TraineeID)>1
ORDER BY EducationalBacground DESC
GO

--Cast, Convert, Concatenation
--==================================================
SELECT 'Today :'+ CAST(GETDATE() as varchar)
SELECT 'Today :'+ CONVERT(varchar,GETDATE())

SELECT 'Today :'+ CONVERT(varchar,GETDATE(),1)
SELECT 'Today :'+ CONVERT(varchar,GETDATE(),2)
GO

--Distinct
--=============
SELECT DISTINCT RoundID,RoundNo
FROM RoundInfo
GO

--WildCard
--=============
SELECT *
FROM TraineeInfo
WHERE Name Like 'Ari___%'
GO

SELECT *
FROM Employees
WHERE [Employee Name] Like 'Foysal___d%'
GO

--Cube, Rollup, Grouping Set
--==========================
SELECT [Employee Name],EmployeeID,SUM(Salary) AS EmSL
FROM Employees
GROUP BY EmployeeID,[Employee Name] WITH CUBE
GO

SELECT [Employee Name],EmployeeID, SUM([Income Tax]) AS Tx
FROM Employees
GROUP BY EmployeeID,[Employee Name] WITH ROLLUP
GO

SELECT EmployeeID,SUM(Salary) AS EmpGr
FROM Employees
GROUP BY GROUPING SETS(
([Employee Name],EmployeeID),
([Income Tax])
)
GO

--CTE
--==============================================
WITH Employees_CTE (EmployeeID,[Employee Name],Salary)
AS
(
SELECT EmployeeID,[Employee Name],Salary
FROM Employees 
WHERE EmployeeID is not null
)
SELECT * FROM Employees_CTE
Go

--While Loop
--=============
DECLARE @l int
SET @l=10
WHILE @l<=25
BEGIN
		PRINT 'Your Provided Value : ' + CAST(@l as Varchar)
		SET @l=@l+1
END
GO
--===========================
--Logocal
--===========================
if(2=3)
	print'yes,you are right'
else
	print'no,you are wrong'
--While loop , if/else
--===================
Declare @v int=0;
While @v<6
Begin
	If @v%2=0
		Begin
			Print @v
		End
    Else
		Begin
			Print Cast(@v As varchar) + '  Throw'
		End
	Set @v=@v+1-1*2/2
	Break
End
Go

Declare @d int=10;
While @d<20
Begin
	If @d%2!=0
		Begin
			Print @d
		End
    Else
		Begin
			Print Cast(@d As varchar) + '  jump'
		End
	Set @d=@d+1-1*2/2
	Break
End
Go

--Nested Sub Query
Select * 
From Employees
Where Salary in (Select Salary From Employees Where Salary>65000) and
[Income Tax] in(Select [Income Tax] From Employees Where [Income Tax]>2000)
Go
--Create Sequence
Use STMS_IsDB
Create Sequence sq_mn_mx
As Bigint
Start With 10
Increment By 3
Minvalue 1
Maxvalue 99999
No Cycle
Cache 10
GO

--Create Sub Query
--=======================================
SELECT Sum([Income Tax]) AS TotalTax
FROM Employees
WHERE [Income Tax] in(SELECT [Income Tax] FROM Employees)
GO


--=============================
--           Case
--=============================
SELECT [EmployeeID], [Salary],
	CASE
	WHEN [Salary] >65000 THEN 'The Salary in Greater then 65000'
	WHEN [Salary]=65000 THEN 'The Salary is 65000'
	ELSE 'The Salary in Lower then 65000'
END	AS GetSalary 
FROM Employees
GO

--==================
--     Operator
--==================
SELECT 50+9 AS [Sum]
GO
SELECT 140-9 AS [Substraction]
GO
SELECT 340*9 AS [Multiplication]
GO
SELECT 400/10 AS [Divide]
GO
SELECT 40%9 AS [Remainder]
GO

--====================
--Aggregate function
--====================
SELECT COUNT (*) FROM Employees
SELECT AVG (Salary) FROM Employees
SELECT MIN ([Income Tax]) FROM Employees
SELECT MAX (Salary) FROM Employees

--=====================
--Transaction
--=====================
BEGIN TRAN
DELETE FROM Employees
WHERE [Employee Name]='Foysal Wahid'
GO

BEGIN TRAN
INSERT INTO Employees VALUES('Md Anis','GM', '1-1-2007',100000,0,'12-31-2019',8)
GO

ROLLBACK TRAN;
GO

BEGIN TRAN
DELETE FROM Employees
WHERE [Employee Name]='Foysal Wahid'
COMMIT TRAN
GO

--====================
--Round,Ceiling,Floor
--====================
DECLARE @value int;
SET @value= -20;
SELECT ROUND (@value,3);
SELECT CEILING (@value);
SELECT FLOOR (@value);
GO

