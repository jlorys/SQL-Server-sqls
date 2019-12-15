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