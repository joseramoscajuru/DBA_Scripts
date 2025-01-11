https://www.fabioprado.net/2012/06/pesquisando-alertlog-no-adr-do-oracle.html

https://lilianbarroso.wordpress.com/2015/04/10/verificando-o-alert-log-via-sqlplus/

http://olivertconsultoria.blogspot.com/2012/06/o-arquivo-alertlog.html

SELECT           TO_CHAR(ORIGINATING_TIMESTAMP,'yyyy/mm') DATA, 
                               count(1)
      FROM             X$DBGALERTEXT 
      WHERE          MESSAGE_TEXT LIKE '%Deadlock%'
      GROUP BY    TO_CHAR(ORIGINATING_TIMESTAMP,'yyyy/mm')
      ORDER BY    1 DESC;
      

Para retornar apenas erros ORA- ocorridos no último dia:


select to_char (ORIGINATING_TIMESTAMP, 'DD-MM-YYYY HH24:MI') data, 
 message_text
 from x$dbgalertext
 where ORIGINATING_TIMESTAMP > (SYSDATE - 90)
 and message_text like '%ORA-00600%';
 
Para verificar as 100 últimas linhas:

 select to_char (ORIGINATING_TIMESTAMP, 'DD-MM-YYYY HH24:MI') data,
 message_text
 from x$dbgalertext
 where indx > (select count(*)- 50000 from v$alert_log );
 
Para verificar todas as entradas do último dia:

 select to_char (ORIGINATING_TIMESTAMP, 'DD-MM-YYYY HH24:MI') data,
 message_text
 from x$dbgalertext
 where ORIGINATING_TIMESTAMP > (SYSDATE -1);
 
 
adrci> show alert -p "message_text like '%ORA-%'"