
#!/bin/bash -e
########################################################################################
#
# SCRIPT BACKUP WAL FILES
#
# Backup to Wal files from Postgres Database
#
#
# PARAMETERS :
#	      DB_NAME : Name of database for Postgres. Ex: ZABBIX , TPLINUX
#             BKP_DIR : Directory where the backup was saved
#
########################################################################################

DB_NAME=${1^^}
BKP_DIR=$2
BKP_NAME=$3
BKP_THREAD=$4
DATE=`date +%d%m%Y_%H%M%S`
LOG_DIR=/postgres/kdba/log
LOG=${LOG_DIR}/Backup_WAL_POSTGRES_"${DB_NAME}"_"${DATE}"_"${BKP_THREAD}".log

exec &> >(tee -a "${LOG}")
filelist="$(mktemp)"
find /backup/zabbix/archives/${BKP_NAME}* -print0 > "$filelist"
tar -czvf /backup/zabbix/backup_postgres/wal/"wal_bkp_$(date +%Y-%m-%d-%H-%M-%S)_${BKP_THREAD}.tar.gz" --null -T "$filelist"
xargs -0 rm < "$filelist"
rm "$filelist"
ReturnCode=$?
echo "Execucao Finalizada com Status ${ReturnCode}"
exec 2>&1
