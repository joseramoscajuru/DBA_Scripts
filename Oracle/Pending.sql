#Querys para pesquisar Pending Session:
select * from dba_2pc_pending;

desc dba_2pc_pending;

SQL> desc DBA_2PC_PENDING;
 Name                                                  Null?    Type
 ----------------------------------------------------- -------- ------------------------------------
 LOCAL_TRAN_ID                                         NOT NULL VARCHAR2(22)
 GLOBAL_TRAN_ID                                                 VARCHAR2(169)
 STATE                                                 NOT NULL VARCHAR2(16)
 MIXED                                                          VARCHAR2(3)
 ADVICE                                                         VARCHAR2(1)
 TRAN_COMMENT                                                   VARCHAR2(255)
 FAIL_TIME                                             NOT NULL DATE
 FORCE_TIME                                                     DATE
 RETRY_TIME                                            NOT NULL DATE
 OS_USER                                                        VARCHAR2(64)
 OS_TERMINAL                                                    VARCHAR2(255)
 HOST                                                           VARCHAR2(128)
 DB_USER                                                        VARCHAR2(30)
 COMMIT#                                                        VARCHAR2(16)

 select DB_USER, OS_USER LOCAL_TRAN_ID from dba_2pc_pending;
 
 exec DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('trans_id');

 desc DBA_2PC_NEIGHBORS (Para ver os outros BDs envolvidos com a Indoubt transaction).

 Forar Commit
 COMMIT FORCE '1.93.29';

select UNIQUE  a.LOCAL_TRAN_ID FROM DBA_2PC_PENDING a, DBA_2PC_NEIGHBORS b where a.LOCAL_TRAN_ID = b.LOCAL_TRAN_ID and DBUSER_OWNER='TCMDBUSER'; 

Please clear dba_2pc_pending table for the following database

desc DBA_2PC_NEIGHBORS

SQL> desc DBA_2PC_NEIGHBORS
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 LOCAL_TRAN_ID                                      VARCHAR2(22)
 IN_OUT                                             VARCHAR2(3)
 DATABASE                                           VARCHAR2(128)
 DBUSER_OWNER                                       VARCHAR2(30)
 INTERFACE                                          VARCHAR2(1)
 DBID                                               VARCHAR2(16)
 SESS#                                              NUMBER(38)
 BRANCH                                             VARCHAR2(128)

 select DBUSER_OWNER, LOCAL_TRAN_ID from DBA_2PC_NEIGHBORS;
 select DATABASE from DBA_2PC_NEIGHBORS;

 
 select UNIQUE a.LOCAL_TRAN_ID, a.STATE FROM DBA_2PC_PENDING a, DBA_2PC_NEIGHBORS b
 where a.LOCAL_TRAN_ID = b.LOCAL_TRAN_ID and DBUSER_OWNER='TCMDBUSER';
 
select distinct DATABASE from DBA_2PC_NEIGHBORS;

select 'execute dbms_transaction.purge_lost_db_entry('''||local_tran_id||''');' from dba_2pc_pending;

exec DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('55.30.136591');
ERROR at line 1:
ORA-06510: PL/SQL: unhandled user-defined exception
ORA-06512: at "SYS.DBMS_TRANSACTION", line 96
ORA-06512: at line 1


execute dbms_transaction.purge_lost_db_entry('22.24.44164');


SQL> execute dbms_transaction.rollback_force('9.23.125989');

PL/SQL procedure successfully completed.

SQL> execute dbms_transaction.PURGE_LOST_DB_ENTRY('9.23.125989');

PL/SQL procedure successfully completed.


execute dbms_transaction.rollback_force('22.24.44164');

execute dbms_transaction.purge_lost_db_entry('22.24.44164');

