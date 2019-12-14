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



