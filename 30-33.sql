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

