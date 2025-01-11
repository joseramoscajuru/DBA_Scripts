Colega, é simples : se vc quer ter 100% de garantia contra acessos não registrados, vc TEM que implementar algum tipo de Auditoria, preferencialmente com o comando AUDIT, OU vc faz um tarce de SQL das sessões em execução, ponto - não há outras alternativas que te garantam 100% de registro com Zero de acessos perdidos....
Caso seja aceitável um eventual risco, vc pode consultar as tabelas & views internas do database : Antes de usar a opção de acessar as tabelas/views internas, fique ciente que :

a) elas são atualizadas a cada 3 segundos (mais ou menos, depende da versão) então é INERENTE a chance de vc não ver algum acesso que demore menos que isso

b) algumas delas refletem caches do RDBMS (como por exemplo a V$SQL, que reflete o cache de SQLs executados ou em execução) - como qquer cache, NÂO há garantia nenhuma de quanto tempo normalmente um dado fica lá

Isto posto, vc poderá usar para a monitoração as views/tabelas relacionadas com SQL (já que TODO e Qualquer acesso se dá via SQL), ou pode usar a V$ACCESS, que registra os objetos sendo acessado no momento (com TODAS as obs acima se mantendo, Óbvio)... Um exemplo de query com a V$ACCESS :

col SID for 999
col owner for A10 trunc
col type for A6 trunc
col object for A24 trunc
col command for 999
col username for A14
set linesize 90

select S.SID
,S.username
,S.OSuser
,A.owner
,A.object
,A.TYPE
,S.command
from v$ACCESS A
,v$SESSION S
,AUDIT_ACTIONS C
where S.username is not null
and S.SID = A.SID
and A.owner not in ('SYS','SYSTEM')
and A.TYPE = 'TABLE'
and C.action = S.command
and A.object like upper('&Object_name%')
/