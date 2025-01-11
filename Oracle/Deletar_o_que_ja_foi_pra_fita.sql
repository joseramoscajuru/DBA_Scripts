cd /ora/backup/POHDS2S
export BACKUP_DEST=`pwd`
ls ${BACKUP_DEST}/uss1uap006ampsb* > Archive_tsm_list2.out
dsmc archive -filelist=Archive_tsm_list2.out  -deletefiles -archmc=DYNBKUP

######## Backup HOT
for FL in `ls -tr1 *pooemdb*`; 
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


######## Backup Archive
for FL in `ls -tr1 *POSSO1P*`; 
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

