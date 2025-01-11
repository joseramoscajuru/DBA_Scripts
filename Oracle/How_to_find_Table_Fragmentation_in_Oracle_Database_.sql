How to find Table Fragmentation in Oracle Database

What is Oracle Table Fragmentation?
If a table is only subject to inserts, there will not be any fragmentation.
Fragmentation comes with when we update/delete data in table.
The space which gets freed up during non-insert DML operations is not immediately re-used (or sometimes, may not get reuse ever at all). This leaves behind holes in table which results in table fragmentation.

To understand it more clearly, we need to be clear on how oracle manages space for tables.

When rows are not stored contiguously, or if rows are split onto more than one block, performance decreases because these rows require additional block accesses.

Note that table fragmentation is different from file fragmentation. When a lot of DML operations are applied on a table, the table will become fragmented because DML does not release free space from the table below the HWM.

HWM is an indicator of USED BLOCKS in the database. Blocks below the high water mark (used blocks) have at least once contained data. 
This data might have been deleted. Since Oracle knows that blocks beyond the high water mark dont have data, it only reads blocks up to the high water mark when doing a full tablescan.

DDL statement always resets the HWM.

What are the reasons to reorganization of table?

a) Slower response time (from that table)
b) High number of chained (actually migrated) rows.
c) Table has grown many folds and the old space is not getting reused.

Note: Index based queries may not get that much benefited by reorg as compared to queries which does Full table scan.

How to find Table Fragmentation?

In Oracle schema there are tables which has huge difference in actual size (size from User_segments) and expected size from user_tables (Num_rows*avg_row_length (in bytes)). This all is due to fragmentation in the table or stats for table are not updated into dba_tables.

Steps to Check and Remove Table Fragmentation:-
=============================================
1. Gather table stats:
---------------------
To check exact difference in table actual size (dba_segments) and stats size (dba_tables). The difference between these value will report actual fragmentation to DBA. So, We have to have updated stats on the table stored in dba_tables. Check LAST_ANALYZED value for table in dba_tables. If this value is recent you can skip this step. Other wise i would suggest to gather table stats to get updated stats.

exec dbms_stats.gather_table_stats('&schema_name','&table_name');

2. Check Table size:
-------------------
Now again check table size using and will find reduced size of the table.

select table_name,bytes/(1024*1024*1024) from dba_table where table_name='&table_name';

3. Check for Fragmentation in table:
-----------------------------------
Below query will show the total size of table with fragmentation, expected without fragmentation and how much % of size we can reclaim after removing table fragmentation. Database Administrator has to provide table_name and schema_name as input to this query.

set pages 50000 lines 32767
select owner,table_name,round((blocks*8),2)||'kb' "Fragmented size", round((num_rows*avg_row_len/1024),2)||'kb' "Actual size", round((blocks*8),2)-round((num_rows*avg_row_len/1024),2)||'kb',
((round((blocks*8),2)-round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 -10 "reclaimable space % " from dba_tables where table_name ='&table_Name' AND OWNER LIKE '&schema_name'
/
Note: This query fetch data from dba_tables, so the accuracy of result depends on dba_table stats.

If you find reclaimable space % value more than 20% then we can expect fragmentation in the table. Suppose, DBA find 50% reclaimable space by above query, So he can proceed for removing fragmentation.

4. How to reset HWM / remove fragemenation?
---------------------------------------
We have four options to reorganize fragmented tables:

1. Alter table move (to another tablespace, or same tablespace) and rebuild indexes:-
   (Depends upon the free space available in the tablespace)
2. Export and import the table:- (difficult to implement in production environment)
3. Shrink command (fron Oracle 10g)
   (Shrink command is only applicable for tables which are tablespace with auto segment space management)

Here, I am following Options 1 and 3 option by keeping table availability in mind.


Option: 1 Alter table move (to another tablespace, or same tablespace) and rebuild indexes:-
------------------------------------------------------------------------------------------
Collect status of all the indexes on the table:-
----------------------------------------------
We will record Index status at one place, So that we get back them after completion of this exercise, 

select index_name,status from dba_indexes where table_name like '&table_name';

Move table in to same or new tablespace:
---------------------------------------
In this step we will move fragmented table to same tablespace or from one tablespace to another tablespace to reclaim fragmented space. Find Current size of you table from dba_segments and check if same or any other tablespace has same free space available. So, that we can move this table to same or new tablespace.

Steps to Move table in to same tablespace:
-----------------------------------------
alter table <table_name> move;   ------> Move to same tablespace

OR

Steps to Move table in to new tablespace:
----------------------------------------
alter table <table_name> enable row movement;
alter table <table_name> move tablespace <new_tablespace_name>;

Now, get back table to old tablespaces using below command

alter table table_name move tablespace old_tablespace_name;

Now,Rebuild all indexes:
-----------------------
We need to rebuild all the indexes on the table because of move command all the index goes into unusable state.

SQL> select status,index_name from dba_indexes where table_name = '&table_name';

STATUS INDEX_NAME
-------- ------------------------------
UNUSABLE INDEX_NAME                            -------> Here, value in status field may be valid or unusable.

SQL> alter index <INDEX_NAME> rebuild online;  -------> Use this command for each index
Index altered.

SQL> select status,index_name from dba_indexes where table_name = '&table_name';

STATUS INDEX_NAME
-------- ------------------------------
VALID INDEX_NAME                               -------> Here, value in status field must be valid.

Gather table stats:
------------------
SQL> exec dbms_stats.gather_table_stats('&owner_name','&table_name');
PL/SQL procedure successfully completed.

Check Table size:
-----------------
Now again check table size using and will find reduced size of the table.

select table_name,bytes/(1024*1024*1024) from dba_table where table_name='&table_name';

Check for Fragmentation in table:
--------------------------------
set pages 50000 lines 32767
select owner,table_name,round((blocks*8),2)||'kb' "Fragmented size", round((num_rows*avg_row_len/1024),2)||'kb' "Actual size", round((blocks*8),2)-round((num_rows*avg_row_len/1024),2)||'kb',
((round((blocks*8),2)-round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 -10 "reclaimable space % " from dba_tables where table_name ='&table_Name' AND OWNER LIKE '&schema_name'
 /
==================================================================================================================
Option: 3 Shrink command (fron Oracle 10g):-
------------------------------------------

Shrink command:
--------------
Its a new 10g feature to shrink (reorg) the tables (almost) online which can be used with automatic segment space management.

This command is only applicable for tables which are tablespace with auto segment space management.

Before using this command, you should have row movement enabled.

SQL> alter table <table_name> enable row movement;
Table altered.

There are 2 ways of using this command.

1. Rearrange rows and reset the HWM:
-----------------------------------
Part 1: Rearrange (All DMLs can happen during this time)
SQL> alter table <table_name> shrink space compact;
Table altered.

Part 2: Reset HWM (No DML can happen. but this is fairly quick, infact goes unnoticed.)
SQL> alter table <table_name> shrink space;
Table altered.

2. Directly reset the HWM:
-------------------------
SQL> alter table <table_name> shrink space; (Both rearrange and restting HWM happens in one statement)
Table altered.

Advantages over the conventional methods are:
--------------------------------------------
1. Unlike "alter table move ..",indexes are not in UNUSABLE state.After shrink command,indexes are updated also.
2. Its an online operation, So you dont need downtime to do this reorg.
3. It doesnot require any extra space for the process to complete.

Posted by Dharmendra Chalasani at Tuesday, September 10, 2013 