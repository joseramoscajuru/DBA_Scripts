FUNCIONOU:

find . -maxdepth 1 -daystart -type f -mtime +2 -exec rm {} \;



========

find ./ -name "/usr/app/oracle/diagl/diag/rdbms/*/*/trace/*trc" -mtime +2 -exec rm {} \;

find ./ -name "*.gz" -mtime +18 -print | more;  #Apenas listar os arquivos - teste.

find ./ -name "*.aud" -exec rm {} \;

find ./ -name "*.trc" -mtime +1 -exec rm {} \;


#Zipar arquivos quando a lista  muito longa
find . -name '*.log' | xargs gzip


find ./* -name "*.trc" -mtime +30 -exec rm -Rf {} \;

find ./* -name "*.xml" -mtime +2 -exec rm {} \;
find ./* -name "*.gz" -mtime +1 -print;

find ./* -name "*.gz" -mtime +3 -exec rm {} \;

find ./* -name *.gz -mtime +7 -exec rm {} \;

##LOOPING

While :
do
find /usr/app/oracle/product/11.1.0/dbs/ -type f -name core -user oracle -exec ls -ld {} \;
sleep 60
echo
done 




## monitora o espao FS atual

while :
do
df -k .
sleep 1
clear
done


find ./ -name "*.xml" -mtime +0 -print;
find ./ -name "*.xml" -mtime +0 -exec rm {} \;


find /u01/app/oracle/admin/odbssdv2/bdump -name "odbssdv2*gz" -exec mv /u10/oradata/backups/exports/dump_oracle_backup/odbssdv2/bdump/ {} \;

