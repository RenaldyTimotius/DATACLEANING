

--Cleaning Data in SQL Queries
SELECT *
FROM PortfolioProject..NASHVILLE




--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
SELECT SALEDATECONVERTED,CONVERT(DATE,SALEDATE)
FROM PortfolioProject..NASHVILLE

UPDATE NASHVILLE
SET SALEDATE = CONVERT(DATE,SALEDATE)


-- If it doesn't Update properly
ALTER TABLE NASHVILLE
ADD SALEDATECONVERTED DATE;

UPDATE NASHVILLE
SET SALEDATECONVERTED = CONVERT(DATE,SALEDATE)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
SELECT PROPERTYADDRESS
FROM PortfolioProject..NASHVILLE

SELECT A.PARCELID,A.PROPERTYADDRESS,B.PARCELID,B.PROPERTYADDRESS,ISNULL(A.PROPERTYADDRESS,B.PROPERTYADDRESS)
FROM PortfolioProject..NASHVILLE A
INNER JOIN PortfolioProject..NASHVILLE B
ON A.PARCELID = B.PARCELID
AND A.UNIQUEID <> B.UNIQUEID
WHERE A.PROPERTYADDRESS IS NULL

UPDATE A
SET PROPERTYADDRESS = ISNULL(A.PROPERTYADDRESS,B.PROPERTYADDRESS)
FROM PortfolioProject..NASHVILLE A
INNER JOIN PortfolioProject..NASHVILLE B
ON A.PARCELID = B.PARCELID
AND A.UNIQUEID <> B.UNIQUEID
WHERE A.PROPERTYADDRESS IS NULL
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT *
FROM PortfolioProject..NASHVILLE

SELECT
PARSENAME(REPLACE(PROPERTYADDRESS,',' , '.'),2)
FROM PortfolioProject..NASHVILLE
SELECT
PARSENAME(REPLACE(PROPERTYADDRESS,',' , '.'),1)
FROM PortfolioProject..NASHVILLE

ALTER TABLE NASHVILLE
ADD PROPERTYSPLITADDRESS NVARCHAR(255);

UPDATE NASHVILLE
SET PROPERTYSPLITADDRESS = PARSENAME(REPLACE(PROPERTYADDRESS,',' , '.'),2)

ALTER TABLE NASHVILLE
ADD PROPERTYSPLITCITY NVARCHAR(255);

UPDATE NASHVILLE
SET PROPERTYSPLITCITY = PARSENAME(REPLACE(PROPERTYADDRESS,',' , '.'),1)


SELECT *
FROM PortfolioProject..NASHVILLE

SELECT
PARSENAME(REPLACE(OWNERADDRESS,',' , '.'),3)
FROM PortfolioProject..NASHVILLE
SELECT
PARSENAME(REPLACE(OWNERADDRESS,',' , '.'),2)
FROM PortfolioProject..NASHVILLE
SELECT
PARSENAME(REPLACE(OWNERADDRESS,',' , '.'),1)
FROM PortfolioProject..NASHVILLE

ALTER TABLE NASHVILLE
ADD OWNERSPLITADDRESS NVARCHAR(255);

UPDATE NASHVILLE
SET OWNERSPLITADDRESS = PARSENAME(REPLACE(OWNERADDRESS,',' , '.'),3)

ALTER TABLE NASHVILLE
ADD OWNERSPLITCITY NVARCHAR(255);

UPDATE NASHVILLE
SET OWNERSPLITCITY = PARSENAME(REPLACE(OWNERADDRESS,',' , '.'),2)

ALTER TABLE NASHVILLE
ADD OWNERSPLITSTATE NVARCHAR(255);

UPDATE NASHVILLE
SET OWNERSPLITSTATE = PARSENAME(REPLACE(OWNERADDRESS,',' , '.'),1)

SELECT *
FROM PortfolioProject..NASHVILLE
--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SOLDASVACANT),COUNT(SOLDASVACANT)
FROM PortfolioProject..NASHVILLE
GROUP BY SOLDASVACANT 
ORDER BY 2

SELECT SOLDASVACANT
, CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
		WHEN SOLDASVACANT = 'N' THEN 'NO'
		ELSE SOLDASVACANT
		END
FROM PortfolioProject..NASHVILLE

UPDATE NASHVILLE
SET SOLDASVACANT = CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
		WHEN SOLDASVACANT = 'N' THEN 'NO'
		ELSE SOLDASVACANT
		END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH ROWNUMCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY PARCELID,
				 PROPERTYADDRESS,
				 SALEPRICE,
				 SALEDATE,
				 LEGALREFERENCE
				 ORDER BY UNIQUEID
				 ) ROW_NUM
FROM PortfolioProject..NASHVILLE
)
SELECT *
FROM ROWNUMCTE
WHERE ROW_NUM > 1
ORDER BY PROPERTYADDRESS



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns
SELECT *
FROM PortfolioProject..NASHVILLE

ALTER TABLE NASHVILLE
DROP COLUMN OWNERADDRESS,TAXDISTRICT,PROPERTYADDRESS,SALEDATE













-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



















