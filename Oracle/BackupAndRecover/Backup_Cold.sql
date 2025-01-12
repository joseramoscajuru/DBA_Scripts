#Identificar o que precisa copiar para fazer backup cold
select name from v$controlfile
 union all
 select name from v$tempfile
 union all
 select name from v$dbfile
 union all
 select member from v$logfile;

