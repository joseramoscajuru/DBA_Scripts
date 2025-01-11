According to metalink note - 438148.1, beginning with Release 11g, the alert log file is written as XML formatted and as a text file (like in previous releases). The default location of both these files is the new ADR home (Automatic Diagnostic Respository, yet another new dump dest in 11g).

The ADR is set by using the DIAGNOSTIC_DEST initialization parameter. If this parameter is omitted, then, the default location of ADR is, 'u01/oracle/product/ora11g/log' (depends on ORACLE_HOME settings).

The location of an ADR home is given by the following path, which starts at the ADR base directory: ADR_BASE/diag/product_type/product_id/instance_id

If environment variable ORACLE_BASE is not set, DIAGNOSTIC_DEST is set to ORACLE_HOME/log.

Within the ADR home directory are subdirectories:
alert - The XML formatted alertlog
trace - files and text alert.log file
cdump - core files

The XML formatted alert.log is named as 'log.xml'

By default its --> $diagnostic_dest/diag/rdbms/<db_unique_name>/<instance_name>/trace

SQL> desc v$diag_info;


Name                         Null? Type
----------------------------------------- -------- ----------------------------
INST_ID                         NUMBER
NAME                            VARCHAR2(64)
VALUE                           VARCHAR2(512)

select * from v$diag_info;

