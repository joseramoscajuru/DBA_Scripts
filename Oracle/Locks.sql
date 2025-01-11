Show locked objects

set lines 100 pages 999
col username 		 format a20
col sess_id 		 format a10
col object		 format a25
col mode_held		 format a10
select		 oracle_username || ' (' || s.osuser || ')' username
,		 s.sid || ',' || s.serial# sess_id
,		 owner || '.' ||		 object_name object
,		 object_type
,		 decode(		 l.block
		 ,		 0, 'Not Blocking'
		 ,		 1, 'Blocking'
		 ,		 2, 'Global') status
,		 decode(v.locked_mode
		 ,		 0, 'None'
		 ,		 1, 'Null'
		 ,		 2, 'Row-S (SS)'
		 ,		 3, 'Row-X (SX)'
		 ,		 4, 'Share'
		 ,		 5, 'S/Row-X (SSX)'
		 ,		 6, 'Exclusive', TO_CHAR(lmode)) mode_held
from		 v$locked_object v
,		 dba_objects d
,		 v$lock l
,		 v$session s
where 		 v.object_id = d.object_id
and 		 v.object_id = l.id1
and 		 v.session_id = s.sid
order by oracle_username
,		 session_id
/


Show all ddl locks in the system

select		 decode(lob.kglobtyp, 
		 		 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
		 		 4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
		 		 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
		 		 11, 'PACKAGE BODY', 12, 'TRIGGER',
		 		 13, 'TYPE', 14, 'TYPE BODY',
		 		 19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
		 		 22, 'LIBRARY', 23, 'DIRECTORY', 24, 'QUEUE',
		 		 28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
		 		 32, 'INDEXTYPE', 33, 'OPERATOR',
		 		 34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
		 		 40, 'LOB PARTITION', 41, 'LOB SUBPARTITION',
		 		 42, 'MATERIALIZED VIEW',
		 		 43, 'DIMENSION',
		 		 44, 'CONTEXT', 46, 'RULE SET', 47, 'RESOURCE PLAN',
		 		 48, 'CONSUMER GROUP',
		 		 51, 'SUBSCRIPTION', 52, 'LOCATION',
		 		 55, 'XML SCHEMA', 56, 'JAVA DATA',
		 		 57, 'SECURITY PROFILE', 59, 'RULE',
		 		 62, 'EVALUATION CONTEXT','UNDEFINED'
		 ) object_type
,		 lob.kglnaobj object_name
,		 pn.kglpnmod lock_mode_held
,		 pn.kglpnreq lock_mode_requested
,		 ses.sid
,		 ses.serial#
,		 ses.username
from		 v$session_wait		 vsw
,		 x$kglob		 		 lob
,		 x$kglpn		 		 pn
,		 v$session		 ses
where		 vsw.event = 'library cache lock'
and		 vsw.p1raw = lob.kglhdadr
and		 lob.kglhdadr = pn.kglpnhdl
and		 pn.kglpnmod != 0
and		 pn.kglpnuse = ses.saddr
/

