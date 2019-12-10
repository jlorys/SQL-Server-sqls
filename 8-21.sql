--In brief:
--SCOPE_IDENTITY() - returns the last identity value that is created in the same session and in the same scope.
--@@IDENTITY - returns the last identity value that is created in the same session and across any scope.
--IDENT_CURRENT('TableName') - returns the last identity value that is created for a specific table across any session and any scope.

--To create the unique key using a query:
Alter Table Table_Name
Add Constraint Constraint_Name Unique(Column_Name)

--Both primary key and unique key are used to enforce, the uniqueness of a column. So, when do you choose one over the other?
--A table can have, only one primary key. If you want to enforce uniqueness on 2 or more columns, then we use unique key constraint.

--What is the difference between Primary key constraint and Unique key constraint? This question is asked very frequently in interviews.
--1. A table can have only one primary key, but more than one unique key
--2. Primary key does not allow nulls, where as unique key allows one null

--To drop the constraint
--Using a query
Alter Table tblPerson
Drop COnstraint UQ_tblPerson_Email

select * from tblPerson where name like '[MST]%' --begins with M or S or T
select * from tblPerson where name like '^[MST]%' -- not begins with M or S or T
select * from tblPerson where name like '_@_.com' -- _ specify character
-- % specifies zero or more characters

--select top 10 Percent *...

--UNION ALL combines all
--UNION combines removing duplicates

--Display estimated execution plan in SSMS to show union distinct sort

sp_depends SP_Name
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








