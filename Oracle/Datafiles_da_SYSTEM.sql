Select tablespace_name,
        FILE_ID,
        file_name,
        autoextensible,
        round(bytes/1024/1024/1024,2) "GB",
        round(maxbytes/1024/1024/1024,2) "Max in GB" 
from dba_data_files  
where tablespace_name in ('SYSTEM') 
order by file_id
