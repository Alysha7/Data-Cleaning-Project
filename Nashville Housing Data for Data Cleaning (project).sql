

  --cleaning data in SQL queries
  select *
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]

 --standardize date format

   select SaleDateconverted, convert(date,SaleDate)
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]

 update [Nashville Housing Data for Data Cleaning ]
 set SaleDate = convert(date,SaleDate)

 alter table [Nashville Housing Data for Data Cleaning ]
 add SaleDateconverted Date; 
 
 update [Nashville Housing Data for Data Cleaning ]
 set SaleDateconverted = convert(date,SaleDate)
  

  --populate property address data

  select *
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]
 --where PropertyAddress is null
 order by ParcelID


 select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ] a
 join PortfolioProject..[Nashville Housing Data for Data Cleaning ] b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID] <> b.[UniqueID]
 where a.PropertyAddress is null

update a
set PropertyAddress= isnull(a.PropertyAddress, b.PropertyAddress)
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ] a
 join PortfolioProject..[Nashville Housing Data for Data Cleaning ] b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID] <> b.[UniqueID]
  where a.PropertyAddress is null


  --Breaking out Address into Individual Colums (Address, City, State)

  select PropertyAddress
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]
 --where PropertyAddress is null
 --order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address 

from PortfolioProject..[Nashville Housing Data for Data Cleaning ]



 alter table [Nashville Housing Data for Data Cleaning ]
 add PropertySplitAddress Nvarchar(255); 
 
 update [Nashville Housing Data for Data Cleaning ]
 set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

  alter table [Nashville Housing Data for Data Cleaning ]
 add PropertySplitCity Nvarchar(255); 
 
 update [Nashville Housing Data for Data Cleaning ]
 set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))



 select*
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]


  select OwnerAddress
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]


 select 
 PARSENAME(replace(OwnerAddress, ',', '.') ,3)
 ,PARSENAME(replace(OwnerAddress, ',', '.') ,2)
 ,PARSENAME(replace(OwnerAddress, ',', '.') ,1)
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]



  alter table [Nashville Housing Data for Data Cleaning ]
 add OwnerSplitAddress Nvarchar(255); 
 
 update [Nashville Housing Data for Data Cleaning ]
 set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.') ,3)


  alter table [Nashville Housing Data for Data Cleaning ]
 add OwnerSplitCity Nvarchar(255); 
 
 update [Nashville Housing Data for Data Cleaning ]
 set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.') ,2)


   alter table [Nashville Housing Data for Data Cleaning ]
 add OwnerSplitState Nvarchar(255); 
 
 update [Nashville Housing Data for Data Cleaning ]
 set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.') ,1)



 --Change Y and N to Yes and No in "Sold as Vacant" field 

  select distinct(SoldAsVacant), count(SoldAsVacant)
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]
 group by SoldAsVacant
 order by 2



 select SoldAsVacant
 , case when SoldAsVacant = 'Y' then 'Yes' 
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant 
		end
 from PortfolioProject..[Nashville Housing Data for Data Cleaning ]


 update PortfolioProject..[Nashville Housing Data for Data Cleaning ]
 set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes' 
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant 
		end


--Remove Duplictes

WITH RowNumCTE as(
select*,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
				   UniqueID 
				   ) row_num 
from PortfolioProject..[Nashville Housing Data for Data Cleaning ]
--order by ParcelID
)
delete
from RowNumCTE
where row_num > 1 
--order by PropertyAddress



select* 
from PortfolioProject..[Nashville Housing Data for Data Cleaning ]



--Delete Unused Columns


select* 
from PortfolioProject..[Nashville Housing Data for Data Cleaning ]


alter table PortfolioProject..[Nashville Housing Data for Data Cleaning ]
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject..[Nashville Housing Data for Data Cleaning ]
drop column SaleDate

