## PREMISE
# Items ideally must have unique barcodes, as they encode price and SKU information. 
# I identified several items with the same barcode but different brandCode. 
# This is spurious and would lead to inconsistencies in prices in receipt.

# Get discrepancy between total barcodes and unique barcodes
select count(barcode), count(distinct barcode) from items;

# Get duplicate items with same barcode but different other attributes
with duplicate_items as (
	select 
		barcode,
        count(*) as records
	from items
	group by barcode
	having count(*) > 1
)
select
	i.*,
    d.records
from items as i
inner join duplicate_items as d on i.barcode = d.barcode
where i.barcode != ''
order by d.records desc, i.barcode;

## SOLUTION
# Reconcile data from sources appropriately
# Check spelling and case errors in item names