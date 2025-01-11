#show database role
 SELECT DATABASE_ROLE DBROLE FROM V$DATABASE;

 #start the MRP Process
 ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

 #Stop MRP Process
 ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

 #Show
 show parameter log_archive_dest_2
 show parameter log_archive_dest_state_2;

 #Throubleshooting
 select * from v$dataguard_status;

 SELECT DESTINATION, ERROR FROM V$ARCHIVE_DEST;

col error format a80
col "Archive_dest" format a30
 SELECT DEST_ID "ID",
 STATUS "DB_status",
 DESTINATION "Archive_dest",
 ERROR "Error"
 FROM V$ARCHIVE_DEST WHERE DEST_ID <=5;
            
 #recreate the password file
 test -f orapw$ORACLE_SID && rm orapw$ORACLE_SID; orapwd file=orapw$ORACLE_SID password=PASSWORD

 #Get archive log names for a sequence interval
 SELECT NAME FROM V$ARCHIVED_LOG WHERE THREAD#=1 AND DEST_ID=1 AND SEQUENCE# BETWEEN 35 AND 37;



 

 