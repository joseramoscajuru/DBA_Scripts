
To back up your MySQL database, the general syntax is:

sudo mysqldump -u [user] -p [database_name] > [filename].sql

Replace [user] with your username and password (if needed).

The [database_name] is the path and filename of the database.

The > command specifies the output.

[filename] is the path and filename you want to save the dump file as.

Other examples:

To back up of an entire Database Management System:

mysqldump --all-databases --single-transaction --quick --lock-tables=false > /data/export/mysqlbackups/full-backup-$(date +%F).sql -u root -p YMMP-2VZzqqscBUj@xLh

To include more than one database in the backup dump file:

sudo mysqldump -u [user] -p [database_1] [database_2] [database_etc] > [filename].sql



RODOU COM SUCESSO DESSA FORMA:

mysqldump --all-databases > /data/export/mysqlbackups/mysql_all_databases.sql -u root -p

For point-in-time recovery (also known as “roll-forward,” when you need to restore an old backup and replay the changes that happened since that backup), 
it is often useful to rotate the binary log (see Section 5.4.4, “The Binary Log”) or at least know the binary log coordinates to which the dump corresponds:


mysqldump --all-databases --master-data=2 > /data/export/mysqlbackups/mysql_all_databases_master.sql -u root -p

To load the dump file back into the server:

mysql db_name < backup-file.sql

Another way to reload the dump file:

mysql -e "source /path-to-backup/backup-file.sql" db_name

mysqldump is also very useful for populating databases by copying data from one MySQL server to another:

mysqldump --opt db_name | mysql --host=remote_host -C db_name