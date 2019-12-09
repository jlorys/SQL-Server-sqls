--Sql Server 2014 Express Edition
--Batches are separated by 'go'

select @@version as 'sql server version'

--Whether, you create a database graphically using the designer or, using a query, the following 2 files gets generated.
--.MDF file - Data File (Contains actual data)
--.LDF file - Transaction Log file (Used to recover the database)

--To alter a database, once it's created 
Alter database DatabaseName Modify Name = NewDatabaseName

--Alternatively, you can also use system stored procedure
Execute sp_renameDB 'OldDatabaseName','NewDatabaseName'

--To Delete or Drop a database
Drop Database DatabaseThatYouWantToDrop

--Dropping a database, deletes the LDF and MDF files.

--To add a foreign key reference using a query
Alter table tblPerson 
add constraint tblPerson_GenderId_FK FOREIGN KEY (GenderId) references tblGender(ID)

--Altering an existing column to add a default constraint:
ALTER TABLE { TABLE_NAME }
ADD CONSTRAINT { CONSTRAINT_NAME }
DEFAULT { DEFAULT_VALUE } FOR { EXISTING_COLUMN_NAME }


--Adding a new column, with default value, to an existing table:
ALTER TABLE { TABLE_NAME } 
ADD { COLUMN_NAME } { DATA_TYPE } { NULL | NOT NULL } 
CONSTRAINT { CONSTRAINT_NAME } DEFAULT { DEFAULT_VALUE }


--The following command will add a default constraint, DF_tblPerson_GenderId.
ALTER TABLE tblPerson
ADD CONSTRAINT DF_tblPerson_GenderId
DEFAULT 1 FOR GenderId

--To drop a constraint
ALTER TABLE { TABLE_NAME } 
DROP CONSTRAINT { CONSTRAINT_NAME }