ALTER USER username ACCOUNT LOCK;

ALTER USER RMAN ACCOUNT UNLOCK;

desc dba_users

select USERNAME, ACCOUNT_STATUS, LOCK_DATE, EXPIRY_DATE, PASSWORD,PROFILE from dba_users where username='####';

select USERNAME, ACCOUNT_STATUS, LOCK_DATE, EXPIRY_DATE, PASSWORD,PROFILE from dba_users where ACCOUNT_STATUS like '%EXPIRED%' or ACCOUNT_STATUS like '%LOCKED%';


USERNAME                       ACCOUNT_STATUS                   LOCK_DATE EXPIRY_DA PASSWORD
------------------------------ -------------------------------- --------- --------- ------------------------------
RMAN                           EXPIRED                                    03-FEB-11 			E7B5D92911C831E1

######Alterar senha pela mesma
ALTER USER <user> IDENTIFIED BY VALUES 'E7B5D92911C831E1';

#### Alterar profile
 alter user <user> profile IBMPROFILE;

