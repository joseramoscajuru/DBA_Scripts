
SELECT
  TABLE_NAME,
  NUM_ROWS,
  SAMPLE_SIZE,
  TO_CHAR(LAST_ANALYZED, 'dd.mm.yyyy hh24:mi:ss') LAST_ANALYZED
FROM
  DBA_TABLES
WHERE
  NUM_ROWS > 50000 AND
  SAMPLE_SIZE > 100 AND
  SAMPLE_SIZE < 0.2 
DECODE(NUM_ROWS, 0, 0, DECODE(TRUNC(LOG(10, GREATEST(NUM_ROWS, BLOCKS))), 0, 1, 1, 1, 2, 1, 3, 1, 4, 0.3, 5, 0.1, 6, 0.03, 7, 0.01, 8, 0.003, 9, 0.001, 10, 0.0003, 11, 0.0001, 12, 0.00003, 0.00001))
ORDER BY 4 ASC; 