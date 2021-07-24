/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio Project].[dbo].[NashvilleHousing]

  --Standardize Date Format

  select *
  from [Portfolio Project].[dbo].[NashvilleHousing]
  
  Alter table [Portfolio Project].[dbo].[NashvilleHousing]
  add saledateconverted date;

  update [Portfolio Project].[dbo].[NashvilleHousing]
  set saledateconverted = convert(date,SaleDate)

  select saledateconverted , convert(date,saledate)
  from [Portfolio Project].[dbo].[NashvilleHousing]
 
 --Populate Property Address data

 select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
 from [Portfolio Project].[dbo].[NashvilleHousing] a
 join [Portfolio Project].[dbo].[NashvilleHousing] b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from [Portfolio Project].[dbo].[NashvilleHousing] a
 join [Portfolio Project].[dbo].[NashvilleHousing] b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 --Breaking Out Property Address

 select PropertyAddress
 from [Portfolio Project].[dbo].[NashvilleHousing]

 select SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as Address
 from [Portfolio Project].[dbo].[NashvilleHousing]

 select SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(PropertyAddress))as Address
 from [Portfolio Project].[dbo].[NashvilleHousing] 

  Alter table [Portfolio Project].[dbo].[NashvilleHousing]
  add PropertySplitAddress Nvarchar(255);

  update [Portfolio Project].[dbo].[NashvilleHousing]
  set PropertySplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) 

  Alter table [Portfolio Project].[dbo].[NashvilleHousing]
  add PropertySplitCity Nvarchar(255);

  update [Portfolio Project].[dbo].[NashvilleHousing]
  set PropertySplitCity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(PropertyAddress))

  select * 
  from [Portfolio Project].[dbo].[NashvilleHousing]

  select owneraddress
  from [Portfolio Project].[dbo].[NashvilleHousing]

  select PARSENAME(replace(owneraddress,',','.'),3)
  ,PARSENAME(replace(owneraddress,',','.'),2)
  ,PARSENAME(replace(owneraddress,',','.'),1)
  from [Portfolio Project].[dbo].[NashvilleHousing]

  Alter table [Portfolio Project].[dbo].[NashvilleHousing]
  add OwnerSplitAddress Nvarchar(255);

  update [Portfolio Project].[dbo].[NashvilleHousing]
  set OwnerSplitAddress = PARSENAME(replace(owneraddress,',','.'),3)
  
  Alter table [Portfolio Project].[dbo].[NashvilleHousing]
  add OwnerSplitCity Nvarchar(255);

  update [Portfolio Project].[dbo].[NashvilleHousing]
  set OwnerSplitCity = PARSENAME(replace(owneraddress,',','.'),2)
  
  Alter table [Portfolio Project].[dbo].[NashvilleHousing]
  add OwnerSplitState Nvarchar(255);

  update [Portfolio Project].[dbo].[NashvilleHousing]
  set OwnerSplitState = PARSENAME(replace(owneraddress,',','.'),1) 

  select *
  from [Portfolio Project].[dbo].[NashvilleHousing]

  --Changing Y and N into Yes and No in SoldAsVacant 

  select distinct(SoldAsVacant),count(soldasvacant)
  from [Portfolio Project].[dbo].[NashvilleHousing]
  group by SoldAsVacant
  order by 2

  select soldasvacant
  ,case when SoldAsVacant='Y'then 'Yes'
        when SoldAsVacant='N'then 'No'
      else soldasvacant
   end
  from [Portfolio Project].[dbo].[NashvilleHousing]

  Update [Portfolio Project].[dbo].[NashvilleHousing]
  set SoldAsVacant=case when SoldAsVacant='Y'then 'Yes'
        when SoldAsVacant='N'then 'No'
      else soldasvacant
   end

   select SoldAsVacant
   from [Portfolio Project].[dbo].[NashvilleHousing]

   --Remove Duplicates

   with RowNumCTE as(
   select *
   , ROW_NUMBER()over(
   partition by [ParcelID]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
	  Order by
	  uniqueid
	  )row_num
	  from [Portfolio Project].[dbo].[NashvilleHousing]
	  )
	
	 Delete 
	  from RowNumCTE
	  where row_num>1
	
	--Delete Unused Columns
	
	select *
	from [Portfolio Project].[dbo].[NashvilleHousing]

	Alter table [Portfolio Project].[dbo].[NashvilleHousing]
	Drop column PropertyAddress,SaleDate,OwnerAddress,TaxDistrict