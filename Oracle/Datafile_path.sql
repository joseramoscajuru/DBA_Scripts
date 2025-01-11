####TableSpace TEMP
set lines 100
col file_name format a70
select file_name, AUTOEXTENSIBLE
,      ceil(bytes / 1024 / 1024) "size MB"
from   dba_temp_files
where  tablespace_name like '&TSNAME'
/

#DATAFILES FOR A SPACIFIC TABLESPCE (IN GIGABYTES)
set lines 350
col tablespace_name format a10
col file_name format a70
select tablespace_name, file_name, bytes/1024/1024/1024 DTF_GB,
autoextensible,
maxbytes/1024/1024 DTF_MAX_MB 
from dba_data_files
where tablespace_name = '&tablespace_name';
	
#TABLESPACE FOR A SPACIFIC DATAFILE (IN GIGABYTES)
set lines 350
col file_name format a70
select tablespace_name, file_name, bytes/1024/1024/1024 DTF_GB,
autoextensible,
maxbytes/1024/1024/1024 DTF_MAX_GB 
from dba_data_files
where file_name IN ('&file_name');

#DATAFILES FOR A SPACIFIC TABLESPCE (IN MEGABYTES)
set lines 350
col tablespace_name format a10
col file_name format a70
select tablespace_name, file_name, bytes/1024/1024 DTF_MB,
autoextensible,
maxbytes/1024/1024 DTF_MAX_MB 
from dba_data_files
where tablespace_name = '&tablespace_name';

set lines 350
col tablespace_name format a10
col file_name format a70
select TABLESPACE_NAME,FILE_NAME,AUTOEXTENSIBLE from dba_data_files where FILE_NAME like '/u02/oradata/wgisss01%' order by 3,1,2;

#TABLESPACE DATAFILE FOR ALL TABLESPACES
set lines 350
col file_name format a70
select tablespace_name, file_name, bytes/1024/1024 DTF_MB,
autoextensible,
maxbytes/1024/1024 DTF_MAX_MB 
from dba_data_files
ORDER BY 1;

#TABLESPACE DATAFILE FOR TEMP
set lines 350
col file_name format a70
select tablespace_name,
file_name, bytes/1024/1024 DTF_MB,
autoextensible,
maxbytes/1024/1024 DTF_MAX_MB 
from dba_temp_files
where tablespace_name = '&tablespace_name';



set lines 350
col file_name format a70
select tablespace_name,
file_name, 
bytes/1024/1024 from dba_data_files 
order by 1;


set lines 350
col file_name format a70
select file_name, bytes/1024/1024/1024 DT_GB,
autoextensible,
maxbytes/1024/1024/1024 DT_MAX_GB 
from dba_data_files
order by FILE_NAME;

