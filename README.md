# SQL-Server-sqls

:fireworks: [1-4](#1-4) Constraints <br />
:fireworks: [5-7](#5-7) Constraints, Identity <br />
:fireworks: [8-21](#8-21) Primary Key, Unique Key, like, helptext, depends <br />
:fireworks: [22-24](#22-24) Built-in functions <br />
:fireworks: [25-27](#25-27) functions <br />
:fireworks: [27ageCalcFunction](#27agecalcfunction) <br />
:fireworks: [28-29](#28-29) Mathematical functions <br />
:fireworks: [30-33](#30-33) Inline table function <br />
:fireworks: [34](#34) Temporary tables <br />
:fireworks: [35](#35) Indexes <br />

## 1-4
```sql
select @@version as 'sql server version'

--Whether, you create a database graphically using the designer or, using a query, the following 2 files gets generated.
--.MDF file - Data File (Contains actual data)
--.LDF file - Transaction Log file (Used to recover the database)

--To alter a database, once it's created 
Alter database DatabaseName Modify Name = NewDatabaseName

--Alternatively, you can also use system stored procedure
Execute sp_renameDB 'OldDatabaseName','NewDatabaseName'

--To Delete or Drop a database
Drop Database DatabaseThatYouWantToDrop

--Dropping a database, deletes the LDF and MDF files.

--To add a foreign key reference using a query
Alter table tblPerson 
add constraint tblPerson_GenderId_FK 
FOREIGN KEY (GenderId) references tblGender(ID)

--Altering an existing column to add a default constraint:
ALTER TABLE { TABLE_NAME }
ADD CONSTRAINT { CONSTRAINT_NAME }
DEFAULT { DEFAULT_VALUE } FOR { EXISTING_COLUMN_NAME }

--Adding a new column, with default value, to an existing table:
ALTER TABLE { TABLE_NAME } 
ADD { COLUMN_NAME } { DATA_TYPE } { NULL | NOT NULL } 
CONSTRAINT { CONSTRAINT_NAME } 
DEFAULT { DEFAULT_VALUE }

--The following command will add a default constraint, DF_tblPerson_GenderId.
ALTER TABLE tblPerson
ADD CONSTRAINT DF_tblPerson_GenderId
DEFAULT 1 FOR GenderId

--To drop a constraint
ALTER TABLE { TABLE_NAME } 
DROP CONSTRAINT { CONSTRAINT_NAME }
```

## 5-7
```sql
--Cascading referential integrity
--1. No Action
--2. Cascade
--3. Set NULL
--4. Set Default

--highlight the table and press alt + f1 to see table details

--check constraint
--The following check constraint, limits the age between ZERO and 150.
ALTER TABLE tblPerson
ADD CONSTRAINT CK_tblPerson_Age CHECK (Age > 0 AND Age < 150)

--To drop the CHECK constraint:
ALTER TABLE tblPerson
DROP CONSTRAINT CK_tblPerson_Age

--identity; first param is seed second is increment
--Seed and Increment values are optional. If you don't specify the identity and seed they both default to 1.
Create Table tblPerson
(
PersonId int Identity(1,1) Primary Key,
Name nvarchar(20)
)

SET Identity_Insert tblPerson ON
Insert into tblPerson(PersonId, Name) values(2, 'John')
--As long as the Identity_Insert is turned on for a table, you need to explicitly provide the value for that column.

--After, you have the gaps in the identity column filled, and if you wish SQL server to calculate the value, turn off 
--Identity_Insert.
SET Identity_Insert tblPerson OFF

--If you have deleted all the rows in a table, and you want to reset the identity column value, use DBCC CHECKIDENT 
--command. This command will reset PersonId identity column.
DBCC CHECKIDENT(tblPerson, RESEED, 0)
```

## 8-21
```sql
--In brief:
--SCOPE_IDENTITY() - returns the last identity value that is created in the same session and in the same scope.
--@@IDENTITY - returns the last identity value that is created in the same session and across any scope.
--IDENT_CURRENT('TableName') - returns the last identity value that is created for a specific table across any 
--session and any scope.

--To create the unique key using a query:
Alter Table Table_Name
Add Constraint Constraint_Name Unique(Column_Name)

--Both primary key and unique key are used to enforce, the uniqueness of a column.
--A table can have, only one primary key. If you want to enforce uniqueness on 2 or more columns,
-- then we use unique key constraint.

--What is the difference between Primary key constraint and Unique key constraint? This question is asked very frequently in interviews.
--1. A table can have only one primary key, but more than one unique key
--2. Primary key does not allow nulls, where as unique key allows one null

--To drop the constraint
--Using a query
Alter Table tblPerson
Drop Constraint UQ_tblPerson_Email

select * from tblPerson where name like '[MST]%' --begins with M or S or T
select * from tblPerson where name like '^[MST]%' -- not begins with M or S or T
select * from tblPerson where name like '_@_.com' -- _ specify character
-- % specifies zero or more characters

--select top 10 Percent *...

--UNION ALL combines all
--UNION combines removing duplicates

--Display estimated execution plan in SSMS to show union distinct sort

execute sp_helptext SP_Name --showing procedure source code
execute sp_depends SP_Name
--View the dependencies of the stored procedure. This system SP is very useful, especially if you want to check, 
--if there are any stored procedures that are referencing a table that you are abput to drop. 
--sp_depends can also be used with other database objects like table etc.

--When we execute procedure, then SQL server do these things:
--1. Check syntax of the query
--2. Compile the query
--3. Generates the execution plan
--Execution plan is reused when execution happen again

--Advantages of using stored procedures

--1. Execution plan retention and reusability - Stored Procedures are compiled and their execution plan is cached and used again, when the same 
--SP is executed again. Although adhoc queries also create and reuse plan, the plan is reused only when the query is textual match and the datatypes 
--are matching with the previous call. Any change in the datatype or you have an extra space in the query then, a new plan is created.

--2. Reduces network traffic - You only need to send, EXECUTE SP_Name statement, over the network, instead of the entire batch of adhoc SQL code.

--3. Code reusability and better maintainability - A stored procedure can be reused with multiple applications. If the logic has to change, we only have one place 
--to change, where as if it is inline sql, and if you have to use it in multiple applications, we end up with multiple copies of this inline sql. If the logic has to 
--change, we have to change at all the places, which makes it harder maintaining inline sql.

--4. Better Security - A database user can be granted access to an SP and prevent them from executing direct "select" statements against a table.  
--This is fine grain access control which will help control what data a user has access to.

--5. Avoids SQL Injection attack - SP's prevent sql injection attack. Please watch this video on SQL Injection Attack, for more information.
```

## 22-24
```sql
--Example: 
Select ASCII('A')
--Output: 65

--CHAR(Integer_Expression) - Converts an int ASCII code to a character. The Integer_Expression, should be between 0 and 255.
--The following SQL, prints all the characters for the ASCII values from o thru 255

Declare @Number int
Set @Number = 1
While(@Number <= 255)
Begin
 Print CHAR(@Number)
 Set @Number = @Number + 1
End

Select LTRIM('   Hello') --Output: Hello
Select RTRIM('Hello   ') --Output: Hello
Select LTRIM(RTRIM('   Hello   ')) --Output: Hello
Select LOWER('CONVERT This String Into Lower Case') --Output: convert this string into lower case
Select UPPER('CONVERT This String Into upper Case') --Output: CONVERT THIS STRING INTO UPPER CASE
Select REVERSE('ABCDEFGHIJKLMNOPQRSTUVWXYZ') --Output: ZYXWVUTSRQPONMLKJIHGFEDCBA
Select LEN('SQL Functions   ') --Output: 13
Select LEFT('ABCDE', 3) --Output: ABC
Select RIGHT('ABCDE', 3) --Output: CDE
Select CHARINDEX('@','sara@aaa.com',1) --Output: 5
Select SUBSTRING('John@bbb.com',6, 7) --Output: bbb.com
Select SUBSTRING('John@bbb.com',(CHARINDEX('@', 'John@bbb.com') + 1), (LEN('John@bbb.com') - CHARINDEX('@','John@bbb.com'))) --Output: bbb.com
SELECT REPLICATE('Pragim', 3) --Output: Pragim Pragim Pragim 
SELECT SPACE(5) + 'abc' --Output:     abc
Select PATINDEX('%@aaa.com', 'qwerty@aaa.com') as FirstOccurence --Output: 7
Select REPLACE('qwerty@aaa.com', '.com', '.net') as ConvertedEmail --Output: qwerty@aaa.net
Select STUFF('qwerty@aaa.com', 2, 3, '*****') as StuffedEmail --Output: q*****ty@aaa.com
```

## 25-27
```sql
--Note: UTC stands for Coordinated Universal Time, based on which, the world regulates clocks and time. There are slight differences 
--between GMT and UTC, but for most common purposes, UTC is synonymous with GMT. 

--Function	          Date Time Format	                    Description
GETDATE()	        --2012-08-31 20:15:04.543	            Commonly used function
CURRENT_TIMESTAMP	--2012-08-31 20:15:04.543	            ANSI SQL equivalent to GETDATE
SYSDATETIME()	    --2012-08-31 20:15:04.5380028	        More fractional seconds precision
SYSDATETIMEOFFSET()	--2012-08-31 20:15:04.5380028 + 01:00	More fractional seconds precision + Time zone offset
GETUTCDATE()	    --2012-08-31 19:15:04.543	            UTC Date and Time
SYSUTCDATETIME()	--2012-08-31 19:15:04.5380028	        UTC Date and Time, with More fractional seconds precision

select ISDATE('pragim') --0
select ISDATE(getdate()) --1
Select ISDATE('2012-08-31 21:02:04.167') -- returns 1
--Note: For datetime2 values, IsDate returns ZERO.
Select ISDATE('2012-09-01 11:34:21.1918447') -- returns 0.

Select DAY(GETDATE()) -- Returns the day number of the month, based on current system datetime.
Select DAY('01/31/2012') -- Returns 31
Select Month(GETDATE()) -- Returns the Month number of the year, based on the current system date and time
Select Month('01/31/2012') -- Returns 1
Select Year(GETDATE()) -- Returns the year number, based on the current system date
Select Year('01/31/2012') -- Returns 2012

Select DATENAME(DAY, '2019-12-10 12:43:46.837') -- Returns 10
Select DATENAME(WEEKDAY, '2019-12-10 12:43:46.837') -- Returns Tuesday
Select DATENAME(MONTH, '2019-12-10 12:43:46.837') -- Returns December
Select DATENAME(QUARTER, '2019-12-10 12:43:46.837') -- Returns 4
Select DATENAME(DAYOFYEAR, '2019-12-10 12:43:46.837') -- Returns 344

Select DATEPART(weekday, '2019-12-10 19:45:31.793') -- returns 3
Select DATENAME(weekday, '2019-12-10 19:45:31.793') -- returns Tuesday

Select DateAdd(DAY, 20, '2012-08-30 19:45:31.793') -- Returns 2012-09-19 19:45:31.793
Select DateAdd(DAY, -20, '2012-08-30 19:45:31.793') -- Returns 2012-08-10 19:45:31.793

Select DATEDIFF(MONTH, '11/30/2005','01/31/2006') -- returns 2
Select DATEDIFF(DAY, '11/30/2005','01/31/2006') -- returns 62
```

## 27ageCalcFunction
```sql
DECLARE @DOB DATETIME
SET @DOB = '1993-07-11 19:45:31.793'

DECLARE @years INT, @months INT, @days INT

SET @years = DATEDIFF(YEAR, @DOB, GETDATE()) - IIF((MONTH(@DOB) >= MONTH(GETDATE())) AND DAY(@DOB) > DAY(GETDATE()), 1, 0)
SET @DOB = DATEADD(YEAR, @years, @DOB)

SET @months = DATEDIFF(MONTH, @DOB, GETDATE()) - IIF(DAY(@DOB) > DAY(GETDATE()), 1, 0)
SET @DOB = DATEADD(MONTH, @months, @DOB)

SET @days = DATEDIFF(DAY, @DOB, GETDATE())

SELECT Cast(@years AS  NVARCHAR(4)) + ' Years ' + 
       Cast(@months AS  NVARCHAR(2))+ ' Months ' +  
       Cast(@days AS  NVARCHAR(2))+ ' Days Old'

--Better use SET than select, since SET will throw error when multiple values
--When using SELECT, the variable is assigned the last value that is returned

--simple
select CAST(DATEDIFF(day, @DOB, GETDATE()) / 365.242199 AS decimal(10,2))  
```

## 28-29
```sql
Select '1993-07-11 19:45:31.793', Convert(nvarchar, '1993-07-11 19:45:31.793', 103) as ConvertedDOB

Select ABS(-101.5) -- returns 101.5, without the - sign.
Select CEILING(15.2) -- Returns 16
Select CEILING(-15.2) -- Returns -15
Select FLOOR(15.2) -- Returns 15
Select FLOOR(-15.2) -- Returns -16
Select POWER(2,3) -- Returns 8
Select RAND(1) -- Always returns the same value

--If you want to generate a random number between 1 and 100, RAND() and FLOOR() functions can 
--be used as shown below. Every time, you execute this query, you get a random number between 1 and 100.
Select FLOOR(RAND() * 100)

--The following query prints 10 random numbers between 1 and 100.
Declare @Counter INT
Set @Counter = 1
While(@Counter <= 10)
Begin
 Print FLOOR(RAND() * 100)
 Set @Counter = @Counter + 1
End

Select SQUARE(9) -- Returns 81
Select SQRT(81) -- Returns 9

--ROUND ( numeric_expression , length [ ,function ] ) - Rounds the given numeric expression based on the given length. This function takes 3 parameters. 
--1. Numeric_Expression is the number that we want to round.
--2. Length parameter, specifies the number of the digits that we want to round to. If the length is a positive number, 
--then the rounding is applied for the decimal part, where as if the length is negative, then the rounding is applied to the number before the decimal.
--3. The optional function parameter, is used to indicate rounding or truncation operations. A value of 0, indicates rounding, 
--where as a value of non zero indicates truncation. Default, if not specified is 0.

--Examples:
-- Round to 2 places after (to the right) the decimal point
Select ROUND(850.556, 2) -- Returns 850.560
-- Truncate anything after 2 places, after (to the right) the decimal point
Select ROUND(850.556, 2, 1) -- Returns 850.550
-- Round to 1 place after (to the right) the decimal point
Select ROUND(850.556, 1) -- Returns 850.600
-- Truncate anything after 1 place, after (to the right) the decimal point
Select ROUND(850.556, 1, 1) -- Returns 850.500
-- Round the last 2 places before (to the left) the decimal point
Select ROUND(850.556, -2) -- 900.000
-- Round the last 1 place before (to the left) the decimal point
Select ROUND(850.556, -1) -- 850.000
```

## 30-33
```sql
--Syntax for creating an inline table valued function
CREATE FUNCTION fn_EmployeesByGender(@Gender nvarchar(10))
RETURNS TABLE
AS
RETURN (Select Id, Name, DateOfBirth, Gender, DepartmentId
      from tblEmployees
      where Gender = @Gender)
      
--If you look at the way we implemented this function, it is very similar to SCALAR function, with the following differences
--1. We specify TABLE as the return type, instead of any scalar data type
--2. The function body is not enclosed between BEGIN and END block. Inline table valued function body, cannot have BEGIN and END block.
--3. The structure of the table that gets returned, is determined by the SELECT statement with in the function.

--Calling the user defined function
Select * from fn_EmployeesByGender('Male')

--Where can we use Inline Table Valued functions
--1. Inline Table Valued functions can be used to achieve the functionality of parameterized views. We will talk about views, in a later session.
--2. The table returned by the table valued function, can also be used in joins with other tables.

--Deterministic and Nondeterministic Functions:
--Deterministic functions always return the same result any time they are called with a specific set of input values and given the same state of the database. 
--Examples: Sum(), AVG(), Square(), Power() and Count()

--Note: All aggregate functions are deterministic functions.

--Nondeterministic functions may return different results each time they are called with a specific set of input values even if the database state that they access remains the same.
--Examples: GetDate() and CURRENT_TIMESTAMP

--Rand() function is a Non-deterministic function, but if you provide the seed value, the function becomes deterministic, as the same value gets returned for the same seed value.

--below schema binding prevents dropping source table
Alter Function fn_GetEmployeeNameById(@Id int)
Returns nvarchar(20)
With SchemaBinding
as
Begin
 Return (Select Name from dbo.tblEmployees Where Id = @Id)
End
```

## 34
```sql
--How to check if the local temporary table is created
--Temporary tables are created in the TEMPDB. Query the sysobjects system table in TEMPDB. The name of the table, is suffixed 
--with lot of underscores and a random number. For this reason you have to use the LIKE operator in the query.
Select name from tempdb..sysobjects 
where name like '#PersonDetails%'

--How to Create a Global Temporary Table:
--To create a Global Temporary Table, prefix the name of the table with 2 pound (##) symbols. 
--EmployeeDetails Table is the global temporary table, as we have prefixed it with 2 ## symbols.
--Create Table ##EmployeeDetails(Id int, Name nvarchar(20))

--Global temporary tables are visible to all the connections of the sql server, and are only destroyed when the last connection referencing the table is closed.
```

## 35
```sql
--Let's Create the Index to help the query:Here, we are creating an index on Salary column in the employee table
CREATE Index IX_tblEmployee_Salary 
ON tblEmployee (SALARY ASC) --Non-unique, Non-clustered

--To view the Indexes: In the object explorer, expand Indexes folder. 
--Alternatively use sp_helptext system stored procedure. The following command query returns all the indexes on tblEmployee table.
execute sp_helpindex tblEmployee

--To delete or drop the index: When dropping an index, specify the table name as well
Drop Index tblEmployee.IX_tblEmployee_Salary

--Clustered index defines physical order of date in table (firstly by Gender, secondly by Salary)
Create Clustered Index IX_tblEmployee_Gender_Salary
ON tblEmployee(Gender DESC, Salary ASC)

--Difference between Clustered and NonClustered Index:
--1. Only one clustered index per table, where as you can have more than one non clustered index
--2. Clustered index is faster than a non clustered index, because, the non-clustered index has to refer back to the table, if the selected column is not present in the index.
--3. Clustered index determines the storage order of rows in the table, and hence doesn't require additional disk space, but where as a Non Clustered index is stored seperately 
--from the table, additional storage space is required.
```