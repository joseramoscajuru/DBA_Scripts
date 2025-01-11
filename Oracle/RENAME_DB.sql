1. Na base atual, no prompt do sqlplus e digite "alter database backup controlfile to trace". 

2. Apos va no udump e verifique o ultimo arquivo que foi gerado. Ser um trace, edite-o.
Dentro est como refazer o controlfile. 
Pegue desde o create controlfile ate o ";" depois do caracter set e coloque num bloco de notas.
Substitua o reuse por set, e o noresetlogs por resetlogs e o nome do banco pelo nome do NOVO banco. 

3. Faa uma copia do init do banco antigo, com o novo nome e substitua os parametros db_name, instance_name, db_unique_name, pelo novo nome (Talvez no exista todos os 3).
create pfile='/home/apps/oracle/init.ora' from spfile;

4. Baixe a base, export do ORACLE_SID com o novo nome e de startup nomount , pegue o conteudo do bloco de notas e execute no prompt do sqlplus. 
Depois digite alter database open resetlogs. 

Funciona em banco 7 , 8 , 9 , 10 e 11.

