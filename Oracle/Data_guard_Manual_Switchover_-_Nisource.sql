Manual Switchover steps
  ========================
  primary to standby
  ALTER SYSTEM ARCHIVE LOG CURRENT;
  alter database commit to switchover to standby with session shutdown;
  shutdown immediate;
  startup nomount;
  alter database mount standby database;
  select database_role from v$database;
  alter system set log_archive_dest_state_2='DEFER';
  
  standby to primary
  alter database commit to switchover to primary with session shutdown;
  shutdown immediate;
  startup mount;
  alter database set standby database to maximize performance;
  alter database open;
  select database_role from v$database;
  alter system set log_archive_dest_state_2='ENABLE';
  
  primary to standby
  Start the MRP process: ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
  
  stanbdy to primary
  alter system switch logfile;
