
If you happen to hit this issue again please use ADRCI utility to delete some trace files and free up space. You can use the following syntax:

$ adrci

ADRCI: Release 11.2.0.1.0 - Production on Fri Jan 4 07:54:22 2013

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/usr/app/oracle/admin/POOFP2P"
adrci> show homes
ADR Homes: 
diag/rdbms/poofp2p/POOFP2P1
adrci> set home diag/rdbms/poofp2p/POOFP2P1
adrci> purge -age 1 -type trace
adrci> exit

This will delete trace files older than 1 minute from diag dest.