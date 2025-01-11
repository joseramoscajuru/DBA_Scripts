

To check table statistics use:

select owner,
table_name,
num_rows,
sample_size,
last_analyzed,
tablespace_name
from dba_tables where owner='&SCHEMANAME' and
-- table_name='&table_name'
table_name in upper(evento_trans evt, item_registrado ireg, produto_trans ptrans, trans_canc_anula_dev_troca troca, transacao_p2k
order by owner;


To check for index statistics use:

select index_name,
table_name,
num_rows,
sample_size,
distinct_keys,
last_analyzed,
status
from dba_indexes 
where table_owner='&SCHEMANAME' and
table_name = '&table_name'
order by table_name, index_name;

