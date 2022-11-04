TRUNCATE TABLE analysis.dm_rfm_segments;
INSERT INTO analysis.dm_rfm_segments

select 
	trf.user_id 
	,trr.recency 
	,trf.frequency 
	,trmv.monetary_value 
from analysis.tmp_rfm_frequency trf 
left join analysis.tmp_rfm_monetary_value trmv 
	on trf.user_id = trmv.user_id 
left join analysis.tmp_rfm_recency trr 
	on trf.user_id = trr.user_id 
order by user_id ;

--вывожу отсортированные первые 10 записей
select *
from analysis.dm_rfm_segments
order by user_id 
limit 10;

-- вывод
-- 0  1  3  4
-- 1  4  3  3
-- 2  2  3  5
-- 3  2  3  3
-- 4  4  3  3
-- 5  5  5  5
-- 6  1  3  5
-- 7  4  2  2
-- 8  1  2  3
-- 9  1  2  2
