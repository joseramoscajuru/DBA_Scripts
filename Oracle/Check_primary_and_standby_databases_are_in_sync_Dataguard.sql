
Check physical Standby is in sync Dataguard

The following command will help to check the Standby is synced with Primary Database in Oracle Dataguard Environment.

On Primary Server:

Check the current log sequence on the Primary database:

select thread#, max(sequence#) "Last Primary Seq Generated" from v$archived_log val, v$database vdb where val.resetlogs_change# = vdb.resetlogs_change# group by thread# order by 1;

OR 

Archive log list;

Check both primary and secondary archive in single command:

SELECT b.last_seq prmy_last_file,
      a.applied_seq stdby_last_file ,TO_CHAR (a.latest_apply_time, 'dd/mm/yyyy hh24:mi:ss') stdby_latest_time
 FROM (SELECT   resetlogs_id, thread#, MAX (sequence#) applied_seq, MAX (next_time) latest_apply_time
           FROM v$archived_log
          WHERE applied = 'YES'
       GROUP BY resetlogs_id, thread#) a,
      (SELECT   resetlogs_id, thread#, MAX (sequence#) last_seq
           FROM v$archived_log
       GROUP BY resetlogs_id, thread#) b
WHERE a.thread# = b.thread#
ORDER BY a.thread#;

PRMY_LAST_FILE STDBY_LAST_FILE STDBY_LATEST_TIME
-------------- --------------- ---------------------------
         63786           63786 16/10/2023 09:38:45

On Physical Standby Server:

Check the received log on the standby database

--Check received log on standby
select thread#, max(sequence#) "Last Standby Seq Received" from v$archived_log val, v$database vdb where val.resetlogs_change# = vdb.resetlogs_change# group by thread# order by 1;
Check the applied log on the Standby database:

--Check applied log on standby
select thread#, max(sequence#) "Last Standby Seq Applied" from v$archived_log val, v$database vdb where val.resetlogs_change# = vdb.resetlogs_change# and val.applied in ('YES','IN-MEMORY') group by thread# order by 1;

On Standby: Even we can check with the archive gap:

col thread# for a20
col low_sequence# for a20
col high_sequence# for a20
select * from v$archive_gap;
Get the list of archived applied:

select sequence#, first_time, next_time, applied from v$archived_log where applied='YES' order by sequence#;
