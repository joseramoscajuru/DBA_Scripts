
To get the total size of disk space in a system (in Gigabytes):

#!/usr/bin/ksh
TOTAL=0
for ff in $(lspv | awk '{ print $1 }')
do
size=$(bootinfo -s $ff)
((TOTAL=(TOTAL+size)/1024))
done
echo $TOTAL

