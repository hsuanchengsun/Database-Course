-- a)	Create a transact-SQL stored procedure using LOOP that outputs the number of 
-- employees whose current pay rate is in a $10 increment, till the maximum pay rate. 
CREATE PROCEDURE sp_EmployeeRate
AS
DECLARE @Counter INT
DECLARE @MinRate MONEY
DECLARE @MaxRate MONEY
DECLARE @LowerBound DECIMAL
DECLARE @UpperBound DECIMAL
DECLARE @NumEmployee INT
BEGIN
SELECT @MinRate = MIN(EPH.Rate), @MaxRate = MAX(EPH.Rate)
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

-- Loop
SET @Counter = 0
SET @LowerBound = @MinRate

WHILE @LowerBound < @MaxRate
BEGIN
SET @UpperBound = @Counter * 10 + 10

SELECT @NumEmployee = COUNT(*)
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
AND (EPH.Rate > @LowerBound AND EPH.Rate <= @UpperBound)

IF @Counter = 0
    PRINT CAST(@NumEmployee as VARCHAR(5)) + 
    ' employees have pay rate between $' + 
    CAST(@MinRate as VARCHAR(10)) + ' and $' + 
    CAST(@UpperBound as VARCHAR(10)) 
    ELSE 
        IF @UpperBound > @MaxRate
        PRINT CAST(@NumEmployee as VARCHAR(5)) + 
        ' employees have pay rate between $' + 
        CAST(@LowerBound as VARCHAR(10)) + ' and $' + 
        CAST(@MaxRate as VARCHAR(10))
        ELSE
        PRINT CAST(@NumEmployee as VARCHAR(5)) + 
        ' employees have pay rate between $' + 
        CAST(@LowerBound as VARCHAR(10)) + ' and $' + 
        CAST(@UpperBound as VARCHAR(10)) 

SET @Counter = @Counter + 1
SET @LowerBound = @Counter * 10
END
PRINT '----------------------------------------'
SET @NumEmployee = (SELECT COUNT(*)
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
WHERE P.BusinessEntityID = EPH.BusinessEntityID))

PRINT CAST(@NumEmployee as VARCHAR(5)) + 
' employees have pay rate between $' + 
CAST(@MinRate as VARCHAR(10)) + ' and $' + 
CAST(@MaxRate as VARCHAR(10))

END


-- b) Write a transact-SQL statement to execute the stored procedure from (a). 
EXEC sp_EmployeeRate

-- c)	Create a transact-SQL stored procedure using conditional statement with GOTO options. 
CREATE PROCEDURE sp_WeeklyPayReport(
@ReportType VARCHAR(50)
)
AS
BEGIN
IF @ReportType = 'Department' GOTO DEPT_BRANCH
ELSE IF @ReportType = 'Group' GOTO GROUP_BRANCH
    ELSE GOTO ERROR_BRANCH
END

DEPT_BRANCH:
    SELECT D.Name, SUM(EPH.Rate*40) as WeeklyRate
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
    GROUP BY D.Name
    RETURN

GROUP_BRANCH:
    SELECT D.GroupName, SUM(EPH.Rate*40) as WeeklyRate
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
    GROUP BY D.GroupName
    RETURN

ERROR_BRANCH:
PRINT 'Please enter either Department or Group.'

-- d) Write 3 transact-SQL statement to execute the stored procedure from (a): one for each GOTO option. 
EXEC sp_WeeklyPayReport 'Department'

EXEC sp_WeeklyPayReport 'Group'

EXEC sp_WeeklyPayReport 'Rate'

-- Question 2
-- a) Create copies of the Department, EmployeePayHistory, tables 
SELECT * INTO My_Department FROM AdventureWorksDB.HumanResources.Department
SELECT * INTO My_EmployeePayHistory FROM AdventureWorksDB.HumanResources.EmployeePayHistory

-- b) Create a cursor that stores the BusinessEntityID of the employee, and 
-- retrieve the employee’s current group name from the EmployeeDepartment table. 
DECLARE @BusinessEntityID AS INT
DECLARE @GroupName AS VARCHAR(50)
DECLARE @Rate AS MONEY

DECLARE EmployeeCursor CURSOR
    FOR SELECT E.BusinessEntityID, D.GroupName, EPH.Rate
        FROM AdventureWorksDB.Person.Person AS P
        JOIN AdventureWorksDB.HumanResources.Employee AS E
        ON P.BusinessEntityID = E.BusinessEntityID
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

OPEN EmployeeCursor
FETCH NEXT FROM EmployeeCursor INTO @BusinessEntityID, @GroupName, @Rate
WHILE (@@FETCH_STATUS = 0)
BEGIN
    IF(@GroupName = 'Inventory Management' or @GroupName = 'Quality Assurance')
    BEGIN
    UPDATE MY_EMPLOYEEPAYHISTORY
    SET Rate = Rate * (1.1)
    WHERE BusinessEntityID = @BusinessEntityID AND Rate = @Rate
    END

    ELSE IF(@GroupName = 'Manufacturing')
        BEGIN
        UPDATE MY_EMPLOYEEPAYHISTORY
        SET Rate = Rate * (1.15)
        WHERE BusinessEntityID = @BusinessEntityID AND Rate = @Rate
        END
        ELSE IF (@GroupName = 'Sales and Marketing' or @GroupName = 'Research and Development')
            BEGIN
            UPDATE MY_EMPLOYEEPAYHISTORY
            SET Rate = Rate * (1.2)
            WHERE BusinessEntityID = @BusinessEntityID AND Rate = @Rate
            END

    FETCH NEXT FROM EmployeeCursor INTO @BusinessEntityID, @GroupName, @Rate
END
CLOSE EmployeeCursor
DEALLOCATE EmployeeCursor

-- c) Write SQL statement that returns the average salary rate for each group name in the My_Department table
SELECT D.GroupName, AVG(EPH.Rate) as Average
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
    GROUP BY D.GroupName

SELECT D.GroupName, AVG(EPH.Rate) as Average
        FROM AdventureWorksDB.Person.Person AS P
        JOIN AdventureWorksDB.HumanResources.EmployeeDepartmentHistory AS EDH
        ON P.BusinessEntityID = EDH.BusinessEntityID
        JOIN My_EmployeePayHistory AS EPH
        ON P.BusinessEntityID = EPH.BusinessEntityID
        JOIN My_Department as D
        ON EDH.DepartmentID = D.DepartmentID
    WHERE EDH.EndDate IS NULL
    AND EPH.RateChangeDate = (SELECT MAX(EPH.RateChangeDate) 
    FROM AdventureWorksDB.HumanResources.EmployeePayHistory AS EPH
    WHERE P.BusinessEntityID = EPH.BusinessEntityID)
    GROUP BY D.GroupName