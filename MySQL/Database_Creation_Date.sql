
Mentioning a query that can be helpful for listing database names in descending order by creation date time. This query can be helpful.

select distinct table_schema as database_name,
-- table_name,
create_time
from information_schema.tables
where 
-- create_time > adddate(current_date,INTERVAL -2 DAY)
table_schema not in('information_schema', 'mysql','performance_schema','activity_monitor','sys')
and table_type ='BASE TABLE'
-- and table_schema = 'your database name' 
order by create_time desc;

select distinct table_schema as database_name,
create_time
from information_schema.tables
where table_schema = 'sys' 
order by create_time desc;