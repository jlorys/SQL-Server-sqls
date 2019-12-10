--Example: 
Select ASCII('A')
--Output: 65

--CHAR(Integer_Expression) - Converts an int ASCII code to a character. The Integer_Expression, should be between 0 and 255.
--The following SQL, prints all the characters for the ASCII values from o thru 255

Declare @Number int
Set @Number = 1
While(@Number <= 255)
Begin
 Print CHAR(@Number)
 Set @Number = @Number + 1
End

Select LTRIM('   Hello') --Output: Hello
Select RTRIM('Hello   ') --Output: Hello
Select LTRIM(RTRIM('   Hello   ')) --Output: Hello
Select LOWER('CONVERT This String Into Lower Case') --Output: convert this string into lower case
Select UPPER('CONVERT This String Into upper Case') --Output: CONVERT THIS STRING INTO UPPER CASE
Select REVERSE('ABCDEFGHIJKLMNOPQRSTUVWXYZ') --Output: ZYXWVUTSRQPONMLKJIHGFEDCBA
Select LEN('SQL Functions   ') --Output: 13
Select LEFT('ABCDE', 3) --Output: ABC
Select RIGHT('ABCDE', 3) --Output: CDE
Select CHARINDEX('@','sara@aaa.com',1) --Output: 5
Select SUBSTRING('John@bbb.com',6, 7) --Output: bbb.com
Select SUBSTRING('John@bbb.com',(CHARINDEX('@', 'John@bbb.com') + 1), (LEN('John@bbb.com') - CHARINDEX('@','John@bbb.com'))) --Output: bbb.com
SELECT REPLICATE('Pragim', 3) --Output: Pragim Pragim Pragim 
SELECT SPACE(5) + 'abc' --Output:     abc
Select PATINDEX('%@aaa.com', 'qwerty@aaa.com') as FirstOccurence --Output: 7
Select REPLACE('qwerty@aaa.com', '.com', '.net') as ConvertedEmail --Output: qwerty@aaa.net
Select STUFF('qwerty@aaa.com', 2, 3, '*****') as StuffedEmail --Output: q*****ty@aaa.com


