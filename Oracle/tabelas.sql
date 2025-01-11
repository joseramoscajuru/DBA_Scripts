-- TAMANHO DAS TABELAS

COLUMN TABLE_NAME FORMAT A32
COLUMN OBJECT_NAME FORMAT A32
COLUMN OWNER FORMAT A10
 

SELECT
   owner, table_name, round(sum(bytes)/1024/1024/1024,2) GB
FROM
(SELECT segment_name table_name, owner, bytes
 FROM dba_segments
 WHERE segment_type = 'TABLE'
 UNION ALL
 SELECT i.table_name, i.owner, s.bytes
 FROM dba_indexes i, dba_segments s
 WHERE s.segment_name = i.index_name
 AND   s.owner = i.owner
 AND   s.segment_type = 'INDEX'
 UNION ALL
 SELECT l.table_name, l.owner, s.bytes
 FROM dba_lobs l, dba_segments s
 WHERE s.segment_name = l.segment_name
 AND   s.owner = l.owner
 AND   s.segment_type = 'LOBSEGMENT'
 UNION ALL
 SELECT l.table_name, l.owner, s.bytes
 FROM dba_lobs l, dba_segments s
 WHERE s.segment_name = l.index_name
 AND   s.owner = l.owner
 AND   s.segment_type = 'LOBINDEX')
WHERE owner = 'SAPSR3'
and table_name in
('ADR2'
,'ADR6'
,'ADRC'
,'BUT000'
,'BUT020'
,'BUT100'
,'CRMD_ACTIVITY_H'
,'CRMD_BILLING'
,'CRMD_LINK'
,'CRMD_ORDERADM_H'
,'CRMD_ORDERADM_I'
,'CRMD_ORDER_INDEX'
,'CRMD_PARTNER'
,'CRMM_BUAG'
,'DFKKBPTAXNUM'
,'SCAPPT'
,'CRM_JEST')
GROUP BY table_name, owner
ORDER BY SUM(bytes) desc
;

