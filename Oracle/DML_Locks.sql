SELECT t1.sid SID, s.username, s.osuser, s.program, 
s.machine, o.object_name, t1.ctime
FROM
v$ACCESS    A,
v$LOCK     T1,
v$SESSION   S,
DBA_OBJECTS O
WHERE
t1.TYPE='TM'
AND A.SID   = S.SID
AND T1.sid  = s.sid
AND T1.id1  = o.object_id
--AND  A.OBJECT ='E_AUD_LOG_TRVL'	
ORDER BY T1.sid, T1.ctime;