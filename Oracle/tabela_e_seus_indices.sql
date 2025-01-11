define SCHEMA = 'SAPSEM';
--define TABNAME = $1;
set linesize 1000
set pagesize 1000
col megas format 999,999,990.00
COL SEGMENT_NAME FORMAT A35
COL TABLE_NAME FORMAT A35
set feedback off
set echo off
 SELECT SUM(S.BYTES) /1024/1024 megas ,s.segment_name table_name,s.segment_name  , 'table segment' -- The table segment size
  FROM DBA_SEGMENTS S
  WHERE S.OWNER = UPPER('&SCHEMA') AND
       (S.SEGMENT_NAME in ('&1')) GROUP BY s.segment_name union all
 SELECT SUM(S.BYTES)/1024/1024/1024 gigas,l.table_name,s.segment_name, 'lob segment' -- The Lob Segment Size
  FROM DBA_SEGMENTS S, DBA_LOBS L
  WHERE S.OWNER = UPPER('&SCHEMA') AND
       (L.SEGMENT_NAME = S.SEGMENT_NAME AND L.TABLE_NAME in ('&1') AND L.OWNER = UPPER('&SCHEMA'))  GROUP BY s.segment_name,L.TABLE_NAME union all
 SELECT SUM(S.BYTES) /1024/1024 megas, i.table_name, s.segment_name, 'lob index' -- The Lob Index size
  FROM DBA_SEGMENTS S, DBA_INDEXES I
  WHERE S.OWNER = UPPER('&SCHEMA') AND
       (I.INDEX_NAME = S.SEGMENT_NAME AND I.TABLE_NAME in ('&1') AND INDEX_TYPE = 'LOB' AND I.OWNER = UPPER('&SCHEMA')) GROUP BY s.segment_name,i.table_name  UNION ALL
 SELECT SUM(S.BYTES) /1024/1024 megas, i.table_name, s.segment_name, 'index'  -- The Lob Index size
  FROM DBA_SEGMENTS S, DBA_INDEXES I
  WHERE S.OWNER = UPPER('&SCHEMA') AND
       (I.INDEX_NAME = S.SEGMENT_NAME AND I.TABLE_NAME in ('&1') AND INDEX_TYPE <> 'LOB' AND I.OWNER = UPPER('&SCHEMA')) GROUP BY s.segment_name,i.table_name      ;
exit;

10:00:59 AM: Eu costumo colocar isso em um arquivo.sql e chamar assim:

sqlplus / as sysdba @tamanho.sql TABELA >> analise_tamanho.txt