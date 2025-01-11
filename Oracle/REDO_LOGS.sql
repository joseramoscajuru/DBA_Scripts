Redolog below threshold

1- verifcar archives
archive log list
2- se for asm entrar no asm
. oraenv
+ASM
asmcmd
3- ver discos
ASMCMD> lsdg

SQL> select distinct status from v$log;

STATUS
------------------------------------------------
CURRENT
ACTIVE
INACTIVE 

Redo logs are working fine. 
There is no Customer Account data for this problem.

This is being caused by the low database activity during the weekends causing the archived log files taking too long to be generated causing the warning.
no action.

===============================================================

SQL> select distinct status from v$log;

STATUS
---------------
CURRENT
INACTIVE

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/oravg-orp4_logs
                      10321208   2393968   7927240  24% /logs/oracle/orp4

SQL> SELECT sid, event, seconds_in_wait, state FROM v$session_wait WHERE event = 'log buffer space';

no rows selected



The redo log space waits for Oracle instance orp4 has crossed above the predefined threshold.

The redo entries in the redo log files are used for database recovery. The buffer is usually flushed by reaching: one third of the redo log buffer size, frequent COMMITs, and every 3 seconds.

Redo logs are working fine.

















===============================================================

REDOLOG CHEIO:


SQL> select * from v$logfile;

    GROUP# Status     TYPE    MEMBER                                             IS_
---------- ---------- ------- -------------------------------------------------- ---
         1            ONLINE  /oracle/u04/oradata/orp4/redo01a.dbf               NO
         1            ONLINE  /oracle/u05/oradata/orp4/redo01b.dbf               NO
         2            ONLINE  /oracle/u05/oradata/orp4/redo02a.dbf               NO
         2            ONLINE  /oracle/u06/oradata/orp4/redo02b.dbf               NO
         3            ONLINE  /oracle/u06/oradata/orp4/redo03a.dbf               NO
         3            ONLINE  /oracle/u07/oradata/orp4/redo03b.dbf               NO
         4            ONLINE  /oracle/u07/oradata/orp4/redo04a.dbf               NO
         4            ONLINE  /oracle/u08/oradata/orp4/redo04b.dbf               NO
         6            ONLINE  /oracle/u09/oradata/orp4/redo06a.dbf               NO
         6            ONLINE  /oracle/u04/oradata/orp4/redo06b.dbf               NO
         5            ONLINE  /oracle/u08/oradata/orp4/redo05a.dbf               NO
         5            ONLINE  /oracle/u09/oradata/orp4/redo05b.dbf               NO

12 rows selected.

SQL> select * from v$log;

    GROUP#    THREAD#  SEQUENCE#      BYTES    MEMBERS ARC Status     FIRST_CHANGE# FIRST_TIME
---------- ---------- ---------- ---------- ---------- --- ---------- ------------- ----------
         1          1        168  209715200          2 NO  CURRENT          1024630 11/08/2010
         2          1        163  209715200          2 YES INACTIVE          862209 10/08/2010
         3          1        164  209715200          2 YES INACTIVE          923490 11/08/2010
         4          1        165  209715200          2 YES INACTIVE          926512 11/08/2010
         5          1        166  209715200          2 YES INACTIVE          927519 11/08/2010
         6          1        167  209715200          2 YES INACTIVE          976748 11/08/2010

6 rows selected.

SQL> ALTER DATABASE DROP LOGFILE GROUP 3;

Database altered.

SQL> ALTER DATABASE DROP LOGFILE GROUP 4;

Database altered.

SQL> ALTER DATABASE DROP LOGFILE GROUP 5;

Database altered.

SQL> ALTER DATABASE DROP LOGFILE GROUP 6;

Database altered.

SQL> !rm /oracle/u06/oradata/orp4/redo03a.dbf

SQL> !rm /oracle/u07/oradata/orp4/redo03b.dbf

SQL> !rm /oracle/u07/oradata/orp4/redo04a.dbf

SQL> !rm /oracle/u08/oradata/orp4/redo04b.dbf

SQL> !rm /oracle/u08/oradata/orp4/redo05a.dbf

SQL> !rm /oracle/u09/oradata/orp4/redo05b.dbf

SQL> !rm /oracle/u09/oradata/orp4/redo06a.dbf

SQL> !rm /oracle/u04/oradata/orp4/redo06b.dbf

SQL> ALTER DATABASE ADD LOGFILE GROUP 3 ( '/oracle/u06/oradata/orp4/redo03a.dbf', '/oracle/u07/oradata/orp4/redo03b.dbf' ) SIZE 20M;

Database altered.

SQL> ALTER DATABASE ADD LOGFILE GROUP 4 ( '/oracle/u07/oradata/orp4/redo04a.dbf', '/oracle/u08/oradata/orp4/redo04b.dbf' ) SIZE 20M;

Database altered.

SQL> ALTER DATABASE ADD LOGFILE GROUP 5 ( '/oracle/u08/oradata/orp4/redo05a.dbf', '/oracle/u09/oradata/orp4/redo05b.dbf' ) SIZE 20M;

Database altered.

SQL> ALTER DATABASE ADD LOGFILE GROUP 6 ( '/oracle/u09/oradata/orp4/redo06a.dbf', '/oracle/u04/oradata/orp4/redo06b.dbf' ) SIZE 20M;

Database altered.

SQL> alter system checkpoint;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> select * from v$log;

    GROUP#    THREAD#  SEQUENCE#      BYTES    MEMBERS ARC Status     FIRST_CHANGE# FIRST_TIME
---------- ---------- ---------- ---------- ---------- --- ---------- ------------- ----------
         1          1        168  209715200          2 YES ACTIVE           1024630 11/08/2010
         2          1        163  209715200          2 YES INACTIVE          862209 10/08/2010
         3          1        169   20971520          2 YES ACTIVE           1029538 11/08/2010
         4          1        170   20971520          2 NO  CURRENT          1029541 11/08/2010
         5          1          0   20971520          2 YES UNUSED                 0
         6          1          0   20971520          2 YES UNUSED                 0

6 rows selected.

SQL> alter system checkpoint;

System altered.

SQL> select * from v$log;

    GROUP#    THREAD#  SEQUENCE#      BYTES    MEMBERS ARC Status     FIRST_CHANGE# FIRST_TIME
---------- ---------- ---------- ---------- ---------- --- ---------- ------------- ----------
         1          1        168  209715200          2 YES INACTIVE         1024630 11/08/2010
         2          1        163  209715200          2 YES INACTIVE          862209 10/08/2010
         3          1        169   20971520          2 YES INACTIVE         1029538 11/08/2010
         4          1        170   20971520          2 NO  CURRENT          1029541 11/08/2010
         5          1          0   20971520          2 YES UNUSED                 0
         6          1          0   20971520          2 YES UNUSED                 0

6 rows selected.

SQL> ALTER DATABASE DROP LOGFILE GROUP 1;

Database altered.

SQL> ALTER DATABASE DROP LOGFILE GROUP 2;

Database altered.

SQL> !rm /oracle/u04/oradata/orp4/redo01a.dbf

SQL> !rm /oracle/u05/oradata/orp4/redo01b.dbf

SQL> !rm /oracle/u05/oradata/orp4/redo02a.dbf

SQL> !rm /oracle/u06/oradata/orp4/redo02b.dbf

SQL> ALTER DATABASE ADD LOGFILE GROUP 1 ( '/oracle/u04/oradata/orp4/redo01a.dbf', '/oracle/u05/oradata/orp4/redo01b.dbf' ) SIZE 20M;

Database altered.

SQL> ALTER DATABASE ADD LOGFILE GROUP 2 ( '/oracle/u05/oradata/orp4/redo02a.dbf', '/oracle/u06/oradata/orp4/redo02b.dbf' ) SIZE 20M;

Database altered.

SQL> select * from v$log;

    GROUP#    THREAD#  SEQUENCE#      BYTES    MEMBERS ARC Status     FIRST_CHANGE# FIRST_TIME
---------- ---------- ---------- ---------- ---------- --- ---------- ------------- ----------
         1          1          0   20971520          2 YES UNUSED                 0
         2          1          0   20971520          2 YES UNUSED                 0
         3          1        169   20971520          2 YES INACTIVE         1029538 11/08/2010
         4          1        170   20971520          2 NO  CURRENT          1029541 11/08/2010
         5          1          0   20971520          2 YES UNUSED                 0
         6          1          0   20971520          2 YES UNUSED                 0

6 rows selected.

SQL> alter system checkpoint;

System altered.

SQL> select * from v$log;

    GROUP#    THREAD#  SEQUENCE#      BYTES    MEMBERS ARC Status     FIRST_CHANGE# FIRST_TIME
---------- ---------- ---------- ---------- ---------- --- ---------- ------------- ----------
         1          1          0   20971520          2 YES UNUSED                 0
         2          1          0   20971520          2 YES UNUSED                 0
         3          1        169   20971520          2 YES INACTIVE         1029538 11/08/2010
         4          1        170   20971520          2 NO  CURRENT          1029541 11/08/2010
         5          1          0   20971520          2 YES UNUSED                 0
         6          1          0   20971520          2 YES UNUSED                 0

6 rows selected.

SQL>

