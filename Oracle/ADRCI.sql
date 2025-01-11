
Agora vamos setar o HOMEPATH antes de começar os comandos, segue:

adrci> show homes

ADR Homes:
diag/clients/user_unknown/host_411310321_11
diag/clients/user_oracle/host_2980793051_80
diag/clients/user_oracle/host_2980793051_11
diag/rdbms/test/test
diag/rdbms/test2/test2

adrci> set homepath diag/rdbms/test2/test2

Vendo o alert log pelo ADRCI

Mostra as ultimas 10 linhas
SHOW ALERT -TAIL

Mostra as ultimas 50 linhas
SHOW ALERT -TAIL 50

Mostra o alert e suas novas atualização
SHOW ALERT -TAIL –F

SHOW ALERT -P "MESSAGE_TEXT LIKE '%ORA-600%'"

Vendo os arquivos de trace

Lista os traces
adrci>SHOW TRACEFILE

Mostra os traces que contenha mmon
adrci>SHOW TRACEFILE %mmon%

Mostra todos os traces do ultimo que foi modificado

adrci>SHOW TRACEFILE -RT

Vendo os incidents gerados

Mostra os incidents
adrci>SHOW INCIDENT
adrci>SHOW INCIDENT -MODE BRIEF
adrci>SHOW INCIDENT -MODE DETAIL

Este comando mostra mais detalhadamente um incidente
adrci>SHOW INCIDENT -MODE DETAIL -P “INCIDENT_ID=1591”