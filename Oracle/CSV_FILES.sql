
SET PAGESIZE 50000
SET MARKUP HTML ON TABLE "class=detail cellspacing=0" ENTMAP OFF
SPOOL output.log
<query>;
SPOOL OFF
quit;

To run the query, ssh into your server,

nohup sqlplus username/password@oracleServer @nameOfTheQuery.sql &

From the OS command prompt, issue:

# nohup sqlplus <username>/<password> @<script name>.sql &

Or as sysdba (if sysdba is needed to run the script):

# nohup sqlplus "/ as sysdba" @<script name>.sql &

#nohup sqlplus un/pw @script.sql > file.out 2>&1 &

TABLE NAMES:

COC_GSP_MASTER
Z_COC_ACCEPT_STATU 
Z_COC_EVALUTNFFORM
Z_COC_FACI_DET
Z_COC_ONLINEASSMNT
Z_COC_REJECTIONCOM

set colsep ,
set lines 500 pages 0 trimspool on
set heading off  
spool SAPEPPDB_COC_GSP_MASTER.csv
select * from SAPEPPDB.COC_GSP_MASTER;
spool off

set colsep ,
set lines 500 pages 0 trimspool on
set heading off   
spool SAPEPPDB_Z_COC_ACCEPT_STATU.csv
select * from SAPEPPDB.Z_COC_ACCEPT_STATU;
spool off

set colsep ,
set lines 500 pages 0 trimspool on
set heading off   
spool SAPEPPDB_Z_COC_EVALUTNFFORM.csv
select * from SAPEPPDB.Z_COC_EVALUTNFFORM;
spool off

set colsep ,
set lines 500 pages 0 trimspool on
set heading off  
spool SAPEPPDB_Z_COC_FACI_DET.csv
select * from SAPEPPDB.Z_COC_FACI_DET;
spool off

set colsep ,
set lines 500 pages 0 trimspool on
set heading off   
spool SAPEPPDB_Z_COC_ONLINEASSMNT.csv
select * from SAPEPPDB.Z_COC_ONLINEASSMNT;
spool off

set colsep ,
set lines 500 pages 0 trimspool on
set heading off  
spool SAPEPPDB_Z_COC_REJECTIONCOM.csv
select * from SAPEPPDB.Z_COC_REJECTIONCOM;
spool off