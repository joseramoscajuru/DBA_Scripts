
If you have huge aud$ table of size tens of GB then below procedure can be followed to move aud$ to new tablespace by taking backup.

It is advised to do this procedure during off peak hours.


i) CREATE TABLE backup_aud$ AS SELECT * from sys.aud$;

ii) truncate table aud$;

iii) export table backup_aud$:


[oracle@seclin4 ~]$ exp file=aud_backup.dmp tables=backup_aud$


iv) Move aud$ to another tablespace using Doc ID 73408.1

v) Copy data back to aud$ table

SQL>insert into aud$ select * from backup_aud$;
SQL>commit;


vi) drop table backup_aud$


After you complete the above activity the new audit data should be moving to the new tablespace which you have created for aud$ table.