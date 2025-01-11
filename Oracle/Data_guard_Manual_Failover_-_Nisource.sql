Manual Failover steps
 =====================
(primary)
 IS GONE!!!!, you are in a sev1!!!!!

(standby)
 2) SQL> SELECT PROTECTION_MODE,PROTECTION_LEVEL,DATABASE_ROLE ROLE,SWITCHOVER_STATUS FROM V$DATABASE;
 3) SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE FINISH FORCE;
 4) SQL> ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY;
 5) SQL> ALTER DATABASE OPEN;
 6) SQL> SELECT PROTECTION_MODE,PROTECTION_LEVEL,DATABASE_ROLE ROLE,SWITCHOVER_STATUS FROM V$DATABASE;
 7) SQL> SELECT TO_CHAR(STANDBY_BECAME_PRIMARY_SCN) FROM V$DATABASE;  ----- Take note

When the old primary server is avaliable
 8) SQL> startup mount;
 9) SQL> flashback database to <SCN_gotten_item 7>;
 10) SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
 11) SQL> alter system set log_archive_dest_state_2='DEFER';
 12) SQL> shutdown immediate;
 13) SQL> startup mount;

(database role primary now)
 14) SQL> alter system set log_archive_dest_state_2='ENABLE';
 15) SQL> shutdown immediate;
 16) SQL> startup ;  

(database role standby now)
 17) SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

(database role primary now)
 18) SQL> alter system switch logfile;
 (database role primary and standby)
 19) check for replication