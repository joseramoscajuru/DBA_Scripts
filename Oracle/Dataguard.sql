MAN-LDBP1  GRP0  ->  MAN-LDBP3  DGGRP0
MAN-LDBP2  ORP6  ->  MAN-LDBP3  DGORP6

Estes so alguns links que vcs podem usar para referencia:

Criar Standby fsico:
http://docs.oracle.com/cd/B19306_01/server.102/b14239/create_ps.htm#i63561

Cenrios:
http://docs.oracle.com/cd/B19306_01/server.102/b14239/scenarios.htm#i1008082

O Exemplo abaixo est para a base GRP0, basta repetir o mesmo processo para a ORP6 mudando os nomes.

===== Instalar binrios - MAN-LDBP3 =====

cd /utility/oracle/stage/database

./runInstaller -silent -force -ignoreSysPreReqs -responseFile /utility/oracle/stage/10gR2.rsp \
   FROM_LOCATION="/utility/oracle/stage/database/stage/products.xml" \
   ORACLE_HOME="/oracle/u18/app/oracle/product/10.2.0/GRP0"
   ORACLE_HOME_NAME="GRP0"

cd /utility/oracle/stage/Disk1
./runInstaller -silent -ignoreDiskWarning -ignoreSysPreReqs \
   -responseFile /utility/oracle/stage/Disk1/response/patchset.rsp \
   ORACLE_HOME="/oracle/u18/app/oracle/product/10.2.0/GRP0" \
   ORACLE_HOME_NAME="GRP0"

. oraenv (dggrp0)

cd $ORACLE_HOME
mv OPatch OPatch_old
unzip /utility/oracle/stage/OPatch_10204_Generic_v9.zip

cd /utility/oracle/stage/9119284
$ORACLE_HOME/OPatch/opatch apply

===== Criar orapwd =====

** J os criei e esto no /utility/oracle e precisam ser copiados para $ORACLE_HOME/dbs

orapwd file=orapwdggrp0 password=XXXXX entries=10

===== Configurar parameter file ======

** Esto em anexo, mas a diferena para o do n principal so apenas esses parmetros:

db_unique_name='dggrp0'
fal_client='dggrp0'  ---  a entrada no /etc/tnsnmames.ora. No primrio  o inverso
fal_server='grp0'  ---  a entrada no /etc/tnsnmames.ora. No primrio  o inverso
local_listener='(ADDRESS=(PROTOCOL=TCP)(HOST=10.12.143.2)(PORT=1525))'
log_archive_config='DG_CONFIG=(grp0,dggrp0)'
log_archive_dest_1='LOCATION=/logs/oracle/grp0/grp2_ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=dggrp2'
log_archive_dest_2='SERVICE=grp2 LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=grp2'
standby_archive_dest='/logs/oracle/grp2/grp2_'
standby_file_management='AUTO'

===== Configurar Net Services ========

Configurar no servidor do dataguard o /etc/listener.ora. As portas devero ser as mesmas que no man-ldbp1 e man-ldbp2, porm muda apenas o IP, que deve ser do man-ldbp3
Configurar no man-ldbp1/2 as entradas no /etc/tnsnames.ora apontando para o dggrp0 e dgorp6 e no man-ldbp3 apontando para o man-ldbp1

===== Criar o control file de standby =======

alter database create standby controlfile as '/tmp/control.dbf'; 

Copia-lo para o target com os mesmos nomes que est no init ('/oracle/u02/oradata/grp0/control01.ctl','/oracle/u03/oradata/grp0/control02.ctl')

====== Copiar datafiles para o Target =======

- Colocar banco em Begin Backup " alter database begin backup; "

- Copiar todos os datafiles para o man-ldbp3 nos mesmos diretrios que esto l. A estrutura de filesystem  identica

- Tirar banco em Begin Backup " alter database end backup; "

====== Subir Standby no man-ldbp3 ========

	startup nomount
	alter database mount standby database;
	alter database recover managed standby database disconnect from session; 

====== Ligar Envio de logs do Primrio para o Standby =========

alter system set log_archive_dest_2 = 'SERVICE=dggrp0 ARCH ASYNC=20480 NOAFFIRM DELAY=0 MAX_FAILURE=10 REOPEN=300 DB_UNIQUE_NAME=dggrp0' scope=both;
alter system set log_archive_dest_state_2=enable scope=both;

====== Outras opes no Primrio =========

Estas opes podem ser feitas com o banco no ar, ou numa outra oportunidade, pois sero utilizados quando estes banco se tornarem Standby

