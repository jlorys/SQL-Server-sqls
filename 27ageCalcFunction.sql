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