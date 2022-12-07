## PREMISE
# The expenditure calculation from individual receipt items (finalSpent_fromReceiptItems) does not sum up 
# to the total given in the data (totalSpent_fromReceipt). 
# Also, itemPrice in the receipt items data does not consider the quantity of item purchased. 
# I presume, the amounts should end up as column expectedTotalSpent_fromReceiptItems after considering the quantity.


with spend_from_transactionitems as (
	select 
		transactionId,
        sum(quantityPurchased) as totalQuantity,
		sum(finalPrice) as finalSpent,
		sum(itemPrice * quantityPurchased) as expectedTotalSpent,
        sum(itemPrice * (quantityPurchased-ifnull(userFlaggedQuantity,0))) as expectedTotalSpent_minusflagged
	from transactionItems
	group by 1
)
select
	t.id as transactionId,
    i.totalQuantity,
    t.totalSpent as totalSpent_fromReceipt,
    i.finalSpent as finalSpent_fromReceiptItems,
    i.expectedTotalSpent as expectedTotalSpent_fromReceiptItems,
    expectedTotalSpent_minusflagged
from transactions as t
inner join spend_from_transactionitems as i on t.id = i.transactionId;

## SOLUTION
# Such totals must not be maintained as columns; they need constant reconciliation when there are adjustments in the receipt. 
# Totals get be calculated easily used a bunch of joins.