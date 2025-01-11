for FL in `ls -tr1 *POSSO1P*`; 
do
echo Checking file $FL
dsmc query backup -inactive $FL 2> /dev/null | grep 'Backup Date' > /dev/null
if [ $? -eq 0 ]
then
echo ... File already sent to the tape. Removing file from disk.
rm -f $FL
else 
echo ... File not sent to the tape yet. Trying to send it.
dsmc selective $FL > /dev/null 2>&1
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

