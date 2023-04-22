USE [AdventureWorksDB]
GO

-- Question 1: JOIN and CASE Statement
-- (1) LEFT JOIN

SELECT P.BusinessEntityID, P.PersonType, P.FirstName, P.MiddleName, P.LastName, P.EmailPromotion 
FROM Person.Person AS P
LEFT JOIN Sales.PersonCreditCard AS S
ON P.BusinessEntityID = S.BusinessEntityID
WHERE PersonType NOT IN ('EM', 'SP', 'VC') AND CreditCardID IS NULL

-- (2) Same as (1), but use a RIGHT JOIN 
SELECT P.BusinessEntityID, PersonType, FirstName, MiddleName, LastName, EmailPromotion 
FROM Sales.PersonCreditCard AS S
RIGHT JOIN Person.Person AS P
ON P.BusinessEntityID = S.BusinessEntityID
WHERE CreditCardID IS NULL AND PersonType NOT IN ('EM', 'SP', 'VC')

USE [AdventureWorksDB]
GO

-- (3) Write a NESTED QUERY to list all the employees whose salary 
-- is higher than average salary based on employee pay history. 

SELECT EDH.DepartmentID, P.LastName + ', ' + P.FirstName AS name, E.JobTitle, E.HireDate, EPH.Rate
    FROM HumanResources.Employee AS E
    JOIN Person.Person AS P
    ON E.BusinessEntityID = P.BusinessEntityID
    JOIN HumanResources.EmployeeDepartmentHistory AS EDH
    ON E.BusinessEntityID = EDH.BusinessEntityID
    JOIN HumanResources.EmployeePayHistory AS EPH
    ON E.BusinessEntityID = EPH.BusinessEntityID
WHERE RATE > 
    (SELECT AVG(EPH.Rate)
    FROM HumanResources.EmployeePayHistory AS EPH)
ORDER BY EDH.DepartmentID, E.JobTitle, name


-- (4) Same as (3), but your query result should list only the highest hourly rate 
-- for the employees who appeared more than once in the result of (3). 

WITH Rate_CTE (DepartmentID, Name, JobTitle, HireDate, Rate)
AS
(
SELECT EDH.DepartmentID, P.LastName + ', ' + P.FirstName AS name, E.JobTitle, E.HireDate, EPH.Rate
    FROM HumanResources.Employee AS E
    JOIN Person.Person AS P
    ON E.BusinessEntityID = P.BusinessEntityID
    JOIN HumanResources.EmployeeDepartmentHistory AS EDH
    ON E.BusinessEntityID = EDH.BusinessEntityID
    JOIN HumanResources.EmployeePayHistory AS EPH
    ON E.BusinessEntityID = EPH.BusinessEntityID
WHERE RATE > 
    (SELECT AVG(EPH.Rate)
    FROM HumanResources.EmployeePayHistory AS EPH)

)

SELECT Name, JobTitle, HireDate, MAX(Rate)
FROM Rate_CTE
GROUP BY Name, JobTitle, HireDate
HAVING Count(*) > 1
ORDER BY JobTitle, Name

-- (5) Use a CASE statement, write a query for employees whose job title contains ‘Manager’. 
WITH EPH_CTE (BusinessEntityID, Rate)
AS
(
SELECT EPH.BusinessEntityID, EPH.Rate
FROM HumanResources.EmployeePayHistory AS EPH
INNER JOIN(
    SELECT BusinessEntityID, RateChangeDate = MAX(RateChangeDate)FROM HumanResources.EmployeePayHistory
    GROUP BY BusinessEntityID
) AS E
ON EPH.BusinessEntityID = E.BusinessEntityID AND EPH.RateChangeDate = E.RateChangeDate
)
SELECT P.FirstName, P.LastName, EPH_CTE.Rate, E.JobTitle, PayLevel = 
        CASE
            WHEN EPH_CTE.Rate <= 25
                THEN 'LOW'
            WHEN EPH_CTE.Rate >= 45
                THEN 'high'
            ELSE
                'Medium'
        END           
    FROM HumanResources.Employee AS E
    JOIN Person.Person AS P
    ON E.BusinessEntityID = P.BusinessEntityID
    JOIN EPH_CTE
    ON E.BusinessEntityID = EPH_CTE.BusinessEntityID
WHERE JobTitle LIKE '%Manager%'
ORDER BY Rate, JobTitle, LastName

-- (6) Write an SQL statement to create a trigger that will run each time after a modification 
CREATE TRIGGER NotifyOnModification
ON MY_EMPLOYEE
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SELECT CASE
        WHEN EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
            THEN 'Rows have been inserted in MY_EMPLOYEE.'
        WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
            THEN 'Rows have been updated in MY_EMPLOYEE.'
        WHEN NOT EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
            THEN 'Rows have been deleted in MY_EMPLOYEE.'
        ELSE
            'The modification is wrong.'
    END
END

-- (7) Write and run an SQL Statement to test the triggering events of 
-- INSERT, UPDATE, DELETE, and a failed modification.

INSERT INTO MY_EMPLOYEE 
	VALUES (294,						--BusinessEntityID
			'295847284',			--,NationalIDNumber
			'adventure-works\ABC0', --LoginID
			NULL ,					--OrganizationNode
			'Chief Executive Officer',--JobTitle
			'1969-01-29',			--BirthDate
			'S',					--MaritalStatus
			'M',					--Gender
			'2009-01-14',			--HireDate
			1,						--SalariedFlag
			99,						--VacationHours
			69,						--SickLeaveHours
			1,						--CurrentFlag
			NEWID(),				--rowguid
			GETDATE())				--ModifiedDate

