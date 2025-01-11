exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'MSEG', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);
exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'LIPS', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);
exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'VBBE', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);

exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'ZVSCET0001', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);
exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'VBMOD', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);
exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'ZSTR168', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);
exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'LFA1', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);
exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'ZSDT011_MONITOR', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);
exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'VBDATA', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);
exec DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SAPR3' , tabname => 'MARD', cascade => true, estimate_percent => 10, method_opt=>'for all indexed columns size 1', granularity => 'ALL', degree => 1);

