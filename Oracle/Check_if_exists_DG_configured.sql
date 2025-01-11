
SELECT NAME,VERSION,CURRENTLY_USED,FEATURE_INFO
FROM DBA_FEATURE_USAGE_STATISTICS
WHERE NAME = 'Data Guard';

select * from v$archive_dest where status = 'VALID' and target = 'STANDBY';
