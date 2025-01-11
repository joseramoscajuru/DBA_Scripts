#Desbloqueando senha de usurio

select ACCOUNT_STATUS, EXPIRY_DATE from dba_users where USERNAME='ESSBASECUBE';
 
ALTER USER ESSBASECUBE ACCOUNT UNLOCK;



However, as DBA you can extract the encrypted password from the dba_users view, save it, and re-set the password after you have finished your testing.
 
For example, assume that you need to sign-on as FRED and test their Oracle privileges:


STEP 1:  First, we extract the encrypted password:

select 
'alter user "'||username||'" identified by values '''||extract(xmltype(dbms_metadata.get_xml('USER',username)),'//USER_T/PASSWORD/text()').getStringVal()||''';'  old_password 
from 
   dba_users
where
username = 'SAPDAT';
 
OLD_PASSWORD
--------------------------------------------------------------------
alter user "FRED" identified by values '15EC3EC6EAF863C';


STEP 2:  You can now change FREDs password and sigh-on for testing:


alter user FRED identified by FLINTSTONE;
connect fred/flintstone;
select stuff from tables;

STEP 3:  When you have completed your testing you can set-back the original encrypted password using the output from the query in step 1:



alter user "FRED" identified by values '15EC3EC6EAF863C';

