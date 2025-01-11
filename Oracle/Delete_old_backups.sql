run {
allocate auxiliary channel t1 type SBT parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
list backup;
}

RMAN> allocate channel for maintenance type SBT_TAPE parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';

How to Delete Old Obsolete and Expired Oracle RMAN Backup
=========================================================

The main parameter that decides what to delete is the retention policy. To identify your retention policy, connect using RMAN and and execute “show all” and look for the following line.

$ rman target /
RMAN> SHOW ALL;

In the following example, retention policy is 4 days. So, any backup that is older than 4 days is considered obsolete and old.

CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 4 DAYS;

I. Delete Obsolete Backup

1. What is an Obsolete Backup?

Obsolete backups are those that are not required to satisfy RMAN requirement of what is specified in the retention policy to recover the database from the backup.

The following three things will happen when you perform “DELETE OBSOLETE” from RMAN prompt:

- The physical backup files are removed from the filesystem level (or from tape backup)
- The backup entries are removed from the RMAN recovery catalog
- The entries are marked as DELETED in the Oracle control file

2. View Backups Before Delete Obsolete

RMAN> LIST BACKUP SUMMARY;

3. Perform RMAN CrossCheck

Before we start executing the delete obsolete command, it is always recommended to do a crosscheck of the backup as shown below.

crosscheck backup command will check for the records in the RMAN repository to make sure they are accurate. If there is an record in the RMAN catalog that is not available on the physical filesystem, it will make that entry with appropriate status.

RMAN> CROSSCHECK BACKUP;

4. Delete Obsolete RMAN backup

RMAN> DELETE OBSOLETE;

Do you really want to delete the above objects (enter YES or NO)? YES

Once you say “YES” to the above confirmation, then it will start deleting those obsolete backups.

WARNING: This will also physically delete the RMAN backup files from the filesystem. So, be careful and know exactly what you are doing before you execute this command.

5. Other Delete Obsolete Options

If you are writing a shell script that will automatically do this for you on an on-going basis, you don’t want to manually say “YES” to delete obsolete command as shown above.

Instead, you can ignore the prompt and automatically delete all obsolete backups as shown below.

RMAN> DELETE NOPROMPT OBSOLETE;

Also, if you want to delete obsolete backup based on your own recovery window criteria (instead of what is configured in RMAN when you do “show all”), you can specify it as shown below. The following will delete old backups based on recovery window of 10 days.

RMAN> DELETE OBSOLETE RECOVERY WINDOW OF 10 DAYS;

6. View Backups After Delete Obsolete

Finally, if you do the list backup summary, you’ll notice that this has only the backups that are required to satisfy the recovery criteria. All other backups are deleted.

RMAN> LIST BACKUP SUMMARY;

II. Delete Expired Backup

When you have an entry in the RMAN repository for a backup, but there are no corresponding physical rman backup files at the filesystem level, that is considered as expired entry.

But, you need to execute the crosscheck command, which will go through all the records in the RMAN catalog, and mark any expired records appropriately.

2. Perform RMAN CrossCheck

RMAN> CROSSCHECK BACKUP;

3. View Backups Before Delete Expired

RMAN> LIST BACKUP SUMMARY;

The value “X” indicates EXPIRED status. The value “A” indicates AVAILABLE status.

4. Delete Expired RMAN Catalog Entries

RMAN> DELETE EXPIRED BACKUP;

Do you really want to delete the above objects (enter YES or NO)?

5. View Backups After Delete Expired

After deleting the expired entries, view the catalog to make sure it contains only the active available RMAN backup records.

RMAN> LIST BACKUP SUMMARY;

ANOTHER EXAMPLES
================

The following example attempts to delete the backup set copy with tag weekly_bkup:

RMAN> DELETE NOPROMPT BACKUPSET TAG weekly_bkup;

RMAN displays a warning because the repository shows the backup set as available, but the object is not actually available on the media:

