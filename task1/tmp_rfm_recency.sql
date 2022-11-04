TRUNCATE TABLE analysis.tmp_rfm_recency;
INSERT INTO analysis.tmp_rfm_recency
 
 with time_last_payment as (
	select 
		o.user_id
		,max(extract(epoch from o.order_ts)) as max_time 
	from analysis.orders o
	inner join analysis.orderstatuses o2
		on o.status = o2.id
		and o2.key = 'Closed'
		and extract(year from o.order_ts)::int = 2022
	group by o.user_id 
 ), user_time_rank as (
 	select 
		u.id as user_id 
		,coalesce(t.max_time,0) as max_time
		,row_number() over (order by coalesce(t.max_time,0)) as time_rank
	from analysis.users u
	left join time_last_payment t
		on u.id = t.user_id
)
select 
	utr.user_id 
--	,utr.max_time
	,ub.bucket as recency
from user_time_rank utr
inner join analysis.user_bucket_view ub
	on utr.time_rank between ub.start_bucket_border and ub.end_bucket_border
 
 