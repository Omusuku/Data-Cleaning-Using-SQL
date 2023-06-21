
Cleaning Data in SQL Queries



SELECT *
from PortfolioProject..HousingData


--Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject..HousingData


Update PortfolioProject..HousingData
Set SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE PortfolioProject..HousingData
Add SaleDateConverted Date;

Update PortfolioProject..HousingData
SET SaleDateConverted = CONVERT(Date,SaleDate)


--POpulate Property Address Data

SELECT *
from PortfolioProject..HousingData
Where PropertyAddress is null


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..HousingData a
Join PortfolioProject..HousingData b
on a.ParcelID = b.ParcelID
And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..HousingData a
Join PortfolioProject..HousingData b
on a.ParcelID = b.ParcelID
And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


--Breaking Out Address IntoIndivdual Columes (Address, City, State)

SELECT PropertyAddress
from PortfolioProject..HousingData
--Where PropertyAddress is null
--order by ParceID


Select 
SUBSTRING(propertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(propertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyAddress)) as Address
From PortfolioProject..HousingData




ALTER TABLE PortfolioProject..HousingData
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfolioProject..HousingData
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


SELECT *
from PortfolioProject..HousingData



Select *
From PortfolioProject..HousingData





Select OwnerAddress
From PortfolioProject..HousingData


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject..HousingData


ALTER TABLE PortfolioProject..HousingData
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject..HousingData
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject..HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject..HousingData
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject..HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject..HousingData





-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..HousingData
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..HousingData


Update PortfolioProject..HousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject..HousingData
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject..HousingData



-- Delete Unused Columns



Select *
From PortfolioProject..HousingData


ALTER TABLE PortfolioProject..HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

