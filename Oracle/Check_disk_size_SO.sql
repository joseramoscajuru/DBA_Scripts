
AIX

bootinfo -s hdiskX--> gives the size of the given disk.

If you need the size of all the disks, check for the disks which are all available.

lsdev -Cc disk

And then, suppose 5 disks are there,

# for i in 0 1 2 3 4 5
do
bootinfo -s hdisk$i
done

for i in $(lsdev -Cc disk | awk '{ print $1}')
do
echo $i ; bootinfo -s $i 
done

for i in $(lspv | awk '{ print $1}')
do
bootinfo -s $i
done

LINUX

check disk size

lsblk /dev/sdj1

[oracle@lsiamigisdb01 ~]$ lsblk /dev/sdj1
NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdj1   8:145  0  100G  0 part 
