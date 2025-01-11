#Configuraes de TSM
/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt

Para enviar somente um arquivo para fita:
dsmc selective <nome do arquivo>
Exemplo: 

dsmc selective /ora/POMERC1P0/backup01/POMER1P0_arch_POMER1P0_641878084_3246_1

Para enviar todos os arquivos de um determinado path para fita:

dsmc incremental <path>

dsmc incremental /ora/POMERC1P0/backup01


#########################Arthur
dsmc archive -filelist=tsm_list.out -deletefiles

dsmc backup -filelist=tsm_backup_list.out -deletefiles



dsmc archive -filelist=tsm_backup_list.out -archmc=DYNBKUP -deletefiles

### LIMPEZA DA AREA DE BACKUP - APAGA O QUE JA FOI PARA FITA ###
for FL in `ls -tr1 *arch*`; 
do
echo Checking file $FL
dsmc query backup -inactive $FL 2> /dev/null | grep 'Backup Date' > /dev/null
if [ $? -eq 0 ]
then
echo ... File already sent to the tape. Removing file from disk.
rm -f $FL
else 
echo ... Rechecking file
dsmc query backup -inactive $FL 2> /dev/null | grep 'Backup Date' > /dev/null
if [ $? -eq 0 ]
then
echo ...... File sent to the tape. Removing file from disk.
rm -f $FL
else 
echo ...... File not sent to the tape yet. Leaving it in the disk.
fi
fi
echo [Filesystem ocupation: `df -k . | tail -1 | cut -f1 -d% | awk -F" " '{print $NF}'`%]
done

