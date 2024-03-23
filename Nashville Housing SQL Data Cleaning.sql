/*

Data Cleaning in SQL

Skills Used: filtering, updating attributes, nested queries, dropping and creating tables

Dataset: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx

*/


#snapshot of data
SELECT *
FROM nashvillehousing;


#standardizing date
SELECT DATE_FORMAT(SaleDate, '%Y-%m-%d') AS StandardizedDate
FROM nashvillehousing;


#looking for null values in columns of interest
SELECT *
FROM NashvilleHousing
WHERE ParcelID IS NULL 
	OR HousingType IS NULL
	OR PropertyAddress IS NULL
	OR SaleDate IS NULL
	OR SalePrice IS NULL
	OR OwnerName IS NULL
	OR Acreage IS NULL
	OR LandValue IS NULL
	OR BuildingValue IS NULL
	OR TotalValue IS NULL
	OR YearBuilt IS NULL
	OR Bedrooms IS NULL
	OR FullBath IS NULL
	OR HalfBath IS NULL;


#filter data for properties meeting specific conditions using nested query
SELECT 
    PropertyAddress, 
    SaleDate,
    TotalValue,
    Acreage, 
    YearBuilt,
    Bedrooms,
    FullBath,
    HalfBath
FROM NashvilleHousing
WHERE SaleDate > 2000
AND TotalValue >= 1000000
AND Acreage >= 1.00
AND YearBuilt BETWEEN '1900-01-01' AND '1950-12-31'
AND Bedrooms >= (
    SELECT MIN(Bedrooms)
    FROM NashvilleHousing
    WHERE SaleDate > 2000
    AND TotalValue >= 1000000
    AND Acreage >= 1.00
    AND YearBuilt BETWEEN '1900-01-01' AND '1950-12-31'
)
GROUP BY
	PropertyAddress,
    SaleDate,
    TotalValue,
    Acreage,
    YearBuilt,
    Bedrooms,
    FullBath,
    HalfBath
ORDER BY TotalValue 
DESC; 


#add new columns
ALTER TABLE NashvilleHousing
ADD COLUMN StreetAddress VARCHAR(255),
ADD COLUMN City VARCHAR(255);


#turn safe mode off
SET sql_safe_updates = 0;


#update new columns
UPDATE NashvilleHousing
SET StreetAddress = SUBSTRING_INDEX(PropertyAddress, ', ', 1),
    City = SUBSTRING_INDEX(PropertyAddress, ', ', -1);


#turn safe mode back on
SET sql_safe_updates = 1;

  
#alter column name
ALTER TABLE NashvilleHousing
CHANGE LandUse HousingType VARCHAR(255);

----------------------------------------------------------------------------------------------------------------

/*
CHANGING POSITION OF COLUMNS BY CREATING NEW TABLE
*/


#create new table
CREATE TABLE new_table_name (
    UniqueID int,
    ParcelID text,
    HousingType VARCHAR(255),
    StreetAddress VARCHAR (255),
    City VARCHAR (255),
    SaleDate text,
    SalePrice int,
    LegalReference text,
    SoldAsVacant text,
    OwnerName text,
    OwnerAddress text,
    Acreage double,
    TaxDistrict text,
    LandValue int,
    BuildingValue int,
    TotalValue int,
    YearBuilt int,
    Bedrooms int,
    FullBath int,
    HalfBath int
);

#copy data
INSERT INTO new_table_name (UniqueID, ParcelID, HousingType, StreetAddress, City, SaleDate, SalePrice, LegalReference,
				SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue,
                TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath)
SELECT UniqueID, ParcelID, HousingType, StreetAddress, City, SaleDate, SalePrice, LegalReference,
				SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue,
                TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath
FROM NashvilleHousing;


#drop old table
DROP TABLE NashvilleHousing;

#rename new table to old table name
ALTER TABLE new_table_name RENAME TO NashvilleHousing;

#checking number of homes sold by city
SELECT City, COUNT(ParcelID) AS TotalHousesSold
FROM NashvilleHousing
GROUP BY City
ORDER BY TotalHousesSold
DESC;

#checking for empty values based on new table
SELECT *
FROM NashvilleHousing
WHERE StreetAddress IS NULL 
	OR StreetAddress = '';