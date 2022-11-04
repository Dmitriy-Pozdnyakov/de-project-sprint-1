CREATE VIEW analysis.orders as

 with last_status as (
 	select order_id, status 
 	from (
		select 
			order_id
			,status_id as status
			,row_number() over(partition by order_id order by dttm desc) as rn
		from production.orderstatuslog
	)t
	where rn = 1
)
select 
	o.order_id
	,o.order_ts
	,o.user_id
	,o.bonus_payment
	,o.payment
	,o."cost"
	,o.bonus_grant
	,ls.status
from production.orders o
inner join last_status ls
	on o.order_id = ls.order_id
 