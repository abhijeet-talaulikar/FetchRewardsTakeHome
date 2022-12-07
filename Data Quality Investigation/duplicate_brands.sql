## PREMISE
# There is ambiguity in the brands and items tables. Many brands do not have a brandCode, this is an issue. 
# More importantly, some brands (Huggies and Goodnite) have more than 1 records with different names but same brandCode. 
# It is also unclear whether Uuid or brandCode is the unique identifier ideally.

# Get total brand codes and total unique brand codes
select count(brandCode), count(distinct brandCode) from brands;

# Get duplicate brand codes
with duplicate_brands as (
	select 
		brandCode,
        count(*) as records
	from brands
	group by brandCode
	having count(*) > 1
)
select
	b.*,
    d.records
from brands as b
inner join duplicate_brands as d on b.brandCode = d.brandCode
where b.brandCode != ''
order by d.records desc, b.brandCode;

# Spotlight on Huggies and Goodnites for having duplicate records with same brandcode but spelling errors in name.
select 
	*
from brands
where lower(name) in ('huggies','goodnites');

## SOLUTION
# Reconcile data from sources appropriately
# Check spelling and case errors in item names