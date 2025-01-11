Rollback records needed by a reader for consistent read are overwritten by other writers.

The Undo is an automatic tool from ORACLE. There is no intervation from DBA.

SELECT STATUS,SUM(BYTES/1024/1024)
	FROM DBA_UNDO_EXTENTS
	GROUP BY STATUS;

