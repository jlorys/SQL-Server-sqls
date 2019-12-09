--Cascading referential integrity
--1. No Action
--2. Cascade
--3. Set NULL
--4. Set Default

--highlight the table and press alt + f4 to see table details

--check constraint
--The following check constraint, limits the age between ZERO and 150.
ALTER TABLE tblPerson
ADD CONSTRAINT CK_tblPerson_Age CHECK (Age > 0 AND Age < 150)

--To drop the CHECK constraint:
ALTER TABLE tblPerson
DROP CONSTRAINT CK_tblPerson_Age

--identity; first param is seed second is increment
--Seed and Increment values are optional. If you don't specify the identity and seed they both default to 1.
Create Table tblPerson
(
PersonId int Identity(1,1) Primary Key,
Name nvarchar(20)
)

SET Identity_Insert tblPerson ON
Insert into tblPerson(PersonId, Name) values(2, 'John')
--As long as the Identity_Insert is turned on for a table, you need to explicitly provide the value for that column.

--After, you have the gaps in the identity column filled, and if you wish SQL server to calculate the value, turn off Identity_Insert.
SET Identity_Insert tblPerson OFF

--If you have deleted all the rows in a table, and you want to reset the identity column value, use DBCC CHECKIDENT command. This command will reset PersonId identity column.
DBCC CHECKIDENT(tblPerson, RESEED, 0)
