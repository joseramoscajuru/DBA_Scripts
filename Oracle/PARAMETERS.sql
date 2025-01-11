#CHECAR  SE PARAMETRO  ESTTICO OU DINNICO
#QUERY EM V$PARAMETER, checar o CAMPO:

ISSYS_MODIFIABLE  VARCHAR2(9)  Indicates whether the parameter can be changed with ALTER SYSTEM and when the change takes effect: Indica se o parmetro pode ser alterado com ALTER SYSTEM e quando a alterao tenha efeito: 

IMMEDIATE - Parameter can be changed with ALTER SYSTEM regardless of the type of parameter file used to start the instance. IMMEDIATE - parmetro pode ser alterado com ALTER SYSTEM independentemente do tipo de arquivo de parmetro usado para iniciar a instncia. The change takes effect immediately. A mudana tem efeito imediato. 

DEFERRED - Parameter can be changed with ALTER SYSTEM regardless of the type of parameter file used to start the instance. DEFERRED - O parmetro pode ser alterado com ALTER SYSTEM independentemente do tipo de arquivo de parmetro usado para iniciar a instncia. The change takes effect in subsequent sessions. A alterao ter efeito nas sesses subseqentes. 

FALSE - Parameter cannot be changed with ALTER SYSTEM unless a server parameter file was used to start the instance. FALSE - O parmetro no pode ser alterada com ALTER SYSTEM menos um arquivo de parmetro do servidor foi usado para iniciar a instncia. The change takes effect in subsequent instances. A alterao ter efeito em casos posteriores.

Segue o retorno da Oracle (Metalink) pra essa checagem:

---------------------------------------------------------------------------------------
To find the hidden parameter from the sqlplus use the following query :-

++ To find the hidden parameters and their values,        ++
++ you can query the following views from SYSDBA login :  ++

select a.ksppinm, b.ksppstvl, b.ksppstdf, a.ksppdesc
from x$ksppi a, x$ksppcv b
where a.indx = b.indx
and ksppinm='_disable_function_based_index'
order by ksppinm;

KSPPINM :- This column indicates the parameter name.
KSPPSRVL :- This column indicates the current value of the parameter.
KSPPSTDF :- This column indicates the default value of the parameter.
KSPPDESC :- This column gives the description of the parameter. 

++ To find the parameter whether it is static or not you can query the following view:

select ISSES_MODIFIABLE,ISSYS_MODIFIABLE,ISINSTANCE_MODIFIABLE 
from   V$PARAMETER where NAME='<parameter_name>';

Unless any hidden parameter is modified at the session or system level the entries 
will not be seen in the above view i.e v$parameter.
---------------------------------------------------------------------------------------

