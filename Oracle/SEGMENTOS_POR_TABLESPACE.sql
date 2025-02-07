SELECT UT.TABLESPACE_NAME "TABLESPACE", COUNT (US.SEGMENT_NAME) "NUM SEGMENTS"
   FROM DBA_TABLESPACES UT, DBA_SEGMENTS US
   WHERE UT.TABLESPACE_NAME = US.TABLESPACE_NAME (+)
   GROUP BY (UT.TABLESPACE_NAME)
   ORDER BY COUNT (US.SEGMENT_NAME) DESC;