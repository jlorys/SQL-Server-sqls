DECLARE @DOB DATETIME
SET @DOB = '1993-07-11 19:45:31.793'

DECLARE @tempdate DATETIME, @years INT, @months INT, @days INT
SELECT @tempdate = @DOB

SELECT @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - IIF((MONTH(@DOB) >= MONTH(GETDATE())) AND DAY(@DOB) > DAY(GETDATE()), 1, 0)
SELECT @tempdate = DATEADD(YEAR, @years, @tempdate)

SELECT @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - IIF(DAY(@DOB) > DAY(GETDATE()), 1, 0)
SELECT @tempdate = DATEADD(MONTH, @months, @tempdate)

SELECT @days = DATEDIFF(DAY, @tempdate, GETDATE())

SELECT Cast(@years AS  NVARCHAR(4)) + ' Years ' + 
       Cast(@months AS  NVARCHAR(2))+ ' Months ' +  
       Cast(@days AS  NVARCHAR(2))+ ' Days Old'