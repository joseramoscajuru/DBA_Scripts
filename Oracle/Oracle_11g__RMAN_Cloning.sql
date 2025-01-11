
Oracle 11g: RMAN Cloning

By Mary Mikell Spence

Using RMAN to clone a database is a method that been around for years and years now.  Judging from the number of questions that I personally get about it, along with the number of questions I see posted out in the “Interweb”, it’s clear that there is still room for one more step-by-step article on the subject.

In the old days, (i.e. pre-RMAN) there were few options available for database cloning.  A clone was a home-grown affair where we would use a hot or cold backup and recreate the controlfile.  But, even after that, there were always some loose ends-- the temporary tablespace files would still need to be added, and the DBID would need to be changed, for instance.  The beauty of RMAN is that all of those details get taken care of for you—and if you’re using Oracle Managed Files, it gets even simpler.
Nomenclature

With RMAN, Oracle introduced its own terms regarding the source database and the clone.  It can be fairly confusing at first and I’ve found that most RMAN newbies are thrown by it, but we need to stick with what Oracle uses:

    The source database is designated by RMAN to be the target database.
    The new, cloned database is designated by RMAN to be the auxiliary database.

When the Backup is on Disk

If your auxiliary instance is on a different server from the target, then be aware that the backup needs to be available at the same location on the auxiliary’s server as it is on the target’s server.  If the backup is under /u01/backups/PRD, then that’s where RMAN is going to look for it.  You can’t just copy the backup to an arbitrary location and read it from there.  There are several options for dealing with this:

    NFS mount the backup.
    Copy it over to a like-named location.
    Copy it to the auxiliary’s server and create a soft link.

When the Backup is on Tape
Related Articles

    Top 10 New Features for Oracle 11g Data Guard - Part Two
    Oracle 11gR2 I/O Performance Tuning: Using Solid State Drives

If you’re at all familiar with using RMAN directly to tape, then you know that there are a number of different tape subsystems out there and that each of them handles things a bit differently.  In general though, whatever parameters you’re using to open a channel for a normal restore will apply for the clone.  Things can get tricky, however, if you’re doing a redirected restore.  That is, a clone to a different server from where the backup was performed.  In that case, check the documentation from the tape vendor.  I’ve done it many times, but dealing with all of the nuances of the varied tape subsystems available is out of the scope of this article.  Do not despair though.  It CAN be done and the tape vendor should be able to help you.
Prepare the Auxiliary Instance Environment

When cloning using any method, the requirement is that the OS platform and the database version are all the same.  If your clone is going to be on a different server from the target, a good method for ensuing the the Oracle Home is exactly the same is to clone it as well.  Copy over the entire Oracle Home using your preferred method and then use the following commands on the auxiliary server (mileage may vary slightly based on your OS and Oracle version):

$ cd <new oracle home>/oui/bin
$ ./runInstaller -clone -silent -ignorePreReq -noconfig \
  ORACLE_HOME="<new oracle home>" \
  ORACLE_HOME_NAME="OraHome11g"

This will relink the Oracle binaries on the new server and add the new Oracle Home to the central inventory.  When this completes, you’ll need to run root.sh as the root user just as you do any time Oracle binaries are installed.

Next create an init.ora and a password file under the new $ORACLE_HOME/dbs directory.  For the init.ora, it’s best (and easiest) to start with the one from the target database and make the necessary modifications.  While you’re doing that, be sure to create any directories that the init.ora references.

Create the password file and provide the same SYS password that’s currently in use on the target database:

$ cd <new oracle home>/dbs
$ orapwd file=orapwNEWDB password=syspassword ignorecase=y

“Start Your Engines!”

Add the new SID to your oratab and use oraenv to set your environment for the auxiliary instance, which needs to be started but not mounted.  If you are cloning to a RAC database, then the cluster_database parameter needs to be set to FALSE before you begin.  Whether using RAC or not, use SQLPlus to startup:

$ sqlplus / as sysdba
 
SQL> startup nomount

Check the Ingredients List

For your clone, you need the following:

1. An Oracle Home at the same version and patch level as the source database.

2. Init.ora and password file.

3. Destination directories.

4. RMAN backup of the target database.

We have addressed one, two, and three.  We’ve touched on four.  One of the really nice things about RMAN is the ability to easily do a point-in-time recovery.  When cloning, I’ve found it’s best to always specify exactly how far you want to roll the clone forward.  That seems to ensure the cleanest execution of the process.  With that in mind, all of the archivelogs that you need should be backed up so that RMAN is able to find them in a backup set.  This will be clearer when you examine the clone script.
The Clone Script

What follows is a script that I developed years ago and which has frankly changed very little.  It has served me very well and I share it often.  The script is run on the server where the auxiliary instance resides.  The environment should be set for the auxiliary instance before you run this.

DATESTAMP=`date '+%y%m%d%H%M'`
NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'
export NLS_DATE_FORMAT
MSGLOG=dup_prod_${DATESTAMP}.log
#
$ORACLE_HOME/bin/rman msglog $MSGLOG append << EOF
connect target sys/manager@proddb
connect auxiliary /
run
{
set until time "to_date('26-JAN-2014 12:00','DD-MON-YYYY HH24:MI')" ;
##   set until logseq 12052 thread 1 ;
##   set until time "trunc(sysdate)+5/24" ;
sql 'alter session set optimizer_mode=rule' ;
allocate AUXILIARY channel c1 type disk ;
duplicate target database to 'testdb'
   db_file_name_convert=('/u01/oradata/proddb','/u01/oradata/testdb',
                         '/u02/oradata/proddb','/u02/oradata/testdb')
   logfile
      GROUP 1 ( '/u01/oradata/testdb/log01a.dbf') SIZE 128m,
      GROUP 2 ( '/u01/oradata/testdb/log02a.dbf') SIZE 128m,
      GROUP 3 ( '/u01/oradata/testdb/log03a.dbf') SIZE 128m ;
}
EOF

The above script will “roll forward” to the date/time specified in the “set until time” clause.  In other words, it will perform a point-in-time clone.  Note the commented lines.  If for some reason you want to roll forward to a particular archivelog, use the “set until logseq” clause instead.  If the clone occurs regularly (and yes, it is possible to schedule a weekly clone using this as a framework), you can use the “set until time” clause and use a date function.  In this case "trunc(sysdate)+5/24" which will roll forward to 5:00 AM of the current day.

Many people put the db_file_name_convert parameter into the init.ora, but I’ve found it more convenient to have it in here, in the clone script.  Be sure that those directories exist before starting the clone.

The logfile clause simply allows you to specify where and how the redo logs are created.

If using Oracle Managed Files (OMF), you can and should leave out the db_file_name_convert parameter.  The files will get placed in the location specified by the db_create_file_dest parameter in your init.ora.

If your clone is a RAC database, upon completion of the clone you will need to create the redo logs for the other threads.  You should expect to see the ones you specify in the script to be created for thread 1 only.  This makes sense as cluster_database was set to false during the clone.
Loose Ends

When the clone completes, as was alluded to earlier, most of the annoying loose ends should be taken care of.  In earlier versions of Oracle (i.e. 10g) occasionally the temporary tablespace datafiles would not get created.  But, I’ve not had an issue with that with 11g.  Another common problem can be not having enough archivelogs in the backup set to satisfy the “set until” clause specified.  However, once you work through any glitches that may arise, you’ll find that cloning could not be easier using RMAN.