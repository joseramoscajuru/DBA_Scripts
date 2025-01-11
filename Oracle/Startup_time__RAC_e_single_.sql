Find the Startup & UP time of Oracle Database Instance

Check the Oracle Instance Startup Time

SET LINES 200
SET PAGES 999
COLUMN INSTANCE_NAME FOR A20
SELECT INST_ID, INSTANCE_NAME,TO_CHAR(STARTUP_TIME, 'HH24:MI DD-MON-YY') "STARTUP TIME"
FROM GV$INSTANCE;

Check the startup history timing of Oracle Instance

COL INSTANCE_NAME FOR A10
SELECT INSTANCE_NAME,TO_CHAR(STARTUP_TIME, 'HH24:MI DD-MON-YY') 
FROM DBA_HIST_DATABASE_INSTANCE 
ORDER BY STARTUP_TIME DESC;

Find the uptime of Oracle Database

SET LINE 60
COLUMN HOSTNAME FOR A60
COLUMN INSTANCE_NAME FOR A60
COLUMN STIME FOR A60
COLUMN UPTIME FOR A60
SELECT
'HOSTNAME : ' || HOST_NAME
,'INSTANCE NAME : ' || INSTANCE_NAME
,'STARTED AT : ' || TO_CHAR(STARTUP_TIME,'DD-MON-YYYY HH24:MI:SS') STIME
,'UPTIME : ' || FLOOR(SYSDATE - STARTUP_TIME) || ' DAYS(S) ' ||
TRUNC( 24*((SYSDATE-STARTUP_TIME) -
TRUNC(SYSDATE-STARTUP_TIME))) || ' HOUR(S) ' ||
MOD(TRUNC(1440*((SYSDATE-STARTUP_TIME) -
TRUNC(SYSDATE-STARTUP_TIME))), 60) ||' MINUTE(S) ' ||
MOD(TRUNC(86400*((SYSDATE-STARTUP_TIME) -
TRUNC(SYSDATE-STARTUP_TIME))), 60) ||' SECONDS' UPTIME
FROM
SYS.V_$INSTANCE;