As per Verifying Security Access with Auditing chapter of Database Security Guide, there are several types of auditing, but Standard Auditing is probably the only type of auditing you will need according to the requirements you mentioned in the question.

Before you can use standard auditing, you should enable it (if it already isn not) setting the AUDIT_TRAIL initialization parameter to the appropriate value (refer to the link). I evaluated standard auditing with AUDIT_TRAIL set to DB,EXTENDED which allows to capture SQL statements.

SQL> alter system set audit_trail = db,extended scope=spfile;

System altered.

SQL> startup force;
ORACLE instance started.

Once you have enabled standard auditing, all the auditing policies existing in your database will start to capture the auditing details.

There are four levels in standard auditing: Statement, Privilege, Object, Network. (See the table in the same chapter of Security Guide.)

With the following standard auditing statements of different levels I was able 
to collect some useful auditing information regarding index creation, index rebuild, index drop, and making index unusable.

audit index by access;    
audit create any index;    
audit index on hr.employees by access;

Sample output based on my activity is below.

SQL> select username, sql_text from dba_audit_object order by timestamp;

USERNAME          SQL_TEXT
--------          ------------------------------------------------------
hr                create index audidx on employees(last_name)
hr                alter index audidx rebuild
scott             drop index hr.audidx
scott             create index hr.audidx on hr.employees(last_name)
scott             alter index hr.audidx rebuild
scott             alter index hr.audidx unusable

Make sure you understand what is written in the relevant chapter of Security Guide I referred to, 
and do some experiments before using your newly implemented audit policies in production.