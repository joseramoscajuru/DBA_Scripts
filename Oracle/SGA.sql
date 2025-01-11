select * from v$sgainfo;

### free memory on SGA ###

select POOL, Round(bytes/1024/1024,0) Free_Memory_In_MB
From V$sgastat
Where Name Like '%free memory%';

### free and allocated memory ###

COLUMN pool    HEADING "Pool"
COLUMN name    HEADING "Name"
COLUMN sgasize HEADING "Allocated" FORMAT 999,999,999
COLUMN bytes   HEADING "Free" FORMAT 999,999,999
 
SELECT
    f.pool
  , f.name
  , s.sgasize
  , f.bytes
  , ROUND(f.bytes/s.sgasize*100, 2) "% Free"
FROM
    (SELECT SUM(bytes) sgasize, pool FROM v$sgastat GROUP BY pool) s
  , v$sgastat f
WHERE
    f.name = 'free memory'
  AND f.pool = s.pool
/ 

*** SGA CACHE STATS ***

set serveroutput on
 
 
DECLARE
      libcac NUMBER(10,2);
      rowcac NUMBER(10,2);
      bufcac NUMBER(10,2);
      redlog NUMBER(10,2);
      spsize NUMBER;
      blkbuf NUMBER;
      logbuf NUMBER;
BEGIN
SELECT VALUE INTO redlog FROM v$sysstat
WHERE name = 'redo log space requests';
SELECT 100*(SUM(pins)-SUM(reloads))/SUM(pins) INTO libcac FROM v$librarycache;
SELECT 100*(SUM(gets)-SUM(getmisses))/SUM(gets) INTO rowcac FROM v$rowcache;
SELECT 100*(cur.VALUE + con.VALUE - phys.VALUE)/(cur.VALUE + con.VALUE) INTO bufcac
FROM v$sysstat cur,v$sysstat con,v$sysstat phys,v$statname ncu,v$statname nco,v$statname nph
WHERE cur.statistic# = ncu.statistic#
     AND ncu.name = 'db block gets'
        AND con.statistic# = nco.statistic#
        AND nco.name = 'consistent gets'
        AND phys.statistic# = nph.statistic#
        AND nph.name = 'physical reads';
SELECT VALUE INTO spsize  FROM v$parameter WHERE name = 'shared_pool_size';
SELECT VALUE INTO blkbuf  FROM v$parameter WHERE name = 'db_block_buffers';
SELECT VALUE INTO logbuf  FROM v$parameter WHERE name = 'log_buffer';
DBMS_OUTPUT.put_line('>                   SGA CACHE STATISTICS');
DBMS_OUTPUT.put_line('>                   ********************');
DBMS_OUTPUT.put_line('>              SQL Cache Hit rate = '||libcac);
DBMS_OUTPUT.put_line('>             Dict Cache Hit rate = '||rowcac);
DBMS_OUTPUT.put_line('>           Buffer Cache Hit rate = '||bufcac);
DBMS_OUTPUT.put_line('>         Redo Log space requests = '||redlog);
DBMS_OUTPUT.put_line('> ');
DBMS_OUTPUT.put_line('>                     INIT.ORA SETTING');
DBMS_OUTPUT.put_line('>                     ****************');
DBMS_OUTPUT.put_line('>               Shared Pool Size = '||spsize||' Bytes');
DBMS_OUTPUT.put_line('>                DB Block Buffer = '||blkbuf||' Blocks');
DBMS_OUTPUT.put_line('>                    Log Buffer  = '||logbuf||' Bytes');
DBMS_OUTPUT.put_line('> ');
IF
     libcac < 99  THEN DBMS_OUTPUT.put_line('*** HINT: Library Cache too low! Increase the Shared Pool Size.');
END IF;
IF
     rowcac < 85  THEN DBMS_OUTPUT.put_line('*** HINT: Row Cache too low! Increase the Shared Pool Size.');
END IF;
IF
     bufcac < 90  THEN DBMS_OUTPUT.put_line('*** HINT: Buffer Cache too low! Increase the DB Block Buffer value.');
END IF;
IF
     redlog > 100 THEN DBMS_OUTPUT.put_line('*** HINT: Log Buffer value is rather low!');
END IF;
END;
/ 

