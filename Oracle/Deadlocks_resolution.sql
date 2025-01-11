Closure:

- Server Name/DB Name: 
zhbp0dci / BP0

- Problem Description:
automation reported:
Alert Log entry has been found with severity:Warning and Message: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_39125426.trc.  --  Instance Name: BP0

- Root Cause Description: 

The following transaction deadlocks found in the alert log file of BP0 instance is not an ORACLE error. 
It is a deadlock due to user error in the design of an application or from issuing incorrect ad-hoc SQL.

A deadlock is not an ORACLE error and occurs when two or more sessions are waiting for data locked by each other, resulting in all the sessions being blocked. 
Oracle automatically detects and resolves deadlocks by rolling back the statement associated with the transaction that detects the deadlock. 
Typically, deadlocks are caused by poorly implemented locking in application code or from issuing incorrect ad-hoc SQL.

Tue Jan 03 05:07:09 2017
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_45614540.trc.

Wed Jan 11 17:46:52 2017
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_28312642.trc.

Wed Jan 11 17:56:16 2017
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_58327630.trc.

Mon Jan 16 15:26:14 2017
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_46990074.trc.

Tue Feb 14 15:40:25 2017
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_43385668.trc.

Mon Feb 27 05:08:38 2017
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_34079256.trc.

Thu Mar 02 10:37:14 2017
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_12059482.trc.
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_39125426.trc.
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_12059482.trc.
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_39125426.trc.
ORA-00060: Deadlock detected. More info in file /oracle/BP0/saptrace/background/diag/rdbms/bp0/BP0/trace/BP0_ora_12059482.trc.

- Corrrective action taken:

There is nothing to be made at Oracle DBA side, so we are sending the ticket for application analysis alon with trace files

To resolve the issue, make sure that rows in tables are always locked in the same order. 
For example, in the case of a master-detail relationship, you might decide to always lock a row in the master table before locking a row in the detail table.

Please do the needfull to correct the application code. 