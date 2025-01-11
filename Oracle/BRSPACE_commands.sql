select para checar TABELAS:
===========================

select B.TABLE_NAME,A.SEGMENT_NAME, A.SEGMENT_TYPE, A.TABLESPACE_NAME, B.COMPRESSION, B.LAST_ANALYZED, A.BYTES/1024/1024/1024 "SIZE (GB)"
FROM DBA_SEGMENTS A, DBA_TABLES B
WHERE SEGMENT_NAME IN (
'/SYCLO/AUSP_EX~0',
'COSPD~0',
'ESH_EX_CPOINTER~OT',
'FLQITEMFI~0',
'UKM_EXT_GUID~1')
AND A.SEGMENT_NAME = B.TABLE_NAME
AND A.SEGMENT_TYPE='TABLE'
AND A.OWNER = B.OWNER
/


select para checar INDICES:
===========================

select B.TABLE_NAME,A.SEGMENT_NAME, A.SEGMENT_TYPE, A.TABLESPACE_NAME, B.COMPRESSION, B.LAST_ANALYZED, A.BYTES/1024/1024/1024 "SIZE (GB)"
FROM DBA_SEGMENTS A, DBA_INDEXES B
WHERE SEGMENT_NAME IN (
'/SYCLO/AUSP_EX~0',
'COSPD~0',
'ESH_EX_CPOINTER~OT',
'FLQITEMFI~0',
'UKM_EXT_GUID~1')
AND A.SEGMENT_NAME = B.INDEX_NAME
AND A.SEGMENT_TYPE='INDEX'
AND A.OWNER = B.OWNER
/


comando para reorg de tabelas:
==============================

brspace -u / -c force -f tbreorg -a reorg -o SAPSR3 -t "DMS_CONT1_CD1","TABELA2",TABELA3","TABELA4","TABELA5" -e 5 -p 4

comando para rebuild de indices:
================================

brspace -u / -c force -f idrebuild -i "TRFCQOUT~0","TRFCQOUT~1","TRFCQOUT~2","TRFCQOUT~3","TRFCQOUT~4","TRFCQOUT~5","TRFCQOUT~6" -e 7 -p 4

comando para compressao de indices:
===================================

brspace -u / -c force -f idrebuild -o sapsr3 -m online -i "SRRELROLES~0","STXL~0","COSPD~0","NAST~0","UKM_EXT_GUID~0" -c cind -e 5 -p 3

COLETA DE ESTATISTICAS:
=======================

brconnect -u / -c -f stats -f collect -t FLQITEMFI,ZARIXBC2,/SYCLO/AUSP_EX -e 3 -p 3

Dropar tablespace original
==========================

-	Veririfcar se nao existem objetos na tablespace:

SELECT COUNT(*) FROM DBA_SEGMENTS WHERE TABLESPACE_NAME=’PSAPHDBR3’;

-	Dropar tablespace

/sapmnt/GE3/exe/uc/rs6000_64/brspace -u / -f tsdrop -t PSAPHDBR3NEW


Renomear a nova tablespace para o nome da tablespace original
=============================================================

/sapmnt/GE3/exe/uc/rs6000_64/brspace -c force -u / -f tsalter -a rename -t PSAPHDBR3NEW -n PSAPHDBR3

CLEANUP:

SELECT segment_name, segment_type
from dba_segments
where segment_name like '%#$%';


brspace -f tbreorg -t "*" -a cleanup






