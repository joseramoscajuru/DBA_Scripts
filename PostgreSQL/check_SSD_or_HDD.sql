Check disk type (HDD or SSD)

Method 1: Check if the disk is rotational

You should check the value of /sys/block/sdX/queue/rotational, where sdX is the drive name. If the value is , youre dealing with an SSD, and 1 means plain old HDD.

These are the available disks on my Linux server:
[postgres@lsdbzab01 ~]$ lsscsi
[0:0:0:0]    disk    VMware   Virtual disk     2.0   /dev/sda 
[0:0:1:0]    disk    VMware   Virtual disk     2.0   /dev/sdb 
[0:0:2:0]    disk    VMware   Virtual disk     2.0   /dev/sdc 
[0:0:3:0]    disk    VMware   Virtual disk     2.0   /dev/sdd 
[0:0:4:0]    disk    VMware   Virtual disk     2.0   /dev/sde 
[0:0:5:0]    disk    VMware   Virtual disk     2.0   /dev/sdf 
[0:0:6:0]    disk    VMware   Virtual disk     2.0   /dev/sdg 
[3:0:0:0]    cd/dvd  NECVMWar VMware SATA CD00 1.00  /dev/sr0 

cat /sys/block/sda/queue/rotational
1

[postgres@lsdbzab01 ~]$ cat /sys/block/sdb/queue/rotational
1
[postgres@lsdbzab01 ~]$ cat /sys/block/sdc/queue/rotational
1
[postgres@lsdbzab01 ~]$ cat /sys/block/sdd/queue/rotational
1
[postgres@lsdbzab01 ~]$ cat /sys/block/sde/queue/rotational
1
[postgres@lsdbzab01 ~]$ cat /sys/block/sdf/queue/rotational
1
[postgres@lsdbzab01 ~]$ cat /sys/block/sdg/queue/rotational
1
[postgres@lsdbzab01 ~]$ cat /sys/block/sr0/queue/rotational
1


Method 2: Using lsblk

Here also we will use the concept of identifying the disks with rotational feature to check the disk type. Although here we are using lsblk to list all the available connected disk types and their respective rotational values:

[postgres@lsdbzab01 ~]$ lsblk -d -o name,rota
NAME ROTA
fd0     1
sda     1
sdb     1
sdc     1
sdd     1
sde     1
sdf     1
sdg     1
sr0     1

So all the identified disks have rotational value as 1 so this means they all are part of HDD.
