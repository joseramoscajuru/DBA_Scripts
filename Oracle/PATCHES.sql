ATE ORACLE 11G


SET LINESIZE 1000 PAGES 200

COLUMN action_time FORMAT A30
COLUMN action FORMAT A15
COLUMN namespace FORMAT A10
COLUMN version FORMAT A10
COLUMN comments FORMAT A52
COLUMN bundle_series FORMAT A10

SELECT action_time,
       action,
       namespace,
       version,
       id,
       comments,
       bundle_series
FROM   sys.registry$history
ORDER by action_time;




ORACLE 12C

    set lines 1000 pages 200
    col action_time format a30
    col description format a55
    col status format a30
    select ACTION_TIME, DESCRIPTION, status
    from dba_registry_sqlpatch
    /

LOCAL ONDE ESTAO OS PATCHES

zhoem01p(oracle): pwd
/utility/oracle/Patches


