select 'alter system kill session '''||sid||','||serial#||''' ;' 
from v$session
where username='LMUSER';

select 'alter system kill session '''||sid||','||serial#||''' ;' , status
from v$session
where username='WM15';

select 'alter system kill session '''||sid||','||serial#||''' ;' , status
from v$session
where username='MDA15';