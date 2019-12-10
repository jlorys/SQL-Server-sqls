--Note: UTC stands for Coordinated Universal Time, based on which, the world regulates clocks and time. There are slight differences 
--between GMT and UTC, but for most common purposes, UTC is synonymous with GMT. 

--Function	          Date Time Format	                    Description
GETDATE()	        --2012-08-31 20:15:04.543	            Commonly used function
CURRENT_TIMESTAMP	--2012-08-31 20:15:04.543	            ANSI SQL equivalent to GETDATE
SYSDATETIME()	    --2012-08-31 20:15:04.5380028	        More fractional seconds precision
SYSDATETIMEOFFSET()	--2012-08-31 20:15:04.5380028 + 01:00	More fractional seconds precision + Time zone offset
GETUTCDATE()	    --2012-08-31 19:15:04.543	            UTC Date and Time
SYSUTCDATETIME()	--2012-08-31 19:15:04.5380028	        UTC Date and Time, with More fractional seconds precision



