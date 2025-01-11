for FL in `ls -tr1 *POOEMDB*`;
do
dsmc query backup -inactive $FL 2> /dev/null | grep 'Backup Date' > /dev/null
if [ $? -eq 0 ]
then
echo -File `ls -l $FL` already sent to the tape.

else
echo ... File `ls -l $FL` not sent to the tape yet.
fi
done



dsmc query backup -inactive DBPSPROD 2> /dev/null | grep 'Backup Date' > /dev/null
