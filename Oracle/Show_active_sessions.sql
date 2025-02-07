
— Below is the script to Check Active Sessions in Oracle Database.


SET LINESIZE 300
SET COLSEP '|'
COLUMN USERNAME FORMAT A15
column program format a30
COLUMN MACHINE FORMAT A25
COLUMN OSUSER FORMAT A15
COLUMN SID FORMAT 9999
COLUMN SPID FORMAT 99999
COLUMN STATUS FORMAT A10

SET VERIFY OFF

SELECT S.SID,
		S.SERIAL#,
		P.PID "ORAPID",
		P.SPID "SPID",
		S.USERNAME,
		S.STATUS,
		S.LAST_cALL_ET/60,
		S.OSUSER,
		S.MACHINE,
		s.program,
		s.ACTION
FROM gV$SESSION S,gV$PROCESS P
WHERE S.PADDR=P.ADDR
AND S.USERNAME IS NOT NULL
AND S.STATUS='ACTIVE'
ORDER BY S.USERNAME;

