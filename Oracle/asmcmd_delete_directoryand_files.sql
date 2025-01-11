
In asmcmd, we can not delete a directory unless it’s empty. We can only delete the files under the directory to remove, when deleting all files within the directory using “rm”, the directory is removed automatically.

I’m trying to remove a database which has been crashed during creation from ASM diskgroup ‘DATA’

ASMCMD [+data] > rm ACFS11G2/
ORA-15032: not all alterations performed
ORA-15177: cannot operate on system aliases (DBD ERROR: OCIStmtExecute)

ASMCMD [+data] > cd ACFS11G2/
ASMCMD [+data/ACFS11G2] > ls
CONTROLFILE/
DATAFILE/
ONLINELOG/
TEMPFILE/
 
ASMCMD [+data/ACFS11G2] > find --type controlfile . *
+data/ACFS11G2/CONTROLFILE/Current.266.752716027
 
ASMCMD [+data/ACFS11G2] > rm +data/ACFS11G2/CONTROLFILE/Current.266.752716027
 
ASMCMD [+data/ACFS11G2] > ls
DATAFILE/
ONLINELOG/
TEMPFILE/
