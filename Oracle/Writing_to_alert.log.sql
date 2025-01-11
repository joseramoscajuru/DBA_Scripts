Writing to the ALERT.LOG file

Users can write messages to the alert.log file. Example:

 -- Write message to alert.log
 exec dbms_system.ksdwrt(2, 'Testing writing to the alert.log file using DBMS_SYSTEM package');
 PL/SQL procedure successfully completed.

 -- Flush the buffer
 exec dbms_system.ksdfls;
 PL/SQL procedure successfully completed.