
select sysdate,protection_mode, synchronized, synchronization_status
 from v$archive_dest_status
 where type='PHYSICAL'
 and synchronization_status !='OK';
 
Good health = no rows returned

If the query returns rows, then raise an alert with the returned output.

