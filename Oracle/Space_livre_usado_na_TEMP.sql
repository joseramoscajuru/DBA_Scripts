SELECT tablespace_name, SUM(bytes_used/1024/1024), SUM(bytes_free/1024/1024)
             FROM   V$temp_space_header
             GROUP  BY tablespace_name;

