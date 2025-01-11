
prompt LOCK
col texto format a100
SELECT	(SELECT	trim(s1.USERNAME)||'-'||trim(s1.osuser)||'-status:'||status||'-spid:'||p1.spid
	 FROM	V$SESSION s1, v$process p1
	 WHERE	s1.SID = A.SID and s1.paddr=p1.addr) ||'-sid:'||
	A.SID||		'- BLOQUEANDO:'||
	(SELECT	trim(USERNAME)||'-'||trim(osuser)
	 FROM	V$SESSION
	 WHERE	SID=B.SID) ||'-sid:'||
	B.SID texto
	FROM	V$LOCK A, V$LOCK B
	WHERE	A.BLOCK	  	= 1
	AND	B.REQUEST 	> 0
	AND	A.ID1		= B.ID1
	AND	A.ID2		= B.ID2 ;

SELECT	MACHINE, COUNT(*)
	FROM	V$LOCK A, V$LOCK B, v$session s
	WHERE	A.BLOCK	  	= 1
	AND	B.REQUEST 	> 0
	AND	A.ID1		= B.ID1
	AND	A.ID2		= B.ID2 
	AND  A.SID = S.SID
	GROUP BY MACHINE;

Query to find out waiting session and holding sessions in Oracle 

set linesize 1000
column waiting_session heading 'WAITING|SESSION'
column holding_session heading 'HOLDING|SESSION'
column lock_type format a15
column mode_held format a15
column mode_requested format a15
select
waiting_session,
holding_session,
lock_type,
mode_held,
mode_requested,
lock_id1,
lock_id2
from
dba_waiters;

The below query can be used to find all the locked tables in Oracle

column sid_ser format a12 heading 'session,|serial#'; 
column username format a12 heading 'os user/|db user'; 
column process format a9 heading 'os|process'; 
column spid format a7 heading 'trace|number'; 
column owner_object format a35 heading 'owner.object'; 
column locked_mode format a13 heading 'locked|mode'; 
column status format a8 heading 'status'; 
set pages 300 lines 1000
select 
    substr(to_char(l.session_id)||','||to_char(s.serial#),1,12) sid_ser, 
    substr(l.os_user_name||'/'||l.oracle_username,1,12) username, 
    l.process, 
    p.spid, 
    substr(o.owner||'.'||o.object_name,1,35) owner_object, 
    decode(l.locked_mode, 
             1,'No Lock', 
             2,'Row Share', 
             3,'Row Exclusive', 
             4,'Share', 
             5,'Share Row Excl', 
             6,'Exclusive',null) locked_mode, 
    substr(s.status,1,8) status 
from 
    v$locked_object l, 
    all_objects     o, 
    v$session       s, 
    v$process       p 
where 
    l.object_id = o.object_id 
and l.session_id = s.sid 
and s.paddr      = p.addr 
and s.status != 'KILLED'
/

select ub.inst_id Inst_Trav, h.session_id Sess_Trav, ub.serial# Serial_Trav , ub.username Usuario_Trav ,uw.inst_id Inst_Espera, w.session_id Sessao_Espera,
		uw.serial# Serial_Espera,
        uw.username Usuario_Esperando,
w.lock_type,
h.mode_held,
-- w.mode_requested,
w.lock_id1,
w.lock_id2
from dba_locks w, dba_locks h, gv$session ub, gv$session uw
where h.blocking_others = 'Blocking'
and h.mode_held!= 'None'
and h.mode_held!= 'Null'
and h.session_id = ub.sid
and w.mode_requested != 'None'
and w.lock_type = h.lock_type
and w.lock_id1 = h.lock_id1
and w.lock_id2 = h.lock_id2
and w.session_id = uw.sid;
