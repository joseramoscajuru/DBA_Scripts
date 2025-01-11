###### De uma tablespace especifica ##############
set pages 999
set lines 200
col file_name format a50
col TABLESPACE_NAME format a20
col AUTOEXTENSIBLE format a3
select TABLESPACE_NAME, AUTOEXTENSIBLE,BYTES/1024/1024 MBS, MAXBYTES/1024/1024 MAXMB, FILE_NAME from dba_data_files where tablespace_name='&tablespace_name';



###### De todas as tablespaces ##############
set pages 999
set lines 200
col file_name format a50
col TABLESPACE_NAME format a20
col AUTOEXTENSIBLE format a3
select TABLESPACE_NAME, AUTOEXTENSIBLE,BYTES/1024/1024 MBS, MAXBYTES/1024/1024 MAXMB, FILE_NAME from dba_data_files
order by TABLESPACE_NAME;



###### ESPECIFICO DA TABLEESPACE TEMP ##############
set pages 999
set lines 200
col file_name format a50
col TABLESPACE_NAME format a20
col AUTOEXTENSIBLE format a3
select TABLESPACE_NAME, AUTOEXTENSIBLE,BYTES/1024/1024 MBS, MAXBYTES/1024/1024 MAXMB, FILE_NAME from dba_temp_files
order by TABLESPACE_NAME;

