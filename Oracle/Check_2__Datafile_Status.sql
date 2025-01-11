
Check 2: Datafile Status

Objective: Verify that the files with status=RECOVER are not OFFLINE unintentionally

select status, enabled, count(*) from v$datafile group by status, enabled ;

Check 2 can be considered Passed when:

All the intended datafiles are not OFFLINE 