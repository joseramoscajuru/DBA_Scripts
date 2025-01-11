Backup:

run
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(tdpo_optfile=/opt/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
backup incremental level = 0
database
filesperset 20
format 'sblprd_full_%d_%s_%p_%t_%c'
tag = 'sblprd_INC0_OPEN';
release channel t1;
}

run
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(tdpo_optfile=/opt/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
sql "alter system archive log current";
backup archivelog all
format 'sblprd_ar_%d_%s_%p_%t_%c'
delete input;
release channel t1;
}

Restore:

Frist start the db in mount stage to restore the control file after connecting to the recovery catalog.
run
{
allocate channel p1 type 'sbt_tape' parms 'ENV=(tdpo_optfile=/opt/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
restore controlfile;
release channel p1;
}
then restore the db
run
{
sql "alter session set optimizer_mode=RULE";
allocate channel p1 type 'sbt_tape' parms 'ENV=(tdpo_optfile=/opt/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
restore database;
recover database;
sql "ALTER DATABASE OPEN";
release channel p1;
}

