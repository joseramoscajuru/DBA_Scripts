
How to Check Latest patch applied to the Database

1. Listing Applied Patches

To print a summary of installed patches, you can can use opatch lspatches command.

[oracle@den03adm03 admin]$ $ORACLE_HOME/OPatch/opatch lspatches

2. Using opatch lsinventory

[oracle@orahowdb ~]$  $ORACLE_HOME/OPatch/opatch lsinventory|grep "Patch description"

3. Get detailed info Using opatch lsinventory

[oracle@orahowdb ~]$ $ORACLE_HOME/OPatch/opatch lsinventory

3: Detailed information on the applied patch.

[oracle@orahowdb ~]$ $ORACLE_HOME/OPatch/opatch lsinventory -details

4: As a sysdba you can also execute below command from the sql prompt to get the patch detail.

set serverout on;
exec dbms_qopatch.get_sqlpatch_status;

5: To get information on particular patch ID.

SQL> select xmltransform(dbms_qopatch.is_patch_installed('29494060'),dbms_qopatch.get_opatch_xslt) "Patch installed?" from dual;

6: Patch detail from registry

SQL>  select * from sys.registry$history;
 SQL> select * from sys.dba_registry_sqlpatch;