$ORACLE_HOME/OPatch/opatch lspatches

SET LINESIZE 400

COLUMN action_time FORMAT A20
COLUMN action FORMAT A10
COLUMN status FORMAT A10
COLUMN description FORMAT A40
COLUMN version FORMAT A10
COLUMN bundle_series FORMAT A10

SELECT TO_CHAR(action_time, 'DD-MON-YYYY HH24:MI:SS') AS action_time,
       action,
       status,
       description,
       version,
       patch_id,
       bundle_series
FROM   sys.dba_registry_sqlpatch
ORDER by action_time;

using package dbms_qopatch

set serverout on
exec dbms_qopatch.get_sqlpatch_status;

