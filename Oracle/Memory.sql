h1ibmdbecc01:oracle 10> lsconf | grep Memory

Memory Size: 192512 MB
Good Memory Size: 192512 MB
+ mem0                                                                             Memory

h1ibmdbecc01:oracle 10> lsconf | grep Memory

Memory Size: 192512 MB
Good Memory Size: 192512 MB
+ mem0                                                                             Memory
h1ibmdbecc01:oracle 11>         lparstat -i | grep Memory
Online Memory                              : 192512 MB
Maximum Memory                             : 192512 MB
Minimum Memory                             : 96256 MB
Memory Mode                                : Dedicated
Total I/O Memory Entitlement               : -
Variable Memory Capacity Weight            : -
Memory Pool ID                             : -
Physical Memory in the Pool                : -
Unallocated Variable Memory Capacity Weight: -
Unallocated I/O Memory entitlement         : -
Memory Group ID of LPAR                    : -
Desired Memory                             : 192512 MB
Target Memory Expansion Factor             : -
Target Memory Expansion Size               : -

h1ibmdbecc01:oracle 12>         lsattr -El sys0 -a realmem

realmem 197132288 Amount of usable physical memory in Kbytes False

h1ibmdbecc01:oracle 13> h1ibmdbecc01:oracle 13> getconf REAL_MEMORY
197132288

