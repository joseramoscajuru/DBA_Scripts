
To check the asm disks and their status:


select HEADER_STATUS, NAME, PATH, mount_status, state, header_status from v$asm_disk;

HEADER_STATU NAME			    PATH			   MOUNT_S STATE    HEADER_STATU
------------ ------------------------------ ------------------------------ ------- -------- ------------
MEMBER	     DG_ARC_IAMPRD_0000 	    /dev/sde1			   CACHED  NORMAL   MEMBER
MEMBER	     DG_ARC_IAMPRD_0001 	    /dev/sdf1			   CACHED  NORMAL   MEMBER
MEMBER	     DG_DATA_IAMPRD_0000	    /dev/sdc1			   CACHED  NORMAL   MEMBER
MEMBER	     DG_DATA_IAMPRD_0001	    /dev/sdd1			   CACHED  NORMAL   MEMBER

