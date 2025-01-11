delete archivelog all backed up 1 times to DEVICE TYPE disk;

====================================================================================================================================

- crosscheck backup;
- delete noprompt expired backup;
- delete noprompt  obsolete;
  delete expired archivelog all;
- crosscheck backup;

- crosscheck archivelog all;
- delete noprompt expired backup;


====================================================================================================================================

####Script para dar "purge" em backups --> Analisar
allocate channel for maintenance device type ='SBT_TAPE';
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 90 DAYS;
crosscheck backup of database;
crosscheck archivelog all;
delete force noprompt obsolete;
delete force noprompt expired backup;
delete force noprompt expired backup of archivelog all;
release channel;
exit;