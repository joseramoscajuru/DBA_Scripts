set lines 120
col AGENT_STATUS format a15
col AGENT_NAME format a15
select AGENT_STATUS,AGENT_PING,AGENT_NAME  from mgw_gateway;

7:20:49 AM: Aline De Souza Santiago: STAR International Rewards has implemented Oracle Messaging Gateway (OMG) feature and we will be responsible for taking action when OMG agents are unreachable. Tivoli monitoring is in place to raise a Severity 2 ticket to our team and this will be created with the following keywords: "SUN_STAR_MGW_ISSUE". 

See for example IMR#16987485 - SPPMD563:JIT_AGENT:SUN_STAR_MGW_ISSUE.

Only the following databases are setup with this facility:

IRCAPROD	- SPPMD562 (IRCAPROD1) / SPPMD563 (IRCAPROD2)
IRC2PROD	- SPPMD562 (IRC2PROD1) / SPPMD563 (IRC2PROD2)
IRJPPROD	- SPPMD558 (IRJPPROD1) / SPPMD559 (IRJPPROD2)
IRGBPROD	- SPPMD560 (IRGBPROD1) / SPPMD561 (IRGBPROD2)
IRDEPROD	- SPPMD560 (IRDEPROD1) / SPPMD561 (IRDEPROD2)

Basically this is what needs to be done when you get one of these tickets:

Agents can be started and stopped with the following commands from a SQL*Plus prompt as SYS:

SQL> EXEC DBMS_MGWADM.STARTUP('DEFAULT_AGENT');
SQL> EXEC DBMS_MGWADM.SHUTDOWN(' JIT_AGENT');

Agent status can be verified with the following query:

set lines 120
col AGENT_STATUS format a15
col AGENT_NAME format a15
select AGENT_STATUS,AGENT_PING,AGENT_NAME  from mgw_gateway;

AGENT_STATUS    AGENT_PING                        AGENT_NAME
--------------- --------------------------------- ---------------
RUNNING         REACHABLE                         DEFAULT_AGENT
BROKEN          UNREACHABLE                       JIT_AGENT
RUNNING         REACHABLE                         BATCH_AGENT

The agents JIT_AGENT and BATCH_AGENT should be always in running status and the agent_ping should be reachable in order for the messaging to perform smoothly. The default agent can be avoided.

You can use DBMS_MGWADM.STARTUP('<agent_name>') to bring up any agent if needed.

Notice, that this will not work if the agent is in BROKEN status (as JIT_AGENT above). This requires a different method that is called agent cleanup, see below a complete example:

SQL> set lines 120
SQL> col AGENT_STATUS format a15
SQL> col AGENT_NAME format a15
SQL> select AGENT_STATUS,AGENT_PING,AGENT_NAME  from mgw_gateway;

AGENT_STATUS    AGENT_PING                        AGENT_NAME
--------------- --------------------------------- ---------------
RUNNING         REACHABLE                         DEFAULT_AGENT
BROKEN          UNREACHABLE                       JIT_AGENT
RUNNING         REACHABLE                         BATCH_AGENT

SQL> exec dbms_mgwadm.cleanup_gateway(AGENT_NAME => 'JIT_AGENT',action =>DBMS_MGWADM.CLEAN_STARTUP_STATE);

PL/SQL procedure successfully completed.

SQL> EXEC DBMS_MGWADM.STARTUP('JIT_AGENT');

PL/SQL procedure successfully completed.

SQL> select AGENT_STATUS,AGENT_PING,AGENT_NAME  from mgw_gateway;

AGENT_STATUS    AGENT_PING                        AGENT_NAME
--------------- --------------------------------- ---------------
RUNNING         REACHABLE                         DEFAULT_AGENT
STARTING        UNREACHABLE                       JIT_AGENT
RUNNING         REACHABLE                         BATCH_AGENT

SQL> /    -- waited a few minutes for the agent to come up and ran the query again

AGENT_STATUS    AGENT_PING                        AGENT_NAME
--------------- --------------------------------- ---------------
RUNNING         REACHABLE                         DEFAULT_AGENT
RUNNING         REACHABLE                         JIT_AGENT
RUNNING         REACHABLE                         BATCH_AGENT

