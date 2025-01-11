How to move ASM database files from one diskgroup to another ? (Doc ID 330103.1)	

SOLUTION
 
The preferred way of doing the file movement amoung ASM DISKGROUPS is using RMAN. RMAN is critical to Automatic Storage Management and is responsible for tracking the ASM filenames and for deleting obsolete ASM files. Since ASM files cannot be accessed through normal operating system interfaces, RMAN is the preferred means of copying ASM file.

Note: From 12c, you can use the ALTER DATABASE MOVE DATAFILE SQL statement to rename or relocate online data files.

Following example moves the data file from one Oracle ASM location to another Oracle ASM location.

ALTER DATABASE MOVE DATAFILE '+dgroup_01/data/orcl/datafile/user1.dbf' TO '+dgroup_02/data/orcl/datafile/user1.dbf';

https://docs.oracle.com/database/121/ADMIN/dfiles.htm#ADMIN11430 



The steps involved in moving a datafile from a diskgroup to another is as given below. 


1) Identify the data file to be moved.
2) Identify the diskgroup on to which the file has to be moved.
3) Take the file offline.
4) Copy the file to new diskgroup using Either RMAN or DBMS_FILE_TRANSFER.
5) Rename the file to point to new location.
6) Recover the file.
7) Bring the file online.
8) Verify the new file locations.
9) Delete the file from its original location.


1) Identify the data file to be moved.
 ----------------------------------------
         In database instance

         SQL:ORCL> SELECT FILE_NAME FROM DBA_DATA_FILES:

                            +ASMDSK2/orcl/datafile/users.256.565313879 <======= Move this to ASMDSK1.
                            +ASMDSK1/orcl/sysaux01.dbf
                            +ASMDSK1/orcl/undotbs01.dbf
                            +ASMDSK1/orcl/system01.dbf

2) Identify the diskgroup on to which the file has to be moved.
--------------------------------------------------------------
      In ASM instance

          SQL:ASM> SELECT GROUP_NUMBER, NAME FROM V$ASM_DISKGROUP;

                           GROUP_NUMBER NAME
                             ------------ ---------
                                             1 ASMDSK1
                                             2 ASMDSK2



3) Take the file offline.
--------------------------

          SQL:ORCL> ALTER DATABASE DATAFILE '+ASMDSK2/orcl/datafile/users.256.565313879' OFFLINE;


 4)Now Copy the file from Source diskgroup ASMDSK1 to target Diskgroup ASMDSK2.
--------------------------------------------------------------------------------------------
   Either
      4. a)   DBMS_FILE_TRANSFER   package or
      4. b)   RMAN 

   can be used for this step.
       ( The step 5 to step 8  is based on the filenames  from method b).

       
        4.a).Using DBMS_FILE_TRANSFER package 
       
          
        SQL:ORCL>create or replace directory orcl1 as '+asmdsk1/orcl/datafile';
        
        SQL:ASM> Alter disgroup asmdsk2 add directory  '+asmdsk2/test';
        
        SQL:ORCL> create or replace directory orcl2 as '+asmdsk2/test';
        
        
       
        SQL:ORCL>
                BEGIN
                  DBMS_FILE_TRANSFER.COPY_FILE(
                  source_directory_object => 'ORCL1',
                  source_file_name => 'users.259.565359071',
                  destination_directory_object => 'ORCL2',
                  destination_file_name => 'USERS01.DBF');
                END;                            Database altered.

          4 b).Using RMAN copy the file to new diskgroup.

            $ rman target system@orcl10

            target database Password:
            connected to target database: ORCL (DBID=1089529226)

            RMAN>
            RMAN> COPY DATAFILE '+ASMDSK2/orcl/datafile/users.256.565313879' TO '+ASMDSK1';

                   Starting backup at 03-AUG-05
                   using target database controlfile instead of recovery catalog
                   allocated channel: ORA_DISK_1
                   channel ORA_DISK_1: sid=146 devtype=DISK
                   channel ORA_DISK_1: starting datafile copy
                   input datafile fno=00004 name=+ASMDSK2/orcl/datafile/users.256.565313879
                   output filename=+ASMDSK1/orcl/datafile/users.259.565359071 tag=TAG20050803T12110
                   9 recid=2 stamp=565359071
                   channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:03
                   Finished backup at 03-AUG-05

5) Rename the file to point to new location.
-------------------------------------------
          If you have used DBMS_FILE_TRANSFER (method 4 a)) use the following command to rename:
             SQL:ORCL> ALTER DATABASE RENAME FILE '+ASMDSK2/orcl/datafile/users.256.565313879' TO
                                                                                               '+ASMDSK1/orcl/datafile/users.259.565359071'

                           Database altered.

      If you have used RMAN (method 4 b) use the following option of RMAN
                 RMAN run {
                                      set newname for datafile '+ASMDSK2/orcl/datafile/users.256.565313879' 
                                                                        to '+ASMDSK1/orcl/datafile/users.259.565359071' ;
                                    switch datafile all;
                                    }

6) Recover the file.
-------------------
           SQL:ORCL> RECOVER DATAFILE '+ASMDSK1/orcl/datafile/users.259.565359071'
                             Media recovery complete.

7) Bring the file online.
-----------------------
             SQL:ORCL>ALTER DATABASE DATAFILE '+ASMDSK1/orcl/datafile/users.259.565359071' ONLINE

                                 Database altered.

8) Verify the new file location.
---------------------------------
           SQL:ORCL> SELECT FILE_NAME FROM DBA_DATA_FILES;

                    FILE_NAME
                   -------------------------------------------------------------------------------
                  +ASMDSK1/orcl/datafile/users.259.565359071
                  +ASMDSK1/orcl/sysaux01.dbf
                  +ASMDSK1/orcl/undotbs01.dbf
                  +ASMDSK1/orcl/system01.dbf

9) Delete the file from its original location either per SQLPLUS or per ASMCMD:

   e.g.: SQL:ASM> ALTER DISKGROUP ASMDSK2 DROP FILE users.256.565313879;

   or:   ASMCMD> rm -rf <filename>

      Note:
      Most Automatic Storage Management files do not need to be manually deleted because, as Oracle managed files, they are removed automatically when they are no longer needed.

      However, if you need to drop an Oracle Managed File (OMF) manually you should use the fully qualified filename if you reference the file. Otherwise you will get an error (e.g. ORA-15177).

   e.g.: SQL:ASM> ALTER DISKGROUP ASMDSK2 DROP FILE '+ASMDSK2/orcl/datafile/users.256.565313879';

Note: The steps provided above assume that the database is open and in Archivelog mode.

         Besides these steps are not appropriated for system or sysaux datafiles. For System and Sysaux an approach similar to the one given below can be used:

   1. Create a Copy of datafile in target Diskgroup:

       RMAN> backup as copy tablespace system format '<New DG>'; 
       RMAN> backup as copy tablespace sysaux format '<New DG>';

   2. Then shutdown the database and restart to a mounted state

      RMAN> shutdown immediate;
      RMAN> startup mount; 

   3. switch the datafiles to the copy

      RMAN> switch tablespace system to copy;
      RMAN> switch tablespace sysaux to copy;

   4. Recover the changes made to these tablespaces;

      RMAN> recover database;