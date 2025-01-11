
set lines 1000 pages 100
col dest_name format a30
col type format a15
col destination format a20
col error format a20
select dest_id,dest_name, type,ARCHIVED_SEQ# ,APPLIED_SEQ#, DESTINATION, status, error,
		SYNCHRONIZATION_STATUS, GAP_STATUS
 from gv$archive_dest_status;
 
 
Goal:

Check if any remote standby archive destination is getting errors

Check if all remote standby archive destinations is enabled or VALID

select dest_id,dest_name, type,status, error
 from gv$archive_dest_status
 where type='PHYSICAL'
 and status!='VALID'
 or error is not null;
 
 Good health = no rows returned

If the query returns rows, then raise an alert with the returned data.


select sysdate,status,error, destination, database_mode
 from gv$archive_dest_status
 where type='PHYSICAL'
 and status = 'VALID'
 or error is not null;