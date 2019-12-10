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

