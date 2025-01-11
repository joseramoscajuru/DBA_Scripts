=========================== LARGE TABLE ==========================

column SEGMENT_NAME format A50

SELECT * FROM (
  SELECT
    OWNER, SEGMENT_NAME, BYTES/1024/1024 SIZE_MB
  FROM
    DBA_SEGMENTS
WHERE
      SEGMENT_TYPE = 'TABLE'
  ORDER BY
    BYTES/1024/1024  DESC ) WHERE ROWNUM <= 10;
 

=========================== LARGE INDEX==========================

column SEGMENT_NAME format A50
SELECT * FROM (
  SELECT
    OWNER, SEGMENT_NAME, BYTES/1024/1024 SIZE_MB
  FROM
    DBA_SEGMENTS
WHERE
      SEGMENT_TYPE = 'INDEX'
  ORDER BY
    BYTES/1024/1024  DESC ) WHERE ROWNUM <= 10;

==================================================================

 

This is how I check for the fragmentation

 

Table size (with fragmentation)

 

 

 

select table_name,round((blocks*8),2)||'kb' "size" from user_tables where table_name = 'BIG1';

 

 

 

Actual data in table:

 

select table_name,round((num_rows*avg_row_len/1024),2)||'kb' "size"from user_tables where table_name = 'BIG1';

 

 

 

How to reset HWM / remove fragemenation?

 

For that we need to reorganize the fragmented table.

 

We have four options to reorganize fragmented tables:

 

1. alter table ... move + rebuild indexes

2. export / truncate / import

3. create table as select ( CTAS)

4. dbms_redefinition