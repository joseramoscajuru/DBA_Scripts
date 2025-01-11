RMAN> connect target /
2> connect catalog ct_tesdsv/rman4ibm@RMAN
3> run {
4>  startup force
5>  shutdown immediate
6>  startup mount
7>  allocate channel t1 type 'sbt_tape'
8>           parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
9>  backup database
10>   filesperset=5
11>   tag 'TESDSV-Backup-Offline'
12>   format '%d_%t_%s_%p.dbf';
13>  sql 'alter database open';
14>  backup current controlfile;
15>  sql 'ALTER DATABASE BACKUP CONTROLFILE TO TRACE';
16>  release channel t1;
17> }

