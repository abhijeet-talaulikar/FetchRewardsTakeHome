# The following query produces the top 5 brands in the most recent month that had complete data.
# This means, although the most recent month in data was March 2021, the transactions after January 2022 had missing brand codes.
# Hence, I have taken January 2021 as the most recent month for the purpose of answering this business question.

with date_of_interest as (
	select 
		month(max(dateScanned)) as recent_month, 
		year(max(dateScanned)) as recent_year,
        1 as recent_data_month
	from receipts
),
brandcounts as (
	select 
		it.brandCode,
		count(distinct t.receiptId) as receiptcounts
	from transactions as t
	inner join transactionItems as i on t.id = i.transactionId
	inner join items it on i.barcode = it.barcode
    inner join date_of_interest as d on 1=1
    inner join receipts as r on t.receiptId = r.id and month(r.dateScanned) = d.recent_data_month and year(r.dateScanned) = d.recent_year
	group by 1
),
brandranks as (
	select
		*,
		dense_rank() over (order by receiptcounts desc) as rnk
	from brandcounts
)
select
	*
from brandranks
order by 2 desc
limit 5;