List of Backup Pieces
BP Key  BS Key  Pc# Cp# Status      Device Type Piece Name
------- ------- --- --- ----------- ----------- ----------
809     806     1   1   AVAILABLE   SBT_TAPE    0ri9uu08_1_1
 
RMAN-06207: WARNING: 1 objects could not be deleted for SBT_TAPE channel(s) due
RMAN-06208:          to mismatched status.  Use CROSSCHECK command to fix status
RMAN-06210: List of Mismatched objects
RMAN-06211: ==========================
RMAN-06212:   Object Type   Filename/Handle
RMAN-06213: --------------- ---------------------------------------------------
RMAN-06214: Backup Piece    0ri9uu08_1_1

The following command forces RMAN to delete the backup set (sample output included):

RMAN> DELETE FORCE NOPROMPT BACKUPSET TAG weekly_bkup;

using channel ORA_SBT_TAPE_1
using channel ORA_DISK_1
 
List of Backup Pieces
BP Key  BS Key  Pc# Cp# Status      Device Type Piece Name
------- ------- --- --- ----------- ----------- ----------
809     806     1   1   AVAILABLE   SBT_TAPE    0ri9uu08_1_1
deleted backup piece
backup piece handle=0ri9uu08_1_1 RECID=26 STAMP=614430728
Deleted 1 objects


RMAN> list backup of database completed before '15-JAN-16';
 
RMAN> delete backup of database completed before '15-JAN-16';
 
list backup of archivelog time between "to_date('01012015 00:00','ddmmyyyy hh24:mi')" and "to_date('24012016 23:59','ddmmyyyy hh24:mi')";

list backup of database completed between "to_date('01012015 00:00','ddmmyyyy hh24:mi')" and "to_date('24012016 23:59','ddmmyyyy hh24:mi')";

list backup of database completed between "to_date('25012016 00:00','ddmmyyyy hh24:mi')" and "to_date('03022016 23:59','ddmmyyyy hh24:mi')";

DELETE BACKUP COMPLETED between "to_date('01012015 00:00','ddmmyyyy hh24:mi')" and "to_date('23012016 23:59','ddmmyyyy hh24:mi')"; 

 
DELETE FORCE NOPROMPT BACKUPSET TAG MP0_2016-02-01_02_07;
 
 
DELETE BACKUP TAG 'MP0_2016-02-01_02_07';

DELETE BACKUP TAG 'MP0_2016-01-31_22_20';

list backup of archivelog time between "to_date('01012015 00:00','ddmmyyyy hh24:mi')" and "to_date('23012016 23:59','ddmmyyyy hh24:mi')";

list backup of database completed between "to_date('01012015 00:00','ddmmyyyy hh24:mi')" and "to_date('23012016 23:59','ddmmyyyy hh24:mi')";

DELETE BACKUP COMPLETED between "to_date('01012015 00:00','ddmmyyyy hh24:mi')" and "to_date('23012016 23:59','ddmmyyyy hh24:mi')"; 

TDPOSYNC

The tdposync utility checks for items on the Tivoli® Storage Manager server that are not in the RMAN catalog or Oracle control file. With this utility, you can repair these discrepancies between the Tivoli Storage Manager server and the RMAN catalog or Oracle control file. By removing unwanted objects in Tivoli Storage Manager storage, you can reclaim space on the server.

https://www.ibm.com/support/knowledgecenter/SSGSG7_6.3.0/com.ibm.itsm.db.orc.doc/r_dporc_util_tdposync.html



rman cmdfile=catalog.rman log=catalog_backups_rman.log 


CATALOGING BACKUP PIECES

configure channel device type 'SBT_TAPE' parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt, sbt_library=/usr/tivoli/tsm/client/oracle/bin64/libobk64.a)';

CATALOG DEVICE TYPE 'SBT_TAPE' BACKUPPIECE 'MP0_2016-02-03_18_30_s264898.log';





















