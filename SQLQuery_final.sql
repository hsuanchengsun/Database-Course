-- Create values for CHANNELS_CLASS
INSERT INTO CHANNELS_CLASS
VALUES (1, 'DIRECT'), (2, 'INDIRECT'), (3, 'OTHERS')

-- Create values for CUST_GENDER
INSERT INTO CUST_GENDER
VALUES (1, 'F'), (2, 'M')

-- Create values for CUST_MARITAL_STATUS
INSERT INTO CUST_MARITAL_STATUS
VALUES (1, 'MARRIED'), (2, 'DIVORCED'), (3, 'WIDOW'), (4, 'SEPARATED'), (5, 'SINGLE'), (6, NULL)

-- Create values for CUST_INCOME_LEVEL
INSERT INTO CUST_INCOME_LEVEL
VALUES (1, UPPER('“A: Below 30,000“')), (2, UPPER('“B: 30,000 - 49,999“')), (3, UPPER('“C: 50,000 - 69,999“')), 
(4, UPPER('“D: 70,000 - 89,999“')), (5, UPPER('“E: 90,000 - 109,999“')), (6, UPPER('“F: 110,000 - 129,999“')), 
(7, UPPER('“G: 130,000 - 149,999“')), (8, UPPER('“H: 150,000 - 169,999“')), (9, UPPER('“I: 170,000 - 189,999“')),
(10, UPPER('“J: 190,000 - 249,999“')), (11, UPPER('“K: 250,000 - 299,999“')), (12, UPPER('“L: 300,000 and above“')),
(13, NULL)

-- Create values for PRODUCTS_CATEGORY
INSERT INTO PRODUCTS_CATEGORY
VALUES (1, 'ELECTRONICS'), (2, 'HARDWARE'), (3, 'PERIPHERALS AND ACCESSORIES'), (4, 'PHOTO'), (5, 'SOFTWARE/OTHER')

-- Create values for PRODUCTS_SUBCATEGORY
INSERT INTO PRODUCTS_SUBCATEGORY
VALUES (1, UPPER('Accessories'), 3), (2, UPPER('Bulk Pack Diskettes'), 5), (3, 'CD-ROM', 3), (4, UPPER('Camcorders'), 4), (5, UPPER('Camera Batteries'), 4),
(6, UPPER('Camera Media'), 4), (7, UPPER('Cameras'), 1), (8, UPPER('Desktop PCs'), 2), (9, UPPER('Documentation'), 5), (10, UPPER('Game Consoles'), 1),
(11, UPPER('Home Audio'), 1), (12, UPPER('Memory'), 3), (13, UPPER('Modems/Fax'), 3), (14, UPPER('Monitors'), 3), (15, UPPER('Operating Systems'), 5),
(16, UPPER('Portable PCs'), 2), (17, UPPER('Printer Supplies'), 3), (18, UPPER('Recordable CDs'), 5), (19, UPPER('Recordable DVD Discs'), 5), 
(20, UPPER('Y Box Accessories'), 1), (21, UPPER('Y Box Games'), 1)


-- Create values for PROMOTIONS_CATEGORY
INSERT INTO PROMOTIONS_CATEGORY
VALUES (1, 'NO PROMOTION'), (2, 'TV'), (3, 'AD NEWS'), (4, 'FLYER'), (5, 'INTERNET'),
(6, 'MAGAZINE'), (7, 'NEWSPAPER'), (8, 'POST'), (9, 'RADIO')

-- Create values for PROMOTIONS_SUBCATEGORY
INSERT INTO PROMOTIONS_SUBCATEGORY
VALUES (1, 'NO PROMOTION', 1), (2, UPPER('TV commercial'), 2), (3, UPPER('TV program sponsorship'), 2), (4, 'AD', 5), (5, UPPER('ad magazine'), 6),
(6, UPPER('ad news'), 7), (7, UPPER('billboard'), 8), (8, UPPER('coupon magazine'), 6), (9, UPPER('coupon news'), 7), (10, UPPER('downtown billboard'), 8),
(11, UPPER('freeway billboard'), 8), (12, UPPER('general flyer'), 4), (13, UPPER('hospital flyer'), 4), (14, UPPER('household flyer'), 4), (15, UPPER('loyal customer discount'), 5),
(16, UPPER('manufacture rebate magazine'), 6), (17, UPPER('manufacture rebate news'), 7), (18, UPPER('newspaper'), 3), (19, UPPER('online discount'), 5), (20, UPPER('promotion movie'), 2),
(21, UPPER('radio commercial'), 9), (22, UPPER('radio program sponsorship'), 9)

-- Create values for COUNTRY_REGION
INSERT INTO COUNTRY_REGION
VALUES (1, 'AFRICA'), (2, 'AMERICAS'), (3, 'ASIA'), (4, 'EUROPE'), (5, 'OCEANIA')

-- Create values for COUNTRY_SUBREGION
INSERT INTO COUNTRY_SUBREGION
VALUES (1, UPPER('Australia'), 5), (2, UPPER('East Asia'), 3), (3, UPPER('North Asia'), 3), (4, UPPER('NorthWestern Europe'), 4), (5, UPPER('Northern America'), 2),
(6, UPPER('South Asia'), 3), (7, UPPER('SouthWestern Europe'), 4), (8, UPPER('Southern Africa'), 1), (9, UPPER('Southern America'), 2), (10, UPPER('West Africa'), 1)

-- Create values for COUNTRY_NAME
INSERT INTO COUNTRY_NAME
VALUES (1, UPPER('Argentina'), 2), (2, UPPER('Australia'), 1), (3, UPPER('Azania (South Africa)'), 8), (4, UPPER('Brazil'), 9), (5, UPPER('Canada'), 5),
(6, UPPER('China'), 3), (7, UPPER('Denmark'), 4), (8, UPPER('France'), 7), (9, UPPER('Germany'), 4), (10, UPPER('Italy'), 7),
(11, UPPER('Japan'), 3), (12, UPPER('New Zealand'), 1), (13, UPPER('Nigeria'), 10), (14, UPPER('Saudi Arabia'), 2), (15, UPPER('Singapore'), 6),
(16, UPPER('Spain'), 7), (17, UPPER('Turkey'), 7), (18, UPPER('United Kingdom of Great Britain & Northern Ireland'), 7), (19, UPPER('United States of America'), 5)