UPDATE MY_EMPLOYEE
SET BirthDate = '1970-01-29'
WHERE BusinessEntityID = 294;

DELETE FROM MY_EMPLOYEE 
WHERE BusinessEntityID = 294;

UPDATE MY_EMPLOYEE
SET BirthDate = NULL
WHERE BusinessEntityID = 295;

-- (8) Drop the trigger you created in (6)
DROP TRIGGER NotifyOnModification

-- Part B
-- (1) Create a copy of SALES table from IST302 database to your database. Name this table MY_SALES.
SELECT * 
INTO MY_SALES
FROM IST302.dbo.SALES

-- (2) Create a view for each product in the MY_SALES table.
CREATE VIEW dbo.PRODUCT_SUMMARY_V WITH SCHEMABINDING
AS
SELECT PROD_ID
, YEAR(TIME_ID) AS Year
, MONTH(TIME_ID) AS Month
, SUM(AMOUNT_SOLD) AS TotalAmountSold
, SUM(QUANTITY_SOLD) AS TotalQuantitySold
, CAST(SUM(AMOUNT_SOLD)/SUM(QUANTITY_SOLD) AS DECIMAL (10,2)) AS AverageSalePrice 
FROM dbo.MY_SALES
GROUP BY PROD_ID, YEAR(TIME_ID), MONTH(TIME_ID)

-- (3) Create an indexed view  PRODUCT_SUMMARY_M that correspond to your PRODUCT_SUMMARY_V
CREATE VIEW dbo.PRODUCT_SUMMARY_M WITH SCHEMABINDING
AS
SELECT PROD_ID
, YEAR(TIME_ID) AS Year
, MONTH(TIME_ID) AS Month
, SUM(AMOUNT_SOLD) AS TotalAmountSold
, SUM(QUANTITY_SOLD) AS TotalQuantitySold
, COUNT_BIG(*) AS COUNT
FROM dbo.MY_SALES
GROUP BY PROD_ID, YEAR(TIME_ID), MONTH(TIME_ID)

CREATE UNIQUE CLUSTERED INDEX IDX_PRODUCT_SUMMARY_M ON PRODUCT_SUMMARY_M(PROD_ID, Year, Month)

CREATE VIEW dbo.PRODUCT_SUMMARY_M_AVG WITH SCHEMABINDING
AS
SELECT PROD_ID
, Year
, Month
, TotalAmountSold
, TotalQuantitySold
, CAST(TotalAmountSold/TotalQuantitySold AS DECIMAL (10,2)) AS AverageSalePrice
FROM dbo.PRODUCT_SUMMARY_M

-- (4) Run a query that JOINs PRODUCT_SUMMARY_V and PRODUCTS table
SET STATISTICS TIME ON
GO

SELECT V.PROD_ID, P.PROD_DESC, V.Year, V.Month, V.TotalAmountSold, V.TotalQuantitySold, V.AverageSalePrice  
FROM PRODUCT_SUMMARY_V AS V
JOIN IST302.dbo.PRODUCTS AS P
ON V.PROD_ID = P.PROD_ID
WHERE P.PROD_SUBCATEGORY = 'Documentation' OR P.PROD_SUBCATEGORY = 'Accessories'
GO

SET STATISTICS TIME OFF
GO

-- (5) Save output as above, but the query JOINs PRODUCT_SUMMARY_M_AVG and PRODUCTS table.
SET STATISTICS TIME ON
GO

SELECT M.PROD_ID, P.PROD_DESC, M.Year, M.Month, M.TotalAmountSold, M.TotalQuantitySold, M.AverageSalePrice  
FROM PRODUCT_SUMMARY_M_AVG AS M
JOIN IST302.dbo.PRODUCTS AS P
ON M.PROD_ID = P.PROD_ID
WHERE P.PROD_SUBCATEGORY = 'Documentation' OR P.PROD_SUBCATEGORY = 'Accessories'
GO

SET STATISTICS TIME OFF
GO

-- (7) Same as part B.4 but use an In-Line view that corresponds to PRODUCT_SUMMARY_V.
SET STATISTICS TIME ON
GO

SELECT P.PROD_ID, P.PROD_DESC, V.Year, V.Month, V.TotalAmountSold, V.TotalQuantitySold, V.AverageSalePrice
FROM IST302.dbo.PRODUCTS AS P
JOIN 
(
    SELECT PROD_ID
    , YEAR(TIME_ID) AS Year
    , MONTH(TIME_ID) AS Month
    , SUM(AMOUNT_SOLD) AS TotalAmountSold
    , SUM(QUANTITY_SOLD) AS TotalQuantitySold
    , CAST(SUM(AMOUNT_SOLD)/SUM(QUANTITY_SOLD) AS DECIMAL (10,2)) AS AverageSalePrice 
    FROM dbo.MY_SALES
    GROUP BY PROD_ID, YEAR(TIME_ID), MONTH(TIME_ID)

)AS V
ON V.PROD_ID = P.PROD_ID
WHERE P.PROD_SUBCATEGORY = 'Documentation' OR P.PROD_SUBCATEGORY = 'Accessories'
GO

SET STATISTICS TIME OFF
GO

