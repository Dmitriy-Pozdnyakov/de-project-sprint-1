TRUNCATE TABLE analysis.tmp_rfm_frequency;
INSERT INTO analysis.tmp_rfm_frequency

with closed_orders_22 as (
	select 
		o.user_id
		,o.order_id
	from analysis.orders o
	inner join analysis.orderstatuses o2
		on o.status = o2.id
		and o2.key = 'Closed'
		and extract(year from o.order_ts)::int = 2022
),  user_orders_rank as
	(select 
		u.id as user_id 
		,count(c.order_id) as cnt_order
		,row_number() over (order by count(order_id)) as cnt_rank
	from analysis.users u
	left join closed_orders_22 c
		on u.id = c.user_id
	group by  u.id)
select 
	uor.user_id 
--	,cnt_order
	,ub.bucket as frequency
from user_orders_rank uor
inner join analysis.user_bucket_view ub
	on uor.cnt_rank between ub.start_bucket_border 
	and ub.end_bucket_border