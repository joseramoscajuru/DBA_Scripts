
LIMPEZA AUTOMATICA TRACES - lsp1db01

SERVER:

lsp1db01

# Mantém os últimos 30 dias de backup:
00 05 * * * find /backup -depth -type d -mtime 30 -exec rm -fr {} \;


00 04 * * * find /u01/app/oracle/diag/rdbms/dbsapdev/DBSAPDEV/trace -maxdepth 1 -daystart -type f -mtime +2 -exec rm {} \;
00 05 * * * find /u01/app/oracle/diag/rdbms/dbsapdev/DBSAPDEV/alert -maxdepth 1 -daystart -type f -mtime +2 -exec rm {} \;


O comando abaixo MOSTRA os arquivos mais ANTIGOS, ordenados por DATA, somente do "DIRETORIO"
find . -maxdepth 1 -daystart -type f -mtime +3 -exec stat -c %Y' '%y' '%n {} \;|sort -t" " -k1 -nr 