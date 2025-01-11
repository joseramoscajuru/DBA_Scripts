Top 50 Query which can be used to query segments with highest growth. This will also report the present size of the segment which is very useful in identifying the growth percentage.

SELECT o.OWNER , o.OBJECT_NAME , o.SUBOBJECT_NAME , o.OBJECT_TYPE , 
    t.NAME "Tablespace Name", s.growth/(1024*1024) "Growth in MB", 
    (SELECT sum(bytes)/(1024*1024) 
    FROM dba_segments 
    WHERE segment_name=o.object_name) "Total Size(MB)" 
FROM DBA_OBJECTS o, 
    ( SELECT TS#,OBJ#, 
        SUM(SPACE_USED_DELTA) growth 
    FROM DBA_HIST_SEG_STAT 
    GROUP BY TS#,OBJ# 
    HAVING SUM(SPACE_USED_DELTA) > 0 
    ORDER BY 2 DESC ) s, 
    v$tablespace t 
WHERE s.OBJ# = o.OBJECT_ID 
AND s.TS#=t.TS# 
AND rownum < 51 
ORDER BY 6 DESC 
/