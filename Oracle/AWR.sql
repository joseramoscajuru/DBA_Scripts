no 9 no tem AWR / ADDM 


1. loga no server
10:08:25 AM: erorci@br.ibm.com - Emerson Rodrigo Orci/Brazil/Contr/IBM: 2. sudo para Oracle
3 . sqlplus "/ as sysdba"
4. confirma se vc esta no BD correto 
5. @?/rdbms/admin/awrrpt.sql

@?\rdbms\admin\addmrpt.sql


snapshot intervals and retention
--------------------------------


select extract( day from snap_interval) *24*60+extract( hour from snap_interval) *
   60+extract( minute from snap_interval ) snapshot_interval,
    extract( day from retention) retention_interval
from dba_hist_wr_control; 

SNAPSHOT_INTERVAL RETENTION_INTERVAL_DAYS
----------------- ------------------
               60                  8


ChangING it to 15 mins and 30 days


SQL> execute dbms_workload_repository.modify_snapshot_settings(interval => 15, retention => 43200);

PL/SQL procedure successfully completed.


select extract( day from snap_interval) *24*60+extract( hour from snap_interval) *
   60+extract( minute from snap_interval ) snapshot_interval,
    extract( day from retention) retention_interval
from dba_hist_wr_control;   2    3    4

SNAPSHOT_INTERVAL RETENTION_INTERVAL
----------------- ------------------
               15                 30
               