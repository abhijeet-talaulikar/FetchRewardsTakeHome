## PREMISE
# There is not a unified schema for items. Item information is included in the original brands data 
# and original receipts data. 
# The following steps identify that many receipt items are not in brand items and vice versa.

# Get distinct barcodes in items table
select count(distinct barcode) from items;

# Get distinct barcodes from receipt items and notice the discrepancy
select count(distinct barcode) from transactionItems;

# Find the count of items from receipts that are missing in the items table
select count(distinct t.barcode)
from transactionItems t
left join items i on t.barcode = i.barcode
where i.barcode is null;

## SOLUTION
# We need a better strategy to unify the items data into a table with unique barcodes.