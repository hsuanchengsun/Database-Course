
-- Question 1 (a)

CREATE TABLE MY_EMPLOYEE
(
	BusinessEntityID  int NOT NULL,
	NationalIDNumber  nvarchar(15) NOT NULL,
	LoginID  nvarchar(256) NOT NULL,
    OrganizationNode hierarchyid,
    JobTitle nvarchar(50) NOT NULL,
    BirthDate date NOT NULL,
    MaritalStatus nchar(1) NOT NULL,
    Gender nchar(1) NOT NULL,
    HireDate date NOT NULL,
    SalariedFlag bit NOT NULL,
    VacationHours smallint NOT NULL,
    SickLeaveHours smallint NOT NULL,
    CurrentFlag bit NOT NULL,
    rowguid uniqueidentifier NOT NULL,
    ModifiedDate datetime NOT NULL,
	
	CONSTRAINT PK_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
	
)

-- Question 1 (b)

INSERT INTO MY_EMPLOYEE
SELECT BusinessEntityID
,    NationalIDNumber
,   LoginID
,   OrganizationNode
,   JobTitle
,   BirthDate
,   MaritalStatus
,   Gender
,   HireDate
,   SalariedFlag
,   VacationHours
,   SickLeaveHours
,   CurrentFlag
,   rowguid
,   ModifiedDate
FROM AdventureWorksDB.HumanResources.Employee

-- Question 1 (c)

CREATE TABLE MY_EMPLOYEEPAYHISTORY
(
	BusinessEntityID  int NOT NULL,
	RateChangeDate  datetime NOT NULL,
	Rate  money NOT NULL,
	PayFrequency tinyint NOT NULL,
    ModifiedDate datetime NOT NULL
	
	CONSTRAINT FK_BusinessEntityID FOREIGN KEY(BusinessEntityID)
		REFERENCES MY_EMPLOYEE (BusinessEntityID)
)

-- Question 1 (d)

INSERT INTO MY_EMPLOYEEPAYHISTORY
SELECT BusinessEntityID
,   RateChangeDate
,   Rate
,   PayFrequency
,   ModifiedDate
FROM AdventureWorksDB.HumanResources.EmployeePayHistory


-- Question 2 (e)
ALTER TABLE MY_EMPLOYEE
ADD CONSTRAINT CONSTRAINT_LOGINID UNIQUE (LOGINID)  

-- Question 2 (f)
ALTER TABLE MY_EMPLOYEE
ADD CONSTRAINT CHECK_GENDER CHECK (UPPER(GENDER) = 'F' OR UPPER(GENDER) = 'M')

-- Question 3 (a)
INSERT INTO MY_EMPLOYEE 
	VALUES (1,						--BusinessEntityID
			'295847284',			--,NationalIDNumber
			'adventure-works\ken0', --LoginID
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

-- Question 3 (b)
INSERT INTO MY_EMPLOYEE 
	VALUES (291,						--BusinessEntityID
			'295847284',			--,NationalIDNumber
			'adventure-works\eva01', --LoginID
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



-- Question 3 (c)
DELETE FROM MY_EMPLOYEE 
WHERE BusinessEntityID = 1;

SELECT * FROM MY_EMPLOYEE
-- Question 3 (d)
UPDATE MY_EMPLOYEE
SET BirthDate = 19690129
WHERE BusinessEntityID = 1;

-- Question 3 (e)
UPDATE MY_EMPLOYEE
SET JobTitle = NULL
WHERE BusinessEntityID = 1;

-- Question 3 (f)
INSERT INTO MY_EMPLOYEE 
	VALUES (292,						--BusinessEntityID
			'295847284',			--,NationalIDNumber
			'adventure-works\ken0', --LoginID
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

-- Question 3 (g)
INSERT INTO MY_EMPLOYEE 
	VALUES (292,						--BusinessEntityID
			'295847284',			--,NationalIDNumber
			'adventure-works\pipi0', --LoginID
			NULL ,					--OrganizationNode
			'Chief Executive Officer',--JobTitle
			'1969-01-29',			--BirthDate
			'S',					--MaritalStatus
			'K',					--Gender
			'2009-01-14',			--HireDate
			1,						--SalariedFlag
			99,						--VacationHours
			69,						--SickLeaveHours
			1,						--CurrentFlag
			NEWID(),				--rowguid
			GETDATE())				--ModifiedDate


-- Question 3 (h)
INSERT INTO MY_EMPLOYEE 
	VALUES (292,						--BusinessEntityID
			'295847284',			--,NationalIDNumber
			'adventure-works\pipi0', --LoginID
			NULL ,					--OrganizationNode
			'Chief Executive Officer',--JobTitle
			'1969-01-29',			--BirthDate
			'S',					--MaritalStatus
			'F',					--Gender
			'2009-01-14',			--HireDate
			1,						--SalariedFlag
			99,						--VacationHours
			69,						--SickLeaveHours
			1,						--CurrentFlag
			NEWID(),				--rowguid
			GETDATE())				--ModifiedDate
