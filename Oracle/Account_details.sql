# Account_status 

set pages 999 lines 1000
col username format a30
col profile format a30
col status	format a25
col tablespace	format a30
col temp_ts	format a20
select	username
, profile
,	account_status status
,	created
,	default_tablespace tablespace
,	temporary_tablespace temp_ts
from	dba_users
order	by account_status
/

set pages 999 lines 100
col username	format a20
col status	format a8
col tablespace	format a20
col temp_ts	format a20
select	username
,	account_status status
,	created
,	default_tablespace tablespace
,	temporary_tablespace temp_ts
from	dba_users where username like '%FREIRAC%'
order	by username 
/


select username, profile, account_status from dba_users where lower(username) = 'AFI_TEMP';