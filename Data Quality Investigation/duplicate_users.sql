## PREMISE
# Several users have duplicate records

# Get discrepancy between total user ids and total unique user ids
select count(id), count(distinct id) from users;

# Check if there exist users with duplicate records and varying signUpSource or timestamps 
select 
	id,
	count(*) as records
from users
group by id
having count(distinct createdDate) > 1 or count(distinct lastLogin) > 1 or count(distinct signUpSource) > 1;

# Get all duplicate users
with duplicate_users as (
	select
		id,
        count(*) as records
	from users
	group by id
	having count(*) > 1
)
select
	u.*,
    d.records
from users as u
inner join duplicate_users as d on u.id = d.id
order by d.records desc, u.id;

## SOLUTION
# Since other columns in duplicate records are same, we can drop duplicate rows.