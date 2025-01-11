execute temp_size_usage;

create or replace procedure temp_size_usage is
TEMP_TABLESPACE_NAME varchar2(30);
TEMP_TABLESPACE_SIZE number;
TEMP_TABLESPACE_USAGE number;
TEMP_TABLESPACE_FREE number;

begin

  SELECT   A.tablespace_name tablespace, D.mb_total,
         SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
         D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free 
         into 
         TEMP_TABLESPACE_NAME,
         TEMP_TABLESPACE_SIZE,
         TEMP_TABLESPACE_USAGE,
         TEMP_TABLESPACE_FREE
FROM     v$sort_segment A,
         (
         SELECT   B.name, C.block_size, SUM (C.bytes) / 1024 / 1024 mb_total
         FROM     v$tablespace B,v$tempfile C
         WHERE    B.ts#= C.ts#
         GROUP BY B.name, C.block_size
         ) D
WHERE    A.tablespace_name = D.name
GROUP by A.tablespace_name, D.mb_total;

Dbms_Output.put_line('TEMP TABLESPACE NAME:='|| TEMP_TABLESPACE_NAME);
Dbms_Output.put_line('TEMP TABLESPACE SIZE:='|| TEMP_TABLESPACE_SIZE ||' MB');
Dbms_Output.put_line('TEMP TABLESPACE USAGE:='|| TEMP_TABLESPACE_USAGE ||' MB');
Dbms_Output.put_line('TEMP TABLESPACE FREE:='|| TEMP_TABLESPACE_FREE ||' MB');


end temp_size_usage;