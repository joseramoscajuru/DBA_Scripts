
select *
 from v$dataguard_status
 where severity in ('Error','Fatal')
 and timestamp > (sysdate -1);


Good health = no rows returned

If the query returns rows, then raise an alert with the returned output.

