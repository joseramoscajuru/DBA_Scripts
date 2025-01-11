col SESS for a30
col OWNER for a15
col OBJECT_NAME for a30
SELECT DECODE(request,0,‘Holder: ’,’Waiter: ’)||l.sid sess,
DECODE(l.lmode,
  1, ‘No Lock’,
  2, ‘Row Share’,
  3, ‘Row Exclusive’,
  4, ‘Shared Table’,
  5, ‘Shared Row Exclusive’,
  6, ‘Exclusive’) locked_mode,
DECODE(l.request,
  1, ‘No Lock’,
  2, ‘Row Share’,
  3, ‘Row Exclusive’,
  4, ‘Shared Table’,
  5, ‘Shared Row Exclusive’,
  6, ‘Exclusive’) Resquest_Mode,
 l.type,l.INST_ID,l.ctime,o.owner,o.object_name,i.ORACLE_USERNAME Current_user,s.status,s.module
FROM GV$LOCK l, gv$locked_object i, dba_objects o, v$session s
WHERE (id1, id2, l.type) IN
(SELECT id1, id2, type FROM GV$LOCK WHERE request>0)
and i.object_id in (select OBJECT_ID from (select OBJECT_ID,count(*) count from gv$locked_object group by OBJECT_ID) where count>=2)
and l.sid=i.SESSION_ID and s.sid=l.sid and s.sid=i.SESSION_ID
and o.OBJECT_ID=i.OBJECT_ID
ORDER BY id1, request;