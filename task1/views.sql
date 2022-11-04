CREATE VIEW analysis.orderitems AS
SELECT * FROM production.orderitems;

CREATE VIEW analysis.orders AS
SELECT * FROM production.orders;

CREATE VIEW analysis.orderstatuses AS
SELECT * FROM production.orderstatuses;

CREATE VIEW analysis.orderstatuslog AS
SELECT * FROM production.orderstatuslog;

CREATE VIEW analysis.products AS
SELECT * FROM production.products;

CREATE VIEW analysis.users AS
SELECT * FROM production.users;

--вспомогательное представление, показывающее границы для 5 бакетов, каждой метрики использующейся в итоговой витрине
CREATE VIEW analysis.user_bucket_view AS
with a as (
	select 
		count(id) as cnt 
	from analysis.users
	), b as
(select 
	1 as bucket 
	,(select cnt/5 from a) as end_bucket_border
union 
select 
	2 as bucket 
	,(select cnt/5*2 from a) as end_bucket_border
union 
select 
	3 as bucket 
	,(select cnt/5*3 from a) as end_bucket_border
union 
select 
	4 as bucket 
	,(select cnt/5*4 from a) as end_bucket_border	
union 
select 
	5 as bucket 
	,(select cnt from a) as end_bucket_border
order by bucket)
select  
	*
	,coalesce(lag(end_bucket_border,1) over (order by bucket),0)+1 as start_bucket_border
from b;