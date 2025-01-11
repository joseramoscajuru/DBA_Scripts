
SOLUTION
A1: The hidden parameters start with an "_".They can not be viewed from the output of 'show parameter'
or querying v$parameter unless and until they are set explicitly in init.ora.
However, if you want to view all the hidden parameters and their default values, as well as : if they are session modifiable and system modifiable,  the following query could be of help. Connected as SYSDBA, execute:


SELECT a.ksppinm "Parameter", b.KSPPSTDF "Default Value",
       b.ksppstvl "Session Value", 
       c.ksppstvl "Instance Value",
       decode(bitand(a.ksppiflg/256,1),1,'TRUE','FALSE') IS_SESSION_MODIFIABLE,
       decode(bitand(a.ksppiflg/65536,3),1,'IMMEDIATE',2,'DEFERRED',3,'IMMEDIATE','FALSE') IS_SYSTEM_MODIFIABLE
FROM   x$ksppi a,
       x$ksppcv b,
       x$ksppsv c
WHERE  a.indx = b.indx
AND    a.indx = c.indx
AND    a.ksppinm LIKE '/_%' escape '/'
/

for finding ISPDB_MODIFIABLE :

SELECT a.ksppinm "Parameter",
decode(bitand(ksppiflg/524288,1),1,'TRUE','FALSE') ISPDB_MODIFIABLE
FROM x$ksppi a
WHERE a.ksppinm LIKE '/_clusterwide_global_transactions' escape '/'