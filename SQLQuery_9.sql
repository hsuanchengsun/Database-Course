
-- Question (1) 
-- a)	Create a transact-SQL stored procedure called spPrintEmployeeRate 

CREATE PROCEDURE spPrintEmployeeRate
(
@DepartmentName NVARCHAR(50)
)
AS
BEGIN
SELECT P.Title, P.LastName + ' ' + P.FirstName AS name, EPH.Rate
    FROM AdventureWorksDB.Person.Person AS P
    JOIN AdventureWorksDB.HumanResources.EmployeeDepartmentHistory AS EDH
    ON P.BusinessEntityID = EDH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
    ON P.BusinessEntityID = EPH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.Department as D
    ON EDH.DepartmentID = D.DepartmentID
WHERE D.Name = @DepartmentName
AND EPH.RateChangeDate = (SELECT MAX(EPH.RateChangeDate) 
FROM AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
WHERE P.BusinessEntityID = EPH.BusinessEntityID)
AND EDH.EndDate IS NULL
ORDER BY EPH.rate DESC
END

-- b)	Write a transact-SQL statement to execute the procedure spPrintEmployeeRate with a Department Name as input
EXEC spPrintEmployeeRate @DepartmentName = 'Engineering'


-- c)	Write a transact-SQL statement to modify spPrintEmployeeRate procedure 
ALTER PROCEDURE spPrintEmployeeRate
(
@DepartmentName NVARCHAR(50),
@MinRate MONEY
)
AS
BEGIN
SELECT P.Title, P.LastName + ' ' + P.MiddleName + ' ' + P.FirstName AS name, EPH.Rate
    FROM AdventureWorksDB.Person.Person AS P
    JOIN AdventureWorksDB.HumanResources.EmployeeDepartmentHistory AS EDH
    ON P.BusinessEntityID = EDH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
    ON P.BusinessEntityID = EPH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.Department as D
    ON EDH.DepartmentID = D.DepartmentID
WHERE EDH.EndDate IS NULL
AND EPH.RateChangeDate = (SELECT MAX(EPH.RateChangeDate) 
FROM AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
WHERE P.BusinessEntityID = EPH.BusinessEntityID)
AND D.Name = @DepartmentName
AND EPH.Rate > @MinRate
ORDER BY EPH.rate DESC
END

-- d)	Write a transact-SQL statement to delete spPrintEmployeeRate procedure.
EXEC spPrintEmployeeRate @DepartmentName = 'Marketing', @MinRate = 10.00

DROP PROCEDURE spPrintEmployeeRate

-- Question (2) 
-- a)	Create a transact-SQL stored procedure spGetWeeklyGroupTotalSalary
CREATE PROCEDURE spGetWeeklyGroupTotalSalary
(
@GroupName NVARCHAR(50),
@WeeklyTotalSalary MONEY OUTPUT
)
AS
BEGIN
SELECT @WeeklyTotalSalary = SUM(EPH.Rate)*40
    FROM AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
    JOIN AdventureWorksDB.Person.Person AS P
    ON P.BusinessEntityID = EPH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.EmployeeDepartmentHistory AS EDH
    ON P.BusinessEntityID = EDH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.Department as D
    ON EDH.DepartmentID = D.DepartmentID
WHERE EPH.RateChangeDate = (SELECT MAX(EPH.RateChangeDate) 
FROM AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
WHERE P.BusinessEntityID = EPH.BusinessEntityID)
AND D.GroupName = @GroupName
AND EDH.EndDate IS NULL
END


-- b)	Write a transact-SQL statement to execute the procedure spGetWeeklyGroupTotalSalary 

DECLARE @Rateoutput MONEY
EXEC spGetWeeklyGroupTotalSalary @GroupName = 'Research and Development', @WeeklyTotalSalary = @Rateoutput OUT 
SELECT @Rateoutput

-- c)	Create a transact-SQL stored procedure spGetCurrentSalaryRate
CREATE PROCEDURE spGetCurrentSalaryRate
(
@BusinessEntityID INT
, @Rate FLOAT OUTPUT
, @DepartmentName NVARCHAR(50) OUTPUT
)
AS
BEGIN
SELECT @Rate = EPH.Rate, @DepartmentName = D.Name
    FROM AdventureWorksDB.Person.Person AS P
    JOIN AdventureWorksDB.HumanResources.EmployeeDepartmentHistory AS EDH
    ON P.BusinessEntityID = EDH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
    ON P.BusinessEntityID = EPH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.Department as D
    ON EDH.DepartmentID = D.DepartmentID
WHERE EPH.RateChangeDate = (SELECT MAX(EPH.RateChangeDate) 
FROM AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
WHERE P.BusinessEntityID = EPH.BusinessEntityID)
AND P.BusinessEntityID = @BusinessEntityID
AND EDH.EndDate IS NULL
END


-- d)	Write a transact-SQL statement to execute the spGetCurrentSalaryRate
DECLARE @RateOutput FLOAT
DECLARE @DepartmentOutput NVARCHAR(50)
EXEC spGetCurrentSalaryRate @BusinessEntityID = 10, @Rate = @RateOutput OUT, @DepartmentName = @DepartmentOutput OUT
SELECT EPH.Rate, P.LastName + ' ' + P.MiddleName + ' ' + P.FirstName AS name
    FROM AdventureWorksDB.Person.Person AS P
    JOIN AdventureWorksDB.HumanResources.EmployeeDepartmentHistory AS EDH
    ON P.BusinessEntityID = EDH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
    ON P.BusinessEntityID = EPH.BusinessEntityID
    JOIN AdventureWorksDB.HumanResources.Department as D
    ON EDH.DepartmentID = D.DepartmentID
WHERE EPH.RateChangeDate = (SELECT MAX(EPH.RateChangeDate) 
FROM AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
WHERE P.BusinessEntityID = EPH.BusinessEntityID)
AND D.Name = @DepartmentOutput
AND EPH.Rate > @RateOutput

