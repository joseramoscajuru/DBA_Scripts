
alter database add logfile group 4 
('I:\ORACLE\QAS\ORIGLOGA\LOG_G11M1.DBF','I:\ORACLE\QAS\MIRRLOGA\LOG_G11M2.DBF')
size 1g reuse; 
     
alter database add logfile group 5 
('I:\ORACLE\QAS\ORIGLOGB\LOG_G12M1.DBF','I:\ORACLE\QAS\MIRRLOGB\LOG_G12M2.DBF')
size 1g reuse;

alter database add logfile group 6
('I:\ORACLE\QAS\ORIGLOGA\LOG_G13M1.DBF','I:\ORACLE\QAS\MIRRLOGA\LOG_G13M2.DBF')
size 1g reuse;

alter database add logfile group 7 
('I:\ORACLE\QAS\ORIGLOGB\LOG_G17M1.DBF','I:\ORACLE\QAS\MIRRLOGB\LOG_G17M2.DBF')
size 1g reuse;


alter database drop logfile group 1;

alter database drop logfile group 2;

alter database drop logfile group 3;