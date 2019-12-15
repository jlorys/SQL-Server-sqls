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