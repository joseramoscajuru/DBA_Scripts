
-- Check 1: Checkpoint Time and Fuzziness

-- Objective: Verify that the datafiles are recovered to the intended point in time (PIT) and they are consistent (FUZZY=NO)

-- Query the current status and PIT (Point In Time up to which the datafiles have been recovered) of datafiles by reading datafile headers directly from the physical datafiles:

set lines 1000 pages 200
col checkpoint_change# format 999999999999999
select fuzzy, status, error, recover, checkpoint_change#, checkpoint_time, count(*) 
from v$datafile_header 
group by fuzzy, status, error, recover, checkpoint_change#, checkpoint_time ;

set lines 1000 pages 200
col checkpoint_change# format 999999999999999
select fuzzy, status, error, recover, checkpoint_change#, checkpoint_time
from v$datafile_header;



-- Check 1 can be considered PASSED when :

a) Verified that all the datafiles are at the some checkpoint_time, and this is your intended Point in time.

b) Fuzzy=NO for SYSTEM, UNDO and all intended datafiles. For datafiles with Fuzzy=YES, either recover them further or bring them OFFLINE if no further archived logs are available.