fal_client='grp0'  ---  a entrada no /etc/tnsnmames.ora
fal_server='dggrp0'  ---  a entrada no /etc/tnsnmames.ora
log_archive_config='DG_CONFIG=(grp0,dggrp0)'

===== Verificar se os logs esto sendo enviados ========

No banco principal/primrio, rodar:

col destination forma a30
col dest_name format a30
col error format a20
set lines 180

select dest_id, dest_name, status, protection_mode, destination, error, srl, archived_seq#, applied_seq#  from v$archive_dest_status where status <> 'INACTIVE';

O Dest_2 deve estar com apenas 1 de diferena na sequencia de logs. Pode se usar esta query nos dois bancos  grp2 e dggrp0 pra ver se o os mesmos logs esto l

select max(sequence#) from v$log_history;
select sequence#, applied from v$archived_log;







########################initdggrp0.ora
_db_fast_obj_truncate=FALSE
audit_file_dest='/debug/oracle'
audit_trail='db'
background_dump_dest='/debug/oracle'
compatible='10.2.0'
control_files='/oracle/u02/oradata/grp0/control01.ctl','/oracle/u03/oradata/grp0/control02.ctl'
core_dump_dest='/debug/oracle'
db_block_size=8192
db_cache_size=512M
db_domain='whirlpool.com'
db_name='grp0'
fast_start_mttr_target=300
job_queue_processes=5
large_pool_size=20M
log_archive_dest_1='LOCATION=/logs/oracle/grp0/grp0_ VALID_FOR=(ALL_LOGFILES,ALL_ROLES)'
log_archive_format='%t_%r_%S.log'
log_archive_max_processes=2
log_buffer=1048576
log_checkpoint_timeout=0
max_dump_file_size='1048576'
nls_date_format='dd/mm/yyyy'
open_cursors=300
parallel_max_servers=5
pga_aggregate_target=300M
processes=300
remote_login_passwordfile='EXCLUSIVE'
remote_os_authent=FALSE
sga_max_size=2048M
sga_target=1500M
shared_pool_reserved_size=50M
shared_pool_size=512M
streams_pool_size=0
undo_management='AUTO'
undo_retention=32400
undo_tablespace='UNDOTBS1'
user_dump_dest='/debug/oracle'

db_unique_name='dggrp0'
fal_client='dggrp0'
fal_server='grp0'
local_listener='(ADDRESS=(PROTOCOL=TCP)(HOST=10.12.143.2)(PORT=1525))'
log_archive_config='DG_CONFIG=(grp0,dggrp0)'
log_archive_dest_1='LOCATION=/logs/oracle/grp0/grp0_ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=dggrp0'
log_archive_dest_2='SERVICE=grp0 LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=grp0'
standby_archive_dest='/logs/oracle/grp0/grp0_'
standby_file_management='AUTO'




###############initdgorp6.ora
audit_file_dest='/debug/oracle'
audit_trail='DB'
background_dump_dest='/debug/oracle'
compatible='10.2.0'
control_files='/oracle/u12/oradata/orp6/control01.ctl','/oracle/u13/oradata/orp6/control02.ctl'
core_dump_dest='/debug/oracle'
db_block_size=8192
db_cache_size=512M
db_domain='whirlpool.com'
db_name='orp6'
fast_start_mttr_target=300
job_queue_processes=2
large_pool_size=20M
log_archive_dest_1='LOCATION=/logs/oracle/orp6/orp6_ VALID_FOR=(ALL_LOGFILES,ALL_ROLES)'
log_archive_format='%t_%r_%S.log'
log_archive_max_processes=2
log_checkpoint_timeout=0
max_dump_file_size='1048576'
nls_date_format='dd/mm/yyyy'
open_cursors=300
parallel_max_servers=5
pga_aggregate_target=300M
processes=300
remote_login_passwordfile='EXCLUSIVE'
remote_os_authent=FALSE
sga_max_size=2048M
sga_target=1500M
shared_pool_reserved_size=50M
shared_pool_size=512M
streams_pool_size=0
undo_management='AUTO'
undo_retention=32400
undo_tablespace='UNDOTBS'
user_dump_dest='/debug/oracle'

db_unique_name='dgorp6'
fal_client='dgorp6'
fal_server='orp6'
local_listener='(ADDRESS=(PROTOCOL=TCP)(HOST=10.12.143.2)(PORT=1525))'
log_archive_config='DG_CONFIG=(orp6,dgorp6)'
log_archive_dest_1='LOCATION=/logs/oracle/orp6/orp6_ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=dgorp6'
log_archive_dest_2='SERVICE=orp6 LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=orp6'
standby_archive_dest='/logs/oracle/orp6/orp6_'
standby_file_management='AUTO'

