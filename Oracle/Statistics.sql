#Verificar tabelas com mais de 1 semana de estatsticas desatualizadas

select OWNER
,	LAST_ANALYZED
,	TABLE_NAME
,	USER_STATS
, num_rows,
, avg_row_len
 from DBA_TABLES
where 
-- OWNER  IN ('&owner') 
--LAST_ANALYZED < SYSDATE - 6
table_name = 'PSHPHYSICAL_INV'
order by 2 
/


#EXEMPLO de coleta de estatsticas em uma tabela
'BEGIN DBMS_STATS.GATHER_TABLE_STATS (OWNNAME => '"SAPDAT"', TABNAME => '"AKKB"', ESTIMATE_PERCENT => NULL, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', DEGREE => NULL, CASCADE => TRUE, NO_INVALIDATE => FALSE); END;'

EXECUTE DBMS_STATS.GATHER_TABLE_STATS (OWNNAME => '"SAPDAT"', TABNAME => '"AKKD"', ESTIMATE_PERCENT => NULL, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', DEGREE => NULL, CASCADE => TRUE, NO_INVALIDATE => FALSE);


BEGIN
   DBMS_STATS.GATHER_SCHEMA_STATS
     (OWNNAME           =>'SCOTT',
      ESTIMATE_PERCENT  =>45,
      GRANULARITY       =>'ALL',
      CASCADE           =>TRUE
     );
END;
/   


#EXEMPLO de coleta de estatsticas de uma schema
BEGIN
   DBMS_STATS.GATHER_SCHEMA_STATS
     (OWNNAME           =>'TCMDBUSER',
      GRANULARITY       =>'ALL',
      CASCADE           =>TRUE
     );
END;
/   

