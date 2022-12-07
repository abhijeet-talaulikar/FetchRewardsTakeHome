with points_from_receiptitems as (
	select 
		receiptId,
        sum(pointsEarned) as pointsEarned
	from rewardreceiptitems
	group by 1
)
select
	r.id as receiptId,
    r.pointsEarned as pointsEarned_fromReceipt,
    p.pointsEarned as pointsEarned_fromReceiptItems
from receipts as r
inner join points_from_receiptitems as p on r.id = p.receiptId;