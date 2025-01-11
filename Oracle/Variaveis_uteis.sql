ORACLE_BASE - Specifies the base of the Oracle directory structure for Optimal Flexible Architecture (OFA) compliant database software installations.

Example:

ORACLE_BASE=/u01/app/oracle


##################################################
##################################################
##################################################


ORACLE_HOME - Specifies the directory containing the Oracle Database software. ORACLE_HOME is typically found beneath ORACLE_BASE in the directory tree. This variable is used to find executable programs and message files.

Example:

ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1

##################################################
##################################################
##################################################

ORACLE_SID - Specifies the Oracle system identifier (SID) for the Oracle instance running on the current node. In an Oracle RAC configuration, each node must have a unique ORACLE_SID. (i.e. racdb1, racdb2,...)

Example:

ORACLE_SID=racdb1

##################################################
##################################################
##################################################

LD_LIBRARY_PATH - Specifies the list of directories that the shared library loader searches to locate shared object libraries at runtime.

Example:

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib

##################################################
##################################################
##################################################

PATH - Used by the shell to locate executable programs; must include the $ORACLE_HOME/bin directory.

Example:

PATH=$PATH:$ORACLE_HOME/bin

##################################################
##################################################
##################################################

TEMP, TMP, and TMPDIR - Specify the default directories for temporary files; if set, tools that create temporary files create them in one of these directories.

Example:

TEMP=/tmp
TMPDIR=/tmp

##################################################
##################################################
##################################################


ORACLE_PATH - Specifies the search path for files used by Oracle applications such as SQL*Plus. If the full path to the file is not specified, or if the file is not in the current directory, the Oracle application uses ORACLE_PATH to locate the file. This variable is used by SQL*Plus, Forms and Menu.

Example:

ORACLE_PATH=.:/u01/app/common/oracle/sql

##################################################
##################################################
##################################################

SQLPATH - Specifies the directory or list of directories that SQL*Plus searches for a login.sql file.

Example:

SQLPATH=.:/u01/app/common/oracle/sql

##################################################
##################################################
##################################################

ORACLE_TERM - Defines a terminal definition. If not set, it defaults to the value of your TERM environment variable. Used by all character mode products.

Example:

ORACLE_TERM=xterm

##################################################
##################################################
##################################################

NLS_DATE_FORMAT - Specifies the directory containing the Oracle Net Services configuration files like listener.ora, tnsnames.ora, and sqlnet.ora.

Example:

TNS_ADMIN=$ORACLE_HOME/network/admin

##################################################
##################################################
##################################################

ORA_NLS11 - Specifies the directory where the language, territory, character set, and linguistic definition files are stored.

Example (11g):

ORA_NLS11=$ORACLE_HOME/nls/data
Example (10g):
ORA_NLS10=$ORACLE_HOME/nls/data
Example (8, 8i and 9i):
ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data
Example (7.3.x):
ORA_NLS32=$ORACLE_HOME/ocommon/nls/admin/data
Example (7.2.x):
ORA_NLS=$ORACLE_HOME/ocommon/nls/admin/data

##################################################
##################################################
##################################################

ORA_TZFILE - Specifies the full path and file name of the time zone file. You must set this environment variable if you want to use the small time zone file ($ORACLE_HOME/oracore/zoneinfo/timezone.dat) for data in the database. Oracle Database 10g uses the large time zone file by default ($ORACLE_HOME/oracore/zoneinfo/timezlrg.dat). This file contains information on more time zones than the small time zone file.

All databases that share information must use the same time zone file. You must stop and restart the database if you change the value of this environment variable.

Example:

ORA_TZFILE=$ORACLE_HOME/oracore/zoneinfo/timezlrg.dat

##################################################
##################################################
##################################################

ORAENV_ASK - Controls whether the oraenv or coraenv script prompts for the value of the ORACLE_SID environment variable. If it is set to NO, the scripts do not prompt for the value of the ORACLE_SID environment variable. If it is set to any other value, or no value, the scripts prompt for a value for the ORACLE_SID environment variable.

Example:

ORAENV_ASK=NO

##################################################
##################################################
##################################################

ORACLE_TRACE - Enables the tracing of shell scripts during an installation. If it is set to T, many Oracle shell scripts (coraenv.sh, for example) use the set -x command, which prints commands and their arguments as they are run. If it is set to any other value, or no value, the scripts do not use the set -x command.

Example:

ORACLE_TRACE=T

##################################################
##################################################
##################################################

TWO_TASK - The TWO_TASK environment variable specifies a SQL*Net connect string for connecting to a remote machine in a client/server configuration. SQL*Net will check the value of TWO_TASK and automatically add it to your connect string.

For example the following are equivalent:

sqlplus scott/tiger@db1 

and

export TWO_TASK=db1; sqlplus scott/tiger

##################################################
##################################################
##################################################

THREADS_FLAG - (Linux) - All the tools in the JDK use green threads as a default. To specify that native threads should be used, set the THREADS_FLAG environment variable to "native". You can revert to the use of green threads by setting THREADS_FLAG to the value "green".

Example:

THREADS_FLAG=native

##################################################
##################################################
##################################################

UMASK - Set the default file mode creation mask (umask) to 022 to ensure that the user performing the Oracle software installation creates files with 644 permissions.

Example:

umask 022

##################################################
##################################################
##################################################

CLASSPATH - Specifies the directory or list of directories that contain compiled Java classes.

For example the following are equivalent:

CLASSPATH=$ORACLE_HOME/JRE
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/rdbms/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/network/jlib

