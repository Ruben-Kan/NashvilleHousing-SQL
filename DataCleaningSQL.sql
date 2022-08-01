
-- Cleaning Data in SQL Queries

-------------------------------------------------------------------------------------------------------------------------

-- Displays all records

Select *
From Nashville.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted
From Nashville.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;                     --Alter table by adding new column with Date datatype

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)  --Update table by converting SaleDate to desired format and adding it to new column


 --------------------------------------------------------------------------------------------------------------------------

 -- Populate Property Address data

Select *
From Nashville.dbo.NashvilleHousing
order by ParcelID

--Populate Null PropertyAddress with records that have the same ParcelID and a PropertyAdress
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IsNull(a.PropertyAddress, b.PropertyAddress)
From Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Update records with above
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Propety Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Nashville.dbo.NashvilleHousing

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as [Street Address], SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
From Nashville.dbo.NashvilleHousing

--Add new attributes for Street and City
ALTER TABLE NashvilleHousing
Add PropertyStreetAdress Nvarchar(255);

ALTER TABLE NashvilleHousing
Add PropertyCity Nvarchar(255);

--Add contents to records
Update NashvilleHousing
SET PropertyStreetAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Update NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Propety Address into Individual Columns (Address, City, State)

Select OwnerAddress
From Nashville.dbo.NashvilleHousing

Select PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3), PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2), PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Nashville.dbo.NashvilleHousing

--Add new attributes for Street and City and State
ALTER TABLE NashvilleHousing
Add OwnerStreetAdress Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

--Add contents to records
Update NashvilleHousing
SET OwnerStreetAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From Nashville.dbo.NashvilleHousing
Group By SoldAsVacant
Order By 2

Select SoldAsVacant,
  CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Nashville.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   		 	  
-----------------------------------------------------------------------------------------------------------------------------------------------------------

