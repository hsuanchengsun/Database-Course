CREATE TABLE T1 (
    P int,
    Q varchar(255),
    R int
);

CREATE TABLE T2 (
    P int,
    Q varchar(255),
    R int
);

INSERT INTO T1 (P, Q, R)
VALUES (10, 'A', 5), (15, 'B', 8), (25, 'A', 6)

INSERT INTO T2 (P, Q, R)
VALUES (10, 'B', 6), (25, 'C', 3), (10, 'B', 5)

SELECT *
FROM T1
JOIN T2
ON T1.P = T2.P

SELECT *
FROM T1
JOIN T2
ON T1.Q = T2.Q

SELECT *
FROM T1
LEFT JOIN T2
ON T1.P = T2.P

SELECT *
FROM T1
RIGHT JOIN T2
ON T1.P = T2.P

SELECT * FROM T1
UNION
SELECT * FROM T2

SELECT * FROM T1
INTERSECT
SELECT * FROM T2

SELECT *
FROM T1
JOIN T2
ON T1.R = T2.R AND T1.P = T2.P

CREATE TABLE RESERVES (
    sid int,
    bid int,
    day date
);

CREATE TABLE SAILORS (
    sid int,
    sname varchar(255),
    rating int,
    age float
);

CREATE TABLE BOATS (
    bid int,
    bname varchar(255),
    color varchar(255)
);

INSERT INTO RESERVES
VALUES (22, 101, '10/10/96'),(58, 103, '11/12/96')

INSERT INTO SAILORS
VALUES (22, 'Dustin', 7, 45.0), (31, 'Lubber', 8, 55.5), (58, 'Rusty', 10, 35.0)

INSERT INTO BOATS
VALUES (101, 'Interlake', 'Blue'), (102, 'Interlake', 'Red'), (103, 'Clipper', 'Green'), (104, 'Marine', 'Red')

SELECT sname
FROM SAILORS
JOIN RESERVES
ON SAILORS.sid = RESERVES.sid
WHERE bid = 101

SELECT sname
FROM SAILORS
JOIN RESERVES
ON SAILORS.sid = RESERVES.sid
JOIN BOATS
ON RESERVES.bid = BOATS.bid
WHERE color = 'Red'

SELECT sname
FROM SAILORS
JOIN RESERVES
ON SAILORS.sid = RESERVES.sid
JOIN BOATS
ON RESERVES.bid = BOATS.bid
WHERE color = 'Red' 
INTERSECT
SELECT sname
FROM SAILORS
JOIN RESERVES
ON SAILORS.sid = RESERVES.sid
JOIN BOATS
ON RESERVES.bid = BOATS.bid
AND color = 'Green'

-- INSERT INTO RESERVES VALUES (58,102,'3/3/20')
SELECT *
FROM SAILORS
JOIN RESERVES
ON SAILORS.sid = RESERVES.sid
JOIN BOATS
ON RESERVES.bid = BOATS.bid
