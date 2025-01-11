
Save an Oracle user password

Oracle Tips by Burleson Consulting

January 3, 2011

Question:  I need be able to sign-on with my end-users accounts to test the functionality of their application.  I know that I can change their password, sign-on, do my testing, and then expire their password, but I don't want to unnecessarily force them my users to change their passwords.  How can I extract a user password, save it, and then restore it after I have completed user testing?

Answer:  A smart DBA always remembers that their customers are the end-users, and it's an Oracle best practice to be unobtrusive as possible.

As an Oracle DBA you sometimes need to sign-on as a specific user to understand the exact nature of their problem.  While it is easy to alter the user ID to make a new password, this is an inconvenience to the end-user because they have to re-set a new password.

However, as DBA you can extract the encrypted password from the dba_users view, save it, and re-set the password after you have finished your testing.
 
For example, assume that you need to sign-on as FRED and test their Oracle privileges:


STEP 1:  First, we extract the encrypted password:

select
'alter user "'||username||'" identified by values '''||extract(xmltype(dbms_metadata.get_xml('USER',username)),'//USER_T/PASSWORD/text()').getStringVal()||''';'  old_password
from
   dba_users
where
username = ‘FRED’;
 
OLD_PASSWORD
--------------------------------------------------------------------
alter user "FRED" identified by values '15EC3EC6EAF863C';


STEP 2:  You can now change FRED’s password and sign-on for testing:

alter user FRED identified by FLINTSTONE;
connect fred/flintstone;
select stuff from tables;

STEP 3:  When you have completed your testing you can set-back the original encrypted password using the output from the query in step 1:

alter user "FRED" identified by values '15EC3EC6EAF863C';

Rampant Author, Laurent Schneider adds:

The above works only for case insensitive passwords (10g).

To retrieve 10g and 11g hashes, use the following:

set lin 200 hea off longc 1000000 long 1000000 feed off; exec

DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',TRUE);

select replace(DBMS_METADATA.GET_DDL('USER','SCOTT'),'CREATE USER','ALTER USER') from dual;

ALTER USER "SCOTT" IDENTIFIED BY VALUES'S:F0091E6EDDBA71592E8E9A40B1459492C3E7778B5194A5358A0122DF8FA7;F894844C34402B67'
      DEFAULT TABLESPACE "USERS"
      TEMPORARY TABLESPACE "TEMP"; 