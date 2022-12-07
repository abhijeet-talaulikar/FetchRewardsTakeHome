# The following code produces the brand with most number of transactions by users who joined in the recent 6 months.

with new_users as (
	select
		*
	from users as u
    where createdDate >= date_add((select max(createdDate) from users), interval -6 month)
    order by createdDate
)
select
	*
from
(
	select
		*,
		rank() over (order by num_transactions desc) as brandRank
	from
	(
		select
			i.brandCode,
			count(distinct tr.id) as num_transactions
		from transactionItems as t
		inner join transactions as tr on t.transactionId = tr.id
		inner join items as i on t.barcode = i.barcode
		inner join new_users as u on tr.userId = tr.userid
		group by 1
	) x
) y
where brandRank = 1