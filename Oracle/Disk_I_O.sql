Disk I/O, Events, Waits
Here are some scripts related to Disk I/O, Events, Waits .

Datafile I/O
DATAFILE I/O NOTES:


File Name - Datafile name 
Physical Reads - Number of physical reads 
Reads % - Percentage of physical reads 
Physical Writes - Number of physical writes 
Writes % - Percentage of physical writes 
Total Block I/Os - Number of I/O blocks 

Use this report to identify any "hot spots" or I/O contention 

select 	NAME,
	PHYRDS "Physical Reads",
	round((PHYRDS / PD.PHYS_READS)*100,2) "Read %",
	PHYWRTS "Physical Writes",
	round(PHYWRTS * 100 / PD.PHYS_WRTS,2) "Write %",
	fs.PHYBLKRD+FS.PHYBLKWRT "Total Block I/Os"
from (
	select 	sum(PHYRDS) PHYS_READS,
		sum(PHYWRTS) PHYS_WRTS
	from  	v$filestat
	) pd,
	v$datafile df,
	v$filestat fs
where 	df.FILE# = fs.FILE#
order 	by fs.PHYBLKRD+fs.PHYBLKWRT desc

SGA Stats
SGA STAT NOTES:


Statistic Name - Name of the statistic 
Bytes - Size 

select 	NAME,
	BYTES
from 	v$sgastat
order	by NAME

Sort Stats
SORT NOTES:


Sort Parameter - Name of the sort parameter 
Value - Number of sorts 

sorts (memory) - The number of sorts small enough to be performed entirely in sort areas without using temporary segments. 
sorts (disk) - The number of sorts that were large enough to require the use of temporary segments for sorting. 
sorts (rows) - Number of sorted rows 

The memory area available for sorting is set via the SORT_AREA_SIZE and SORT_AREA_RETAINED_SIZE init.ora parameters. 

select 	NAME,
	VALUE
from 	v$sysstat
where  	NAME like 'sort%'

All Events
SYSTEM EVENT (ALL) NOTES:


Event Name - Name of the event 
Total Waits - Total number of waits for the event 
Total Timeouts - Total number of timeouts for the event 
Time Waited - The total amount of time waited for this event, in hundredths of a second 
Average Wait - The average amount of time waited for this event, in hundredths of a second 

select 	EVENT,
	TOTAL_WAITS,
	TOTAL_TIMEOUTS,
	TIME_WAITED,
	round(AVERAGE_WAIT,2) "Average Wait"
from 	v$system_event
order	by TOTAL_WAITS

All Statistics
SYSTEM STATISTICS (ALL) NOTES:


Stat# - Number of the statistic 
Name - Name of the statistic 
Class - Statistic class: 1 (User), 2 (Redo), 4 (Enqueue), 8 (Cache), 16 (OS), 32 (Parallel Server), 64 (SQL), 128 (Debug) 
Value - Value of the statistic 

select 	STATISTIC#,
	NAME,
	CLASS,
	VALUE
from 	v$sysstat

Wait Stats
WAIT STATISTIC NOTES:


Class - Class of block subject to contention 
Count - Number of waits by this OPERATION for this CLASS of block 
Time -Sum of all wait times for all the waits by this OPERATION for this CLASS of block 

Data Blocks - Usually occurs when there are too many modified blocks in the buffer cache; reduce contention by adding DBWR processes. 
Free List - May occur if multiple data loading programs run simultaneously. 
Segment Header - May occur when may full table scans execute simultaneously with data loading processes; aggravated by the parallel options. Reschedule data loading jobs to reduce contention; 
Sort Block - Rarely seen except when the Parallel Query option is used; reduce contention by reducing the degree of parallelism or decreasing the SORT_AREA_SIZE init.ora parameter setting. 
Undo Block - Very rarely occurs; may be caused by multiple users updating records in the same data block at a very fast rate; contention can usually be resolved by increasing the PCTFREE of the tables being modified. 
Undo Header - May occur if there are not enough rollback segments to support the number of concurrent transactions. 

select 	CLASS,
	COUNT,
	TIME
from  	v$waitstat
order	by CLASS

