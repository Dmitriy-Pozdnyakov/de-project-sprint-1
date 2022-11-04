TRUNCATE TABLE analysis.tmp_rfm_monetary_value;
INSERT INTO analysis.tmp_rfm_monetary_value

with user_total_payment as (
	select 
		o.user_id 
		,sum(o.payment) as total_payment
	from analysis.orders o
	inner join analysis.orderstatuses o2
		on o.status = o2.id
		and o2.key = 'Closed'
		and extract(year from o.order_ts)::int = 2022
	group by o.user_id 
	order by total_payment desc, o.user_id 
),
 user_payment_rank as (
	select 
		u.id as user_id 
		,coalesce(utp.total_payment,0) as total_payment
		,row_number() over (order by coalesce(utp.total_payment,0)) as cnt_rank
	from analysis.users u
	left join user_total_payment utp
		on u.id = utp.user_id
)
select 
	upr.user_id 
--	,total_payment
	,ub.bucket as monetary_value 
from user_payment_rank upr
inner join analysis.user_bucket_view ub
	on upr.cnt_rank between ub.start_bucket_border 
	and ub.end_bucket_border;
  
