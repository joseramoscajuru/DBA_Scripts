
spqmd536:/usr/app/dbms/log[qooemdb]$ rman target rmantest/rmantest@qooemdb catalog rmantest/rmantest@qooemdb

Recovery Manager: Release 10.2.0.3.0 - Production on Sun Nov 27 13:32:50 2011

Copyright (c) 1982, 2005, Oracle.  All rights reserved.

connected to target database: QOOEMDB (DBID=1053102827)
connected to recovery catalog database

RMAN> RESYNC CATALOG;

starting full resync of recovery catalog
full resync complete

