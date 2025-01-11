1 - N/A
No changes on the security policy were made related to this activation
19 - Yes
UAT Administration > Pesquisar > Dispositivos -> tirar print e anexar
89 - N/A
All installed versions supported by vendor.
102 - Yes
--- Anexar HC
115 - Yes
 --- Anexar txt com select na dba_registry_history
set line 250 pages 200
col ACTION_TIME for a30
col VERSION for a25
col  COMMENTS for a70
select * from dba_registry_history;
SELECT name, TO_CHAR(created, 'mm/dd/yyyy hh24:mi') CREATE_TIME from v$database ;
set line 250 pages 200
col description for a80
col action_time for a30
select patch_id, VERSION, ACTION, STATUS, ACTION_TIME, description from dba_registry_sqlpatch;
set line 250 pages 200
col ACTION_TIME for a30
col VERSION for a25
col  COMMENTS for a70
select * from dba_registry_history;
SELECT name, TO_CHAR(created, 'mm/dd/yyyy hh24:mi') CREATE_TIME from v$database ;
set line 250 pages 200
col description for a80
col action_time for a30
select patch_id, PATCH_UID, ACTION, STATUS, ACTION_TIME, DESCRIPTION  from dba_registry_sqlpatch;
116 - Yes
Anexar alguma coisa ....
121 - Yes
144 - N/A
There are no shared id's.
195 - Yes
-- Tem que ser feita conciliacao pela UAT e gerar PDF
UAT Administration -> Pesquisar -> Logs de Conformidade -> Solicitar -> Clica no PDF na janela "Inventario de Usuarios" e clica em submeter embaixo, depois vai em "UAT Administration -> Logs de Conformidade -> Fila" e baixa o arquivo gerado em pdf
Anexar doc com lista de users e roles granted
- se nao der tempo rodar o select abaixo
set line 200 pages 200
col USERNAME for a30
col GRANTED_ROLE for a30
select u.username, GRANTED_ROLE
from dba_users u, dba_role_privs r
where u.username=r.grantee
order by u.username, granted_role;
196 - Yes
Tem que ser feita conciliacao pela UAT e gerar PDF
UAT Administration -> Pesquisar -> Logs de Conformidade -> Solicitar -> Clica no PDF na janela "Inventario de Usuarios" e clica em submeter embaixo, depois vai em "UAT Administration -> Logs de Conformidade -> Fila" e baixa o arquivo gerado em pdf
Anexar doc com lista de users e roles granted
- se nao der tempo rodar o select abaixo
select u.username, GRANTED_ROLE
from dba_users u, dba_role_privs r
where u.username=r.grantee
order by u.username, granted_role;
205 - Yes
--Anexar resultado select:
set linesize 150
col DATABASE_STATUS for a20
col instance_name for a20
col START_TIME for a20
col action_time for a30
col comments for a60
col bundle_series for a30
col "VERSION" for a15
col DESCRIPTION format a60
SELECT instance_name, host_name, VERSION "Version", TO_CHAR(startup_time, 'mm/dd/yyyy hh24:mi') START_TIME FROM v$instance order by 1;
SELECT name, TO_CHAR(created, 'mm/dd/yyyy hh24:mi') CREATE_TIME from v$database ;