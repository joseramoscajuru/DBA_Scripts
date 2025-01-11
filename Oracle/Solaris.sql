Ao Time de Oracle:

O script abaixo verifica todas as informaes referentes ao um processo ativo no sistema operacional (Solaris/SunOS).
Ele foi necessario para checagem da evoluo de um processo de backup em execuo, o qual - devido ao tamanho 
da database em questo ser de cerca de 3.5TB - exige longo tempo de processamento. Segue seus detalhes:

---------------------------------------------------------------------------------
---- O Script abaixo (check_pro.sh) verifica todas as informacoes referentes ----
---- ao numero de processo fornecido                                         ----
----                                                                         ----
---- Sintaxe: $ check_pro.sh <num_processo>                                  ----
---------------------------------------------------------------------------------

#!/usr/bin/ksh
#
# check_pro: Check the informations related to a process_number
#            For Solaris LINUX Operating System
#
# Created By Luiz Cassio Alves
# Oracle DBA Team - BRAZIL IBM
# eMail: lcassioa@br.ibm.com
#
NPROC=$1

# If NPROC are not a valid process number,
# advise the DBA and exit.
ls -ld /proc/$NPROC >/dev/null 2>&1
[ $? != 0 ] && { echo "check_pro.sh: $NPROC: invalid process number"
                 exit ;}

# Check the Status For Process NPROC
echo "===> Actual ${NPROC}'s Status"
pflags $NPROC
echo

# Check All the Process(es) attached to NPROC
echo "===> Process(es) attached to $NPROC"
ptree $NPROC
echo

# Check Working directory for NPROC
echo "===> ${NPROC}'s Working directory"
pwdx $NPROC
echo

# Check Files/Directories attached to NPROC
echo "===> ${NPROC}'s Attached Files/Directories"
pfiles -F $NPROC | grep ino: | cut -d: -f5 | awk '{print $1}' | while read INUM
do
find /u01/app/oracle -inum $INUM -exec ls -lid {} \;
done
echo

---------------------------------------------------------------------------------------
--------------------------------------- Exemplo ---------------------------------------
---------------------------------------------------------------------------------------

afsdev02:fin80cyp /orafdev/oracle>./check_pro.sh 28319
===> Actual 28319's Status
28319:  sh /u01/app/oracle/dbtools/hot_backups/hot_full.sh fin80cyp /u01/app/o
        data model = _ILP32  flags = PR_ORPHAN
  /1:   flags = PR_PCINVAL|PR_ASLEEP [ waitid(0x0,0x6eac,0xffbff7f0,0x83) ]

===> Process(es) attached to 28319
28319 sh /u01/app/oracle/dbtools/hot_backups/hot_full.sh fin80cyp /u01/app/oracle/dbt
  28332 /orafdev/oracle/product/9.2.0/bin/rman cmdfile=/u01/app/oracle/dbtools/hot_back
    28349 oraclefin80cyp (DESCRIPTION=(LOCAL=YES)(ADDRESS=(PROTOCOL=beq)))
    28352 oraclefin80cyp (DESCRIPTION=(LOCAL=YES)(ADDRESS=(PROTOCOL=beq)))
    28357 oraclefin80cyp (DESCRIPTION=(LOCAL=YES)(ADDRESS=(PROTOCOL=beq)))
    28364 oraclefin80cyp (DESCRIPTION=(LOCAL=YES)(ADDRESS=(PROTOCOL=beq)))
    28369 oraclefin80cyp (DESCRIPTION=(LOCAL=YES)(ADDRESS=(PROTOCOL=beq)))

===> 28319's Working directory
28319:  /u01/app/oracle/dbtools/logs

===> 28319's Attached Files/Directories
     55840 -rw-r--r--   1 oracle   dba            0 Apr 29 18:05 /u01/app/oracle/dbtools/logs/fin80cyp.log
     56874 -rw-------   1 oracle   dba            0 Apr 28 21:52 /u01/app/oracle/dbtools/logs/nohup.out
     55838 -rwx------   1 oracle   dba         3803 Apr 22 16:13 /u01/app/oracle/dbtools/hot_backups/hot_full.sh

afsdev02:fin80cyp /orafdev/oracle>_

Fico  disposio de voces para correes/crticas/sugestes.

Espero que ajude a vocs, tambm.

