# SQL-Server-sqls
From kudvenkat tutorial

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
:fireworks: [36-38](#36-38) Indexes continued <br />
:fireworks: [39-51](#39-51) Views <br />
:fireworks: [52-62](#52-62) Normalization, transactions <br />
:fireworks: [63-77](#63-77) Cursors, transaction isolation levels <br />
:fireworks: [78-86](#78-86) Deadlocks <br />
:fireworks: [87-91](#87-91) Unions, cross apply, outer apply <br />
:fireworks: [92-106](#92-106) Trigger, Where != Having, Grouping sets, rollup, cube, grouping, grouping id <br />
:fireworks: [107-117](#107-117) over, row_number, rank, dense_rank, ntile, lead, lag, first_value <br />
:fireworks: [118-129](#118-129) Last_value, unpivot, choose, try_convert, try_parse, eomonth, datefromparts, datetime2fromparts <br />
:fireworks: [130-137](#130-137) sp_depends alternative, GUID <br />
:fireworks: [138-144](#138-144) query plans, execute <br />
:fireworks: [145-149](#145-149) quotename function, temp tables note <br />


## 1-4

--Whether, you create a database graphically using the designer or, using a query, the following 2 files gets generated.
--.MDF file - Data File (Contains actual data)
--.LDF file - Transaction Log file (Used to recover the database)

```sql
SELECT @@VERSION AS 'sql server version'

--To alter a database, once it's created 
ALTER DATABASE DatabaseName MODIFY Name = NewDatabaseName

--Alternatively, you can also use system stored procedure
EXECUTE SP_RENAMEDB 'OldDatabaseName','NewDatabaseName'

--To Delete or Drop a database
DROP DATABASE DatabaseThatYouWantToDrop

--Dropping a database, deletes the LDF and MDF files.

--To add a foreign key reference using a query
ALTER TABLE tblPerson 
ADD CONSTRAINT tblPerson_GenderId_FK 
FOREIGN KEY (GenderId) REFERENCES tblGender(ID)

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

--Cascading referential integrity
--1. No Action
--2. Cascade
--3. Set NULL
--4. Set Default

--highlight the table and press alt + f1 to see table details

```sql
--check constraint
--The following check constraint, limits the age between ZERO and 150.
ALTER TABLE tblPerson
ADD CONSTRAINT CK_tblPerson_Age CHECK (Age > 0 AND Age < 150)

--To drop the CHECK constraint:
ALTER TABLE tblPerson
DROP CONSTRAINT CK_tblPerson_Age

--identity; first param is seed second is increment
--Seed and Increment values are optional. If you don't specify the identity and seed they both default to 1.
CREATE TABLE tblPerson
(
PersonId int Identity(1,1) Primary Key,
Name nvarchar(20)
)

SET Identity_Insert tblPerson ON
INSERT INTO tblPerson(PersonId, Name) VALUES (2, 'John')
--As long as the Identity_Insert is turned on for a table, you need to explicitly provide the value for that column.

--After, you have the gaps in the identity column filled, and if you wish SQL server to calculate the value, turn off 
--Identity_Insert.
SET Identity_Insert tblPerson OFF7

--If you have deleted all the rows in a table, and you want to reset the identity column value, use DBCC CHECKIDENT 
--command. This command will reset PersonId identity column.
DBCC CHECKIDENT(tblPerson, RESEED, 0)
```

## 8-21

--In brief:
--SCOPE_IDENTITY() - returns the last identity value that is created in the same session and in the same scope.
--@@IDENTITY - returns the last identity value that is created in the same session and across any scope.
--IDENT_CURRENT('TableName') - returns the last identity value that is created for a specific table across any 
--session and any scope.

--Both primary key and unique key are used to enforce, the uniqueness of a column.
--A table can have, only one primary key. If you want to enforce uniqueness on 2 or more columns,
-- then we use unique key constraint.

--What is the difference between Primary key constraint and Unique key constraint? This question is asked very frequently in interviews.
--1. A table can have only one primary key, but more than one unique key
--2. Primary key does not allow nulls, where as unique key allows one null

```sql

--To create the unique key using a query:
ALTER TABLE Table_Name
ADD CONSTRAINT Constraint_Name UNIQUE(Column_Name)

--To drop the constraint
--Using a query
ALTER TABLE tblPerson
DROP CONSTRAINT UQ_tblPerson_Email

SELECT * FROM tblPerson WHERE name LIKE '[MST]%' --begins with M or S or T
SELECT * FROM tblPerson WHERE name LIKE '^[MST]%' -- not begins with M or S or T
SELECT * FROM tblPerson WHERE name LIKE '_@_.com' -- _ specify character
-- % specifies zero or more characters

--select top 10 Percent *...

--UNION ALL combines all
--UNION combines removing duplicates

--Display estimated execution plan in SSMS to show union distinct sort

EXECUTE SP_HELPTEXT SP_Name --showing procedure source code
EXECUTE SP_DEPENDS SP_Name
--View the dependencies of the stored procedure. This system SP is very useful, especially if you want to check, 
--if there are any stored procedures that are referencing a table that you are abput to drop. 
--sp_depends can also be used with other database objects like table etc.

```

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

## 22-24
```sql
--Example: 
SELECT ASCII('A')
--Output: 65

--CHAR(Integer_Expression) - Converts an int ASCII code to a character. The Integer_Expression, should be between 0 and 255.
--The following SQL, prints all the characters for the ASCII values from o thru 255

DECLARE @Number INT
SET @Number = 1
WHILE(@Number <= 255)
BEGIN
 PRINT CHAR(@Number)
 SET @Number = @Number + 1
END

SELECT LTRIM('   Hello') --Output: Hello
SELECT RTRIM('Hello   ') --Output: Hello
SELECT LTRIM(RTRIM('   Hello   ')) --Output: Hello
SELECT LOWER('CONVERT This String Into Lower Case') --Output: convert this string into lower case
SELECT UPPER('CONVERT This String Into upper Case') --Output: CONVERT THIS STRING INTO UPPER CASE
SELECT REVERSE('ABCDEFGHIJKLMNOPQRSTUVWXYZ') --Output: ZYXWVUTSRQPONMLKJIHGFEDCBA
SELECT LEN('SQL Functions   ') --Output: 13
SELECT LEFT('ABCDE', 3) --Output: ABC
SELECT RIGHT('ABCDE', 3) --Output: CDE
SELECT CHARINDEX('@','sara@aaa.com',1) --Output: 5
SELECT SUBSTRING('John@bbb.com',6, 7) --Output: bbb.com
SELECT SUBSTRING('John@bbb.com',(CHARINDEX('@', 'John@bbb.com') + 1), (LEN('John@bbb.com') - CHARINDEX('@','John@bbb.com'))) --Output: bbb.com
SELECT REPLICATE('Pragim', 3) --Output: Pragim Pragim Pragim 
SELECT SPACE(5) + 'abc' --Output:     abc
SELECT PATINDEX('%@aaa.com', 'qwerty@aaa.com') as FirstOccurence --Output: 7
SELECT REPLACE('qwerty@aaa.com', '.com', '.net') as ConvertedEmail --Output: qwerty@aaa.net
SELECT STUFF('qwerty@aaa.com', 2, 3, '*****') as StuffedEmail --Output: q*****ty@aaa.com
```

## 25-27

--Note: UTC stands for Coordinated Universal Time, based on which, the world regulates clocks and time. There are slight differences 
--between GMT and UTC, but for most common purposes, UTC is synonymous with GMT. 

```sql

--Function	          Date Time Format	                    Description
GETDATE()	        --2012-08-31 20:15:04.543	            Commonly used function
CURRENT_TIMESTAMP	--2012-08-31 20:15:04.543	            ANSI SQL equivalent to GETDATE
SYSDATETIME()	    --2012-08-31 20:15:04.5380028	        More fractional seconds precision
SYSDATETIMEOFFSET()	--2012-08-31 20:15:04.5380028 + 01:00	More fractional seconds precision + Time zone offset
GETUTCDATE()	    --2012-08-31 19:15:04.543	            UTC Date and Time
SYSUTCDATETIME()	--2012-08-31 19:15:04.5380028	        UTC Date and Time, with More fractional seconds precision

SELECT ISDATE('pragim') --0
SELECT ISDATE(getdate()) --1
SELECT ISDATE('2012-08-31 21:02:04.167') -- returns 1
--Note: For datetime2 values, IsDate returns ZERO.
SELECT ISDATE('2012-09-01 11:34:21.1918447') -- returns 0.

SELECT DAY(GETDATE()) -- Returns the day number of the month, based on current system datetime.
SELECT DAY('01/31/2012') -- Returns 31
SELECT MONTH(GETDATE()) -- Returns the Month number of the year, based on the current system date and time
SELECT MONTH('01/31/2012') -- Returns 1
SELECT YEAR(GETDATE()) -- Returns the year number, based on the current system date
SELECT YEAR('01/31/2012') -- Returns 2012

SELECT DATENAME(DAY, '2019-12-10 12:43:46.837') -- Returns 10
SELECT DATENAME(WEEKDAY, '2019-12-10 12:43:46.837') -- Returns Tuesday
SELECT DATENAME(MONTH, '2019-12-10 12:43:46.837') -- Returns December
SELECT DATENAME(QUARTER, '2019-12-10 12:43:46.837') -- Returns 4
SELECT DATENAME(DAYOFYEAR, '2019-12-10 12:43:46.837') -- Returns 344

SELECT DATEPART(weekday, '2019-12-10 19:45:31.793') -- returns 3
SELECT DATENAME(weekday, '2019-12-10 19:45:31.793') -- returns Tuesday

SELECT DATEADD(DAY, 20, '2012-08-30 19:45:31.793') -- Returns 2012-09-19 19:45:31.793
SELECT DATEADD(DAY, -20, '2012-08-30 19:45:31.793') -- Returns 2012-08-10 19:45:31.793

SELECT DATEDIFF(MONTH, '11/30/2005','01/31/2006') -- returns 2
SELECT DATEDIFF(DAY, '11/30/2005','01/31/2006') -- returns 62
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
SELECT CAST(DATEDIFF(day, @DOB, GETDATE()) / 365.242199 AS decimal(10,2))  
```

## 28-29
```sql
SELECT '1993-07-11 19:45:31.793', Convert(nvarchar, '1993-07-11 19:45:31.793', 103) as ConvertedDOB

SELECT ABS(-101.5) -- returns 101.5, without the - sign.
SELECT CEILING(15.2) -- Returns 16
SELECT CEILING(-15.2) -- Returns -15
SELECT FLOOR(15.2) -- Returns 15
SELECT FLOOR(-15.2) -- Returns -16
SELECT POWER(2,3) -- Returns 8
SELECT RAND(1) -- Always returns the same value

--If you want to generate a random number between 1 and 100, RAND() and FLOOR() functions can 
--be used as shown below. Every time, you execute this query, you get a random number between 1 and 100.
SELECT FLOOR(RAND() * 100)

--The following query prints 10 random numbers between 1 and 100.
DECLARE @Counter INT
SET @Counter = 1
WHILE(@Counter <= 10)
BEGIN
 PRINT FLOOR(RAND() * 100)
 SET @Counter = @Counter + 1
END

SELECT SQUARE(9) -- Returns 81
SELECT SQRT(81) -- Returns 9

--ROUND ( numeric_expression , length [ ,function ] ) - Rounds the given numeric expression based on the given length. This function takes 3 parameters. 
--1. Numeric_Expression is the number that we want to round.
--2. Length parameter, specifies the number of the digits that we want to round to. If the length is a positive number, 
--then the rounding is applied for the decimal part, where as if the length is negative, then the rounding is applied to the number before the decimal.
--3. The optional function parameter, is used to indicate rounding or truncation operations. A value of 0, indicates rounding, 
--where as a value of non zero indicates truncation. Default, if not specified is 0.

--Examples:
-- Round to 2 places after (to the right) the decimal point
SELECT ROUND(850.556, 2) -- Returns 850.560
-- Truncate anything after 2 places, after (to the right) the decimal point
SELECT ROUND(850.556, 2, 1) -- Returns 850.550
-- Round to 1 place after (to the right) the decimal point
SELECT ROUND(850.556, 1) -- Returns 850.600
-- Truncate anything after 1 place, after (to the right) the decimal point
SELECT ROUND(850.556, 1, 1) -- Returns 850.500
-- Round the last 2 places before (to the left) the decimal point
SELECT ROUND(850.556, -2) -- 900.000
-- Round the last 1 place before (to the left) the decimal point
SELECT ROUND(850.556, -1) -- 850.000
```

## 30-33
```sql
--Syntax for creating an inline table valued function
CREATE FUNCTION fn_EmployeesByGender(@Gender nvarchar(10))
RETURNS TABLE
AS
RETURN (SELECT Id, Name, DateOfBirth, Gender, DepartmentId
      FROM tblEmployees
      WHERE Gender = @Gender)
      
--If you look at the way we implemented this function, it is very similar to SCALAR function, with the following differences
--1. We specify TABLE as the return type, instead of any scalar data type
--2. The function body is not enclosed between BEGIN and END block. Inline table valued function body, cannot have BEGIN and END block.
--3. The structure of the table that gets returned, is determined by the SELECT statement with in the function.

--Calling the user defined function
SELECT * FROM fn_EmployeesByGender('Male')

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
ALTER FUNCTION fn_GetEmployeeNameById(@Id int)
RETURNS nvarchar(20)
WITH SchemaBinding
AS
BEGIN
 RETURN (SELECT Name FROM dbo.tblEmployees WHERE Id = @Id)
END
```

## 34
```sql
--How to check if the local temporary table is created
--Temporary tables are created in the TEMPDB. Query the sysobjects system table in TEMPDB. The name of the table, is suffixed 
--with lot of underscores and a random number. For this reason you have to use the LIKE operator in the query.
SELECT name FROM tempdb..sysobjects 
WHERE name LIKE '#PersonDetails%'

--How to Create a Global Temporary Table:
--To create a Global Temporary Table, prefix the name of the table with 2 pound (##) symbols. 
--EmployeeDetails Table is the global temporary table, as we have prefixed it with 2 ## symbols.
--Create Table ##EmployeeDetails(Id int, Name nvarchar(20))

--Global temporary tables are visible to all the connections of the sql server, and are only destroyed when the last connection referencing the table is closed.
```

## 35
```sql
--Let's Create the Index to help the query:Here, we are creating an index on Salary column in the employee table
CREATE INDEX IX_tblEmployee_Salary 
ON tblEmployee (SALARY ASC) --Non-unique, Non-clustered

--To view the Indexes: In the object explorer, expand Indexes folder. 
--Alternatively use sp_helptext system stored procedure. The following command query returns all the indexes on tblEmployee table.
EXECUTE SP_HELPINDEX tblEmployee

--To delete or drop the index: When dropping an index, specify the table name as well
DROP INDEX tblEmployee.IX_tblEmployee_Salary

--Clustered index defines physical order of date in table (firstly by Gender, secondly by Salary)
CREATE CLUSTERED INDEX IX_tblEmployee_Gender_Salary
ON tblEmployee(Gender DESC, Salary ASC)

--Difference between Clustered and NonClustered Index:
--1. Only one clustered index per table, where as you can have more than one non clustered index
--2. Clustered index is faster than a non clustered index, because, the non-clustered index has to refer back to the table, if the selected column is not present in the index.
--3. Clustered index determines the storage order of rows in the table, and hence doesn't require additional disk space, but where as a Non Clustered index is stored seperately 
--from the table, additional storage space is required.
```

## 36-38
```sql

--Creating a UNIQUE NON CLUSTERED index on the FirstName and LastName columns.
CREATE UNIQUE NONCLUSTERED INDEX UIX_tblEmployee_FirstName_LastName
On tblEmployee(FirstName, LastName)

--This unique non clustered index, ensures that no 2 entires in the index has the same first and last names. In Part 9, of this video series, 
--we have learnt that, a Unique Constraint, can be used to enforce the uniqueness of values, across one or more columns. There are no major 
--differences between a unique constraint and a unique index. 

--In fact, when you add a unique constraint, a unique index gets created behind the scenes. To prove this, 
--let's add a unique constraint on the city column of the tblEmployee table.
ALTER TABLE tblEmployee 
ADD CONSTRAINT UQ_tblEmployee_City 
UNIQUE NONCLUSTERED (City)

--executing 
EXECUTE SP_HELPCONSTRAINT tblEmployee
--, lists the constraint as a UNIQUE NONCLUSTERED index.

--Diadvantages of Indexes:
--Additional Disk Space: Clustered Index does not, require any additional storage. Every Non-Clustered index requires additional space as it 
--is stored separately from the table.The amount of space required will depend on the size of the table, and the number and types of columns used in the index.

--Insert Update and Delete statements can become slow: When DML (Data Manipulation Language) statements (INSERT, UPDATE, DELETE) modifies data in a 
--table, the data in all the indexes also needs to be updated. Indexes can help, to search and locate the rows, that we want to delete, but too many indexes 
--to update can actually hurt the performance of data modifications.

--What is a covering query?
--If all the columns that you have requested in the SELECT clause of query, are present in the index, then there is no need to lookup in the table again. 
--The requested columns data can simply be returned from the index.

--A clustered index, always covers a query, since it contains all of the data in a table. A composite index is an index on two or more columns. Both clustered 
--and nonclustered indexes can be composite indexes. To a certain extent, a composite index, can cover a query.

```
## 39-51
```sql
--when you create an index, on a view, the view gets materialized. This means, the view is now, 
--capable of storing data. In SQL server, we call them Indexed views and in Oracle, Materialized views.
--Script to create view vWTotalSalesByProduct

Create view vWTotalSalesByProduct
with SchemaBinding --it protects from table deletion
as
	Select Name, 
		   SUM(ISNULL((QuantitySold * UnitPrice), 0)) as TotalSales, 
	       COUNT_BIG(*) as TotalTransactions
	from dbo.tblProductSales
	join dbo.tblProduct
	on dbo.tblProduct.ProductId = dbo.tblProductSales.ProductId
	group by Name
	
Create Unique Clustered Index UIX_vWTotalSalesByProduct_Name
on vWTotalSalesByProduct(Name)

--Since, we now have an index on the view, the view gets materialized. The data is stored in the view.

--Indexed views are ideal for scenarios, where the underlying data is not frequently changed. Indexed views 
--are more often used in OLAP systems, because the data is mainly used for reporting and analysis purposes. 
--Indexed views, may not be suitable for OLTP systems, as the data is frequently addedd and changed.

--You cannot order by in view definition
--Views cannot be based on temporary tables (functions either)
```
## 52-62
```sql
--Database normalization is the process of organizing data to minimize data redundancy (data duplication), which in turn ensures data consistency.
--Now, let's explore the first normal form (1NF). A table is said to be in 1NF, if
--1. The data in each column should be atomic. No multiple values, sepearated by comma.
--2. The table does not contain any repeating column groups
--3. Identify each record uniquely using primary key.

--A table is said to be in 2NF, if
--1. The table meets all the conditions of 1NF
--2. Move redundant data to a separate table
--3. Create relationship between these tables using foreign keys.

--A table is said to be in 3NF, if the table
--1. Meets all the conditions of 1NF and 2NF
--2. Does not contain columns (attributes) that are not fully dependent upon the primary key

--TRANSACTIONS:
--In SQL Server 2000 there was begin tran, end tran with @@ERROR function. In 2005 or later there is begin transaction, 
--end transaction in try catch (should be in begin try, end try)

Begin Try
  Raiserror('Not enough stock available',16,1)
End Try
Begin Catch 
  Select 
   ERROR_NUMBER() as ErrorNumber,
   ERROR_MESSAGE() as ErrorMessage,
   ERROR_PROCEDURE() as ErrorProcedure,
   ERROR_STATE() as ErrorState,
   ERROR_SEVERITY() as ErrorSeverity,
   ERROR_LINE() as ErrorLine
End Catch 

--SQL server by default cannot select uncommited data, there is possible to change it:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITED;
```

## 63-77
```sql

--However, if there is ever a need to process the rows, on a row-by-row basis, then cursors are your choice. 
--Cursors are very bad for performance, and should be avoided always. Most of the time, cursors can be very easily replaced using joins.
--Update statement using cursor is totally not efficient

--Some of the common concurrency problems:
--*Dirty Reads
--*Lost Updates
--*Nonrepeatable Reads
--*Phantom Reads

--*A dirty read happens when one transaction is permitted to read data that has 
--been modified by another transaction that has not yet been committed. 
--Read Uncommitted transaction isolation level is the only isolation level that has dirty read side effect.

--*Lost update problem happens when 2 transactions read and update the same data.
--Both Read Uncommitted and Read Committed transaction isolation levels have the lost update side effect

--*Non repeatable read problem happens when one transaction reads the same data twice and another transaction 
--updates that data in between the first and second read of transaction one. 
--Fixing non repeatable read concurrency problem : To fix the non-repeatable read problem, set transaction isolation 
--level of Transaction 1 to repeatable read. This will ensure that the data that Transaction 1 has read, will be 
--prevented from being updated or deleted elsewhere. This solves the non-repeatable read problem. 

--*Phantom read happens when one transaction executes a query twice and it gets a different number of rows in 
--the result set each time. This happens when a second transaction inserts a new row that matches the WHERE clause 
--of the query executed by the first transaction. 

Set transaction isolation level read uncommited
Set transaction isolation level read commited
Set transaction isolation level repeatable read
Set transaction isolation level serializable
-- Enable snapshot isloation for the database
Alter database SampleDB SET ALLOW_SNAPSHOT_ISOLATION ON
-- Set the transaction isolation level to snapshot
Set transaction isolation level snapshot

--Difference between repeatable read and serializable:
--Repeatable read prevents only non-repeatable read. Repeatable read isolation level ensures that the data that one transaction 
--has read, will be prevented from being updated or deleted by any other transaction, but it does not prevent new rows from being 
--inserted by other transactions resulting in phantom read concurrency problem.

--Serializable prevents both non-repeatable read and phantom read problems. Serializable isolation level ensures that the data 
--that one transaction has read, will be prevented from being updated or deleted by any other transaction. It also prevents new 
--rows from being inserted by other transactions, so this isolation level prevents both non-repeatable read and phantom read problems.

--Snapshot isolation doesn't acquire locks, it maintains versioning in Tempdb.

Alter database SampleDB SET READ_COMMITTED_SNAPSHOT ON --to do it you must close all database connections, then:
Set transaction isolation level read commited
--above is not a different isolation level, it is a different way of implementing read commited isolation level

```

## 78-86
```sql

--What is DEADLOCK_PRIORITY
--By default, SQL Server chooses a transaction as the deadlock victim that is least expensive to roll back.
SET DEADLOCK_PRIORITY NORMAL
SET DEADLOCK_PRIORITY HIGH

--Enable Trace flag : To enable trace flags use DBCC command. -1 parameter indicates that the trace flag must be 
--set at the global level. If you omit -1 parameter the trace flag will be set only at the session level.

DBCC Traceon(1222, -1)
--To check the status of the trace flag
DBCC TraceStatus(1222, -1)
--To turn off the trace flag
DBCC Traceoff(1222, -1)

execute sp_readerrorlog --there we can see deadlocks

--Capturing deadlocks in sql profiler
--Tools --> SQL Profiler
--Use the template = Blank
--On the Events Selection tab click Locks --> Deadlock graph
--Finally click the Run button to start the trace
--At this point execute the code that causes deadlock
--The deadlock graph should be captured in the profiler.

--HoBt ID : Heap Or Binary Tree ID. Using this ID query sys.partitions view to find the database objects involved in the deadlock.
SELECT object_name([object_id])
FROM sys.partitions
WHERE hobt_id = 72057594041663488

DBCC OpenTran --shows open transactions

--SQL script for finding running transactions
SELECT
    [s_tst].[session_id],
    [s_es].[login_name] AS [Login Name],
    DB_NAME (s_tdt.database_id) AS [Database],
    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
    [s_est].text AS [Last T-SQL Text],
    [s_eqp].[query_plan] AS [Last Plan]
FROM sys.dm_tran_database_transactions [s_tdt]
JOIN sys.dm_tran_session_transactions [s_tst] ON [s_tst].[transaction_id] = [s_tdt].[transaction_id]
JOIN sys.[dm_exec_sessions] [s_es] ON [s_es].[session_id] = [s_tst].[session_id]
JOIN sys.dm_exec_connections [s_ec] ON [s_ec].[session_id] = [s_tst].[session_id]
LEFT OUTER JOIN sys.dm_exec_requests [s_er] ON [s_er].[session_id] = [s_tst].[session_id]
CROSS APPLY sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
OUTER APPLY sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]
ORDER BY [Begin Time] ASC;
GO

--SQL Server process can be killed by using:
--SQL Server Activity monitor
--Using SQL command:
KILL process_id

```

## 87-91
```sql

--So, what is the difference between EXCEPT and NOT IN operators
--1. Except filters duplicates and returns only DISTINCT rows from the left query that aren’t in 
--the right query’s results, where as NOT IN does not filter the duplicates.
--2. EXCEPT operator expects the same number of columns in both the queries, where as NOT IN, 
--compares a single column from the outer query with a single column from the subquery.

--INTERSECT retrieves common records
--UNION ALL operator returns all the rows from both the queries, including the duplicates.
--UNION will delete duplicates

--cross apply and outer apply can be used with table functions
SELECT D.DepartmentName, E.Name, E.Gender, E.Salary
FROM Department D
CROSS Apply fn_GetEmployeesByDepartmentId(D.Id) E

--cross apply is like join and outer apply is like left join

```

## 92-106
```sql

--In SQL Server there are 4 types of triggers
--1. DML Triggers - Data Manipulation Language. Discussed in Parts 43 to 47 of SQL Server Tutorial.
--2. DDL Triggers - Data Definition Language
--3. CLR triggers - Common Language Runtime
--4. Logon triggers

--DML trigger
CREATE TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE
AS
BEGIN
   Print 'New table created'
END

DISABLE TRIGGER trMyFirstTrigger ON DATABASE
ENABLE TRIGGER trMyFirstTrigger ON DATABASE
DROP TRIGGER trMyFirstTrigger ON DATABASE

--There is possible to create server scoped trigger
--Server triggers will always fire before database triggers

--Difference between WHERE and Having
--1. WHERE clause cannot be used with aggregates where as HAVING can. This means WHERE clause is 
--used for filtering individual rows where as HAVING clause is used to filter groups.
--2. WHERE comes before GROUP BY. This means WHERE clause filters rows before aggregate calculations 
--are performed. HAVING comes after GROUP BY. This means HAVING clause filters rows after aggregate calculations 
--are performed. So from a performance standpoint, HAVING is slower than WHERE and should be avoided when possible.
--3. WHERE and HAVING can be used together in a SELECT query. In this case WHERE clause is applied first to 
--filter individual rows. The rows are then grouped and aggregate calculations are performed, and then the HAVING clause filters the groups.

--From SQL Server 2008 there is possible to pass table valued parameter to procedure

--From SQL Server 2008 there is possibility to group by sets
Select Country, Gender, Sum(Salary) TotalSalary
From Employees
Group BY
      GROUPING SETS
      (
            (Country, Gender), -- Sum of Salary by Country and Gender
            (Country),         -- Sum of Salary by Country
            (Gender) ,         -- Sum of Salary by Gender
            ()                 -- Grand Total
      )
Order By Grouping(Country), Grouping(Gender), Gender

SELECT Country, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY ROLLUP(Country)  -- GROUP BY Country WITH ROLLUP

SELECT Country, Gender, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY CUBE(Country, Gender)  -- GROUP BY Country, Gender with Cube

--Difference is that wih rollup we're having hierarchy grouping and with cube all combinations
--You won't see any difference when you use this functions on single column. 3 are nedded

--grouping function
SELECT Continent, Country, City, SUM(SaleAmount) AS TotalSales,
    GROUPING(Continent) AS GP_Continent, --return 1 if column was grouped
    GROUPING(Country) AS GP_Country,
    GROUPING(City) AS GP_City
FROM Sales
GROUP BY ROLLUP(Continent, Country, City)

--Change nulls into All value, to be more user friendly (There must be case because of possible nulls)
SELECT  
    CASE WHEN GROUPING(Continent) = 1 THEN 'All' ELSE ISNULL(Continent, 'Unknown') END AS Continent,
    CASE WHEN GROUPING(Country) = 1 THEN 'All' ELSE ISNULL(Country, 'Unknown') END AS Country,
    CASE WHEN GROUPING(City) = 1 THEN 'All' ELSE ISNULL(City, 'Unknown') END AS City,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ROLLUP(Continent, Country, City)

SELECT  Continent, Country, City, SUM(SaleAmount) AS TotalSales,
        GROUPING_ID(Continent, Country, City) AS GPID --specifies grouping by binary (1,2,4) addition
FROM Sales
GROUP BY ROLLUP(Continent, Country, City)
ORDER BY GPID

```

## 107-117
```sql

--COUNT(Gender) OVER (PARTITION BY Gender) will partition the data by GENDER i.e there will 2 partitions 
--(Male and Female) and then the COUNT() function is applied over each partition.

--Any of the following functions can be used. Please note this is not the complete list.
--COUNT(), AVG(), SUM(), MIN(), MAX(), ROW_NUMBER(), RANK(), DENSE_RANK() etc.

--Below query alternative is long query with derived table
SELECT Name, Salary, Gender,
    COUNT(Gender) OVER(PARTITION BY Gender) AS GenderTotals,
    AVG(Salary) OVER(PARTITION BY Gender) AS AvgSal,
    MIN(Salary) OVER(PARTITION BY Gender) AS MinSal,
    MAX(Salary) OVER(PARTITION BY Gender) AS MaxSal
FROM Employees

SELECT Name, Gender, Salary,
    ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY Gender) AS RowNumber
FROM Employees

--Second highest salary, if rank was used istead of dense_rank then couldn't be 2
WITH Result AS
(
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT Salary FROM Result WHERE Salary_Rank = 2

--Difference between row_number, rank and dense_rank is when we have duplicate values:
--row_number will do incrementing without looking on column
--rank will look at colum values, but will do jumps bewteen ids
--dense_rank will do same as rank, but will proper records identification

--Running total, there is need to ORDER BY unique column, because if not total can be incorrect
--by treating duplice values as one row
SELECT Name, Gender, Salary,
    SUM(Salary) OVER (PARTITION BY Gender ORDER BY ID) AS RunningTotal
FROM Employees

--NTILE divide rows into group, here dividing by 3, larger groups going first
SELECT Name, Gender, Salary, 
    NTILE(3) OVER (ORDER BY Salary) AS [Ntile]
FROM Employees

--Third parameter is default value, second is jump
SELECT Name, Gender, Salary,
    LEAD(Salary, 2, -1) OVER (ORDER BY Salary) AS Lead_2,
    LAG(Salary, 1, -1) OVER (ORDER BY Salary) AS Lag_1
FROM Employees

--Takes FirstValue as name of employee with lowest salary
SELECT Name, Gender, Salary,
    FIRST_VALUE(Name) OVER (PARTITION BY Gender ORDER BY Salary) AS FirstValue
FROM Employees

--The default for ROWS or RANGE clause is
--RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--Below we changed default range to show overall sum
SELECT Name, Gender, Salary,
        SUM(Salary) OVER(ORDER BY Salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Sum
FROM Employees

--sum from 3 rows
SELECT Name, Gender, Salary,
        SUM(Salary) OVER(ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS Average
FROM Employees

--ROWS treat duplicates as distinct values, where as RANGE treats them as a single entity.

```

## 118-129
```sql

--LAST_VALUE needs add rows between clause to show employee with highest salary.
--If not it will show only from first to to current
SELECT Name, Gender, Salary,
    LAST_VALUE(Name) OVER (PARTITION BY Gender ORDER BY Salary
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastValue
FROM Employees

--UNPIVOT operator helps us to unpivot pivoted table
--India, US, UK was columns changed to one Country column
SELECT SalesAgent, Country, SalesAmount
FROM tblProductSales
UNPIVOT
(
    SalesAmount
    FOR Country IN (India, US ,UK)
) AS UnpivotExample
--Unpivot cannot be done if pivot has aggregated data

--Choose function replaces boilerplate case whens
SELECT Name, DateOfBirth, CHOOSE(DATEPART(MM, DateOfBirth), 
       'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 
       'SEP', 'OCT', 'NOV', 'DEC') AS [MONTH]
FROM Employees

--IIF function replaces CASE WHEN with one WHEN and ELSE
SELECT IIF(TRY_PARSE('ABC' AS INT) IS NULL, 'Conversion Failed', 'Conversion Successful') AS Result

SELECT TRY_CONVERT(XML, '<root><child/></root>') AS [XML]
 
SELECT EOMONTH('3/20/2016', -1) AS LastDay --Returns 29.02.2016

SELECT DATEFROMPARTS (2015, 10, 25) AS [Date] -- Returns 25/10/2015

--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision )
SELECT DATETIME2FROMPARTS ( 2015, 11, 15, 20, 55, 55, 0, 0 ) AS [DateTime2]
--TIMEFROMPARTS ( hour, minute, seconds, fractions, precision )
SELECT TIMEFROMPARTS ( 20, 55, 55, 0, 0 ) AS [Time]

--DATETIME2 is better than DATETIME
SELECT 'Precision - 1' , CAST(SYSDATETIME() AS DATETIME2(1)), DATALENGTH(CAST(GETDATE() AS DATETIME2(1))) AS StorageSize
UNION ALL
SELECT 'Precision - 2' , CAST(SYSDATETIME() AS DATETIME2(2)), DATALENGTH(CAST(GETDATE() AS DATETIME2(2))) 
UNION ALL
SELECT 'Precision - 3' , CAST(SYSDATETIME() AS DATETIME2(3)), DATALENGTH(CAST(GETDATE() AS DATETIME2(3)))
UNION ALL
SELECT 'Precision - 4' , CAST(SYSDATETIME() AS DATETIME2(4)), DATALENGTH(CAST(GETDATE() AS DATETIME2(4))) 
UNION ALL
SELECT 'Precision - 5' , CAST(SYSDATETIME() AS DATETIME2(5)), DATALENGTH(CAST(GETDATE() AS DATETIME2(5))) 
UNION ALL
SELECT 'Precision - 6' , CAST(SYSDATETIME() AS DATETIME2(6)), DATALENGTH(CAST(GETDATE() AS DATETIME2(6))) 
UNION ALL
SELECT 'Precision - 7' , CAST(SYSDATETIME() AS DATETIME2(7)), DATALENGTH(CAST(GETDATE() AS DATETIME2(7))) 

```

## 130-137
```sql

--paging functionality
CREATE PROCEDURE spGetRowsByPageNumberAndSize
@PageNumber INT,
@PageSize INT
AS
BEGIN
    SELECT * FROM tblProducts
    ORDER BY Id
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY
END

--Identifying object dependencies in SQL Server --> Right click on table, then view dependencies

SELECT * FROM sys.dm_sql_referencing_entities('dbo.Employees','Object')
SELECT * FROM sys.dm_sql_referenced_entities('dbo.sp_GetEmployeesandDepartments','Object')

--sp_depends does not show table which was deleted and restored, thats why we cannot trust results
--sp_depends is on the deprecation path. This might be removed from the future versions of SQL server.

--GUID is a globally unique value
CREATE TABLE USACustomers1
(
     ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
     Name NVARCHAR(50)
)
Go

INSERT INTO USACustomers1 VALUES (DEFAULT, 'Tom')
INSERT INTO USACustomers1 VALUES (DEFAULT, 'Mike')

--The main advantage of using a GUID is that it is unique across tables, databases and servers. 
--It is extremely useful if you're consolidating records from multiple SQL Servers into a single table. 

--The main disadvantage of using a GUID as a key is that it is 16 bytes in size. It is one of the 
--largest datatypes in SQL Server. An integer on the other hand is 4 bytes,

--An Index built on a GUID is larger and slower than an index built on integer column. 
--In addition a GUID is hard to read compared to int.

--This is how we check if GUID is empty
Declare @MyGuid UniqueIdentifier
Select ISNULL(@MyGuid, NewID())

```

## 138-144
```sql
--query for finding query plans, last result column is clickable --> it moves us to query plan
SELECT cp.usecounts, cp.cacheobjtype, cp.objtype, st.text, qp.query_plan
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
ORDER BY cp.usecounts DESC

--objtype contains what for what type of object query plan was generated (adhoc, proc etc.)
--if we compute select statement from an adhoc query, it checks if query plan exists by checking hash value of query text

Declare @FirstName nvarchar(50)
Set @FirstName = 'Steve'
Execute sp_executesql N'Select * from Employees where FirstName=@FN', N'@FN nvarchar(50)', @FirstName

--Summary: Never ever concatenate user input values with strings to build dynamic sql statements. Always use 
--parameterised queries which not only promotes cached query plans reuse but also prevent sql injection attacks.

--it is always better to use sp_executesql than execute because we can explicitly parametrize queries

```

## 145-149
```sql

Declare @sql nvarchar(200)
Declare @tableName nvarchar(50)
Set @tableName = 'USA Customers Drop Database SalesDB --'
Set @sql = 'Select * from ' + QUOTENAME(@tableName)
select @sql
--QUOTENAME default value is square bracket

SELECT QUOTENAME('USA Customers') 
SELECT QUOTENAME('USA Customers','[') 
SELECT QUOTENAME('USA Customers',']')
SELECT QUOTENAME('USA Customers','''')
SELECT QUOTENAME('USA Customers','"')

--temporary table created in dynaminc sql will be dropped after it completes

```












