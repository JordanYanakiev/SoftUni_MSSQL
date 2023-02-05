USE SoftUni
--    1. Employees with Salary Above 35000
--Create stored procedure usp_GetEmployeesSalaryAbove35000 
--that returns all employees' first and last names, whose salary above 35000. 

CREATE PROC usp_GetEmployeesSalaryAbove35000 AS 

SELECT FirstName, LastName
FROM Employees
WHERE Salary > 35000

--    2. Employees with Salary Above Number
--Create a stored procedure usp_GetEmployeesSalaryAboveNumber 
--that accepts a number (of type DECIMAL(18,4)) as parameter and 
--returns all employees' first and last names, whose salary is 
--above or equal to the given number. 

CREATE PROC usp_GetEmployeesSalaryAboveNumber 
(@someNumber DECIMAL(18,4)) AS

SELECT FirstName, LastName
FROM Employees
WHERE Salary >= @someNumber

----    3. Town Names Starting With
----Create a stored procedure usp_GetTownsStartingWith 
----that accepts a string as parameter and returns all 
----town names starting with that string. 

--CREATE PROC usp_GetTownsStartingWith 
--(@someString VARCHAR(50)) AS

--SELECT [Name]
--FROM [Towns]
--WHERE [Name] LIKE '@someString%'

--    4. Employees from Town
--Create a stored procedure usp_GetEmployeesFromTown 
--that accepts town name as parameter and returns the 
--first and last name of those employees, who live in the given town. 

CREATE PROC usp_GetEmployeesFromTown 
(@someNumber VARCHAR(50)) AS

SELECT FirstName, LastName
FROM Employees AS [e]
LEFT JOIN [Addresses] AS [a]
ON [a].AddressID = [e].AddressID
LEFT JOIN [Towns] AS [t]
ON [t].TownID = [a].TownID
WHERE [t].[Name] = @someNumber

EXEC usp_GetEmployeesFromTown sofia

--    5. Salary Level Function
--Create a function ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
--that receives salary of an employee and returns the level of the salary.
--    • If salary is < 30000, return "Low"
--    • If salary is between 30000 and 50000 (inclusive), return "Average"
--    • If salary is > 50000, return "High"

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(50) AS

BEGIN
DECLARE @salaryLevel VARCHAR(50)
IF (@salary < 30000)
BEGIN
SET @salaryLevel = 'Low'
END
ELSE IF (@salary BETWEEN 30000 AND 50000)
BEGIN
SET @salaryLevel = 'Average'
END
ELSE IF (@salary > 50000)
BEGIN
SET @salaryLevel = 'High'
END

RETURN @salaryLevel;
END

SELECT * , dbo.ufn_GetSalaryLevel(50000) AS [SAlary Level]
from Employees

--    6. Employees by Salary Level
--Create a stored procedure usp_EmployeesBySalaryLevel 
--that receives as parameter level of salary (low, average, or high) 
--and print the names of all employees, who have the given level of salary. 
--You should use the function - "dbo.ufn_GetSalaryLevel(@Salary)", 
--which was part of the previous task, inside your "CREATE PROCEDURE …" query.

CREATE PROC usp_EmployeesBySalaryLevel(@input VARCHAR(20)) AS
BEGIN
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE dbo.ufn_GetSalaryLevel([Salary]) = @input 
END

EXEC usp_EmployeesBySalaryLevel @input = 'High'

--    7. Define Function
--Define a function ufn_IsWordComprised(@setOfLetters, @word) 
--that returns true or false, depending on that if 
--the word is comprised of the given set of letters. 

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR (50))
RETURNS BIT
AS
BEGIN
DECLARE @wordIndex INT = 1;

WHILE (@wordIndex <= LEN(@word))
BEGIN
DECLARE @currentCharacter CHAR = SUBSTRING(@word, @wordIndex, 1)

IF CHARINDEX(@currentCharacter, @setOfLetters) = 0
BEGIN
      RETURN 0;
END

SET @wordIndex += 1;
END

RETURN 1;
END

SELECT [dbo].[ufn_IsWordComprised]('StarWars', 'ghjk')


--    9. Find Full Name
--You are given a database schema with tables 
--AccountHolders(Id (PK), FirstName, LastName, SSN) and 
--Accounts(Id (PK), AccountHolderId (FK), Balance).  
--Write a stored procedure usp_GetHoldersFullName that selects 
--the full name of all people. 

USE Bank

CREATE PROC usp_GetHoldersFullName
AS
BEGIN
		SELECT [FirstName] + ' ' + [LastName] AS [Full Name]
		FROM [AccountHolders]
END

EXEC usp_GetHoldersFullName

--    10. People with Balance Higher Than
--Your task is to create a stored procedure usp_GetHoldersWithBalanceHigherThan 
--that accepts a number as a parameter and returns all the people, 
--who have more money in total in all their accounts than the supplied number. 
--Order them by their first name, then by their last name.

CREATE PROC usp_GetHoldersWithBalanceHigherThan (@someNumber DECIMAL(18,4))
AS
BEGIN
SELECT [FirstName], [LastName]
FROM [AccountHolders] AS [ah]
	  LEFT JOIN [Accounts] AS [a] ON [ah].[Id] = [a].[AccountHolderId]
GROUP BY [ah].[FirstName], [ah].[LastName]
HAVING SUM([a].[Balance]) > @someNumber
ORDER BY [ah].FirstName ASC, [ah].[LastName] ASC
END

EXEC dbo.usp_GetHoldersWithBalanceHigherThan 565649










