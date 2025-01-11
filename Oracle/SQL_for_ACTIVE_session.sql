SELECT a.username,
       b.sql_text,
       a.status
FROM   v$session a
       INNER JOIN v$sqlarea b
         ON a.sql_id = b.sql_id
where status='ACTIVE'
and a.sql_id='fng0kpft0jc54';

col sid form 9999
col curr form a80 head " Current SQL"
bre on sid skip 2
set long 10000
select a.sid sid,b.sql_text curr,b.sql_id
from v$session a, v$sql b
where a.sql_address=b.address
and a.sid=&sessid;---------------->Enter session ID 

select sql_id from v$session where sid=123; ---->gives sql id
select sql_text from v$sql where sql_id='ABCD1234'; ----->gives sql query/text of the respective sql_id 

For example DBA_HIST_SQLTEXT contains both sql_id and the text of the statement. DBA_HIST_SQLSTAT has execution details. Of cause statement may not be captured due to its short duration. 
In this case you can try ASH views. 

SQL> /

    SID  SERIAL# USERNAME                       START     %COMPLETE STATE      SEC_WAIT MESSAGE
------- -------- ------------------------------ -------- ---------- -------- ---------- --------------------------------------------------
EVENT
----------------------------------------------------------------
   2377    61931 SYS                            09:01:18      33.39 WAITED S          0 Rowid Range Scan:  DBCSI_DSP.P2K_ITEM_TRANSACAO: 9
                                                                    HORT TIM            6609 out of 289309 Blocks done
                                                                    E
db file scattered read

   2294    30965 SYS                            09:01:37      15.62 WAITED S          0 Rowid Range Scan:  DBCSI_DSP.P2K_ITEM_TRANSACAO: 3
                                                                    HORT TIM            9430 out of 252453 Blocks done
                                                                    E
db file scattered read
