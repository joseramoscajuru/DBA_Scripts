#!/bin/bash -e
########################################################################################
#
# SCRIPT BACKUP FULL DATABASE
#
# Backup to Full Database from Postgres Database
#
#
# PARAMETERS :
#	      DB_NAME : Name of database for Postgres. Ex: ZABBIX , TPLINUX
#             BKP_DIR : Directory where the backup was saved
#
########################################################################################

DB_NAME=${1^^}
BKP_DIR=$2
DATE=`date +%d%m%Y_%H%M%S`
DATE_TRUNC=`date +%d%m%Y`
#BASE_DIR=`grep "BKP_DIR=" /etc/ibmdba | grep -v "#" | cut -d'=' -f2`
BASE_DIR=/postgres/kdba
LOG_DIR=${BASE_DIR}/log
LOG=${LOG_DIR}/Backup_POSTGRES_"${DB_NAME}"_FULL_$DATE.log

exec &> >(tee -a "${LOG}")
pg_basebackup -U postgres -D ${BKP_DIR}/full/bkp_full_${DATE_TRUNC} -Ft -z -v --checkpoint=fast
ReturnCode=$?
echo "Execucao Finalizada com Status ${ReturnCode}"
exec 2>&1

#${BASE_DIR}/job/backup_FILESPOSTGRES.ksh ${DB_NAME} full brlxpmtz0105b ${BKP_DIR}/database
