-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/registry_history.sql
-- Author       : Tim Hall
-- Description  : Displays contents of the registry history
-- Requirements : Access to the DBA role.
-- Call Syntax  : @registry_history
-- Last Modified: 23/08/2008
-- -----------------------------------------------------------------------------------
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