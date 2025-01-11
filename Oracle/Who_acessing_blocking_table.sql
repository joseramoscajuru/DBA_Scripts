 Check Who is Accessing / Locking / Blocking the Oracle Session / Table
If the table is locked by some session in the database you cannot create index or make any changes to that particular table. You will end up with “ORA-00054 resource busy and acquired with NOWAIT specified” error message. You can find out which session is locking your targeted table by using following queries. You may have to kill (in case not needed) the session by following queries.

SQL> create index emp_idx on emp(ename);
create index emp_idx on emp(ename)
                        *
ERROR at line 1:
ORA-00054: resource busy and acquire with NOWAIT specified or timeout expired
Find out the session, Instance (For RAC) details from v$locked_object or gv$locked_object (For RAC) using the following query

SQL> SELECT OBJECT_ID, SESSION_ID, inst_id FROM GV$LOCKED_OBJECT
WHERE OBJECT_ID=(select object_id
FROM dba_objects
where object_name='EMP' and object_type='TABLE' AND OWNER='SCOTT');

 OBJECT_ID SESSION_ID    INST_ID
---------- ---------- ----------
    164540        136          2
You can find out the session, Os process details by using the following query.
SQL> select s.sid, s.serial#,s.inst_id, s.program,p.spid from gv$session s , gv$process p
where  p.addr =s.paddr
and   s.sid in (136)  2    3  ;

       SID    SERIAL#    INST_ID
---------- ---------- ----------
PROGRAM       SPID
---------- ------------------------
       136      11337          2
Sqlplus       43212

In case if you wanted to kill the process which is not a relevant or import one you can use following SQLs.
Syntax: alter system kill session 'SID,SERIAL#,@INST_ID'; (For RAC)
alter system kill session 'SID,SERIAL#';(For Single instance)
SQL>  alter system kill session '136,11337,@2';

System altered.

Now you will be able to proceed with your DDLs.
SQL> create index emp_idx on emp(ename);

Index created.