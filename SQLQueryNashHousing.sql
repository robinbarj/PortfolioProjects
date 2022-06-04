

select SaleDate2, convert(date, saledate) from dbo.NashvilleHousing

alter table NashvilleHousing
	add SaleDate2 Date



update NashvilleHousing 
	set SaleDate2 = convert(date, saledate)

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull( a.PropertyAddress, b.PropertyAddress)
from dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
	where a.PropertyAddress is null

Update a
	set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
	from dbo.NashvilleHousing a
	Join dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
	where a.PropertyAddress is null


Select
SUBSTRING (PropertyAddress, 1, charindex( ',', PropertyAddress)-1) as Address
, Substring(PropertyAddress, charindex( ',', PropertyAddress) +1, len(PropertyAddress)) as City
from dbo.NashvilleHousing

Alter table NashvilleHousing
add PropertysAddress nvarchar(255);

Update NashvilleHousing
set PropertysAddress = SUBSTRING (PropertyAddress, 1, charindex( ',', PropertyAddress)-1)

Alter Table NashvilleHousing
add PropertyCity nvarchar(255);

Update NashvilleHousing
set PropertyCity = Substring(PropertyAddress, charindex( ',', PropertyAddress) +1, len(PropertyAddress))

Select * from dbo.NashvilleHousing

Select
Parsename (Replace(OwnerAddress, ',', '.'), 3),
Parsename (Replace(OwnerAddress, ',', '.'), 2),
Parsename (Replace(OwnerAddress, ',', '.'), 1)
from dbo.NashvilleHousing

Alter table NashvilleHousing
add OwnersAddress nvarchar(255);

Alter table NashvilleHousing
add OwnersCity nvarchar(255);

Alter table NashvilleHousing
add OwnersState nvarchar(255)

Update NashvilleHousing
set OwnersAddress = Parsename (Replace(OwnerAddress, ',', '.'), 3)

Update NashvilleHousing
set OwnersCity = Parsename (Replace(OwnerAddress, ',', '.'), 2)

Update NashvilleHousing
set OwnersState = Parsename (Replace(OwnerAddress, ',', '.'), 1)

Select * from dbo.NashvilleHousing

Select Distinct(SoldAsVacant), Count(SoldasVacant)
from dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldasVacant = 'N' then 'No'
	else SoldAsVacant
	End
from dbo.NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldasVacant = 'N' then 'No'
	else SoldAsVacant
	End

with RowNumcte as(
Select *,
Row_Number() over(
	Partition by ParcelID,
				PropertyAddress,
				SalePrice, 
				SaleDate,
				LegalReference
				order by UniqueID
) rowNum
from dbo.NashvilleHousing
)

Select *

from RowNumcte
where rownum >1
order by PropertyAddress

Delete 
from RowNumcte
where rownum >1

Select *

from RowNumcte
where rownum >1
order by PropertyAddress

Alter Table dbo.NashvilleHousing
drop column OwnerAddress,PropertyAddress, SaleDate, TaxDistrict

Select * from dbo.NashvilleHousing

