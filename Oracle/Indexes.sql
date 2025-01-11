Troubleshoot unusable Index in Oracle
If a procedural object, such as a stored PL/SQL function or a view, becomes invalid, the DBA does not necessarily have to do anything: the first time it is accessed, Oracle will attempt to recompile it, and this may well succeed.

But if an index becomes unusable for any reason, it must always be repaired explicitly before it can be used.

This is because an index consists of the index key values, sorted into order, each with the relevant
rowid. The rowid is the physical pointer to the location of the row to which the index key refers.

If the rowids of the table are changed, then the index will be marked as unusable. This could occur for a number of reasons. Perhaps the most common is that the table has been moved, with the ALTER TABLE...MOVE command. This will change the physical placement of all the rows, and therefore the index entries will be pointing to the wrong place. Oracle will be aware of this and will therefore not permit use of the index.

Identifying Unusable Indexes
---------------------------------
In earlier releases of the Oracle database, when executing SQL statements, if the session attempted to use an unusable index it would immediately return an error, and the statement would fail. Release 10g of the database changes this behavior. If a statement attempts to use an unusable index, the statement will revert to an execution plan that does not require the index.

Thus, statements will always succeedbut perhaps at the cost of greatly reduced performance. This behavior is controlled by the instance parameter SKIP_UNUSABLE_INDEXES, which defaults to TRUE. The exception to this is if the index is necessary to enforce a constraint: if the index on a primary key column becomes unusable, the table will be locked for DML.

To detect indexes which have become unusable, query the DBA_INDEXES view:
SQL> select owner, index_name from dba_indexes where status='UNUSABLE';

Repairing Unusable Indexes
----------------------------------------

To repair the index, it must be re-created with the ALTER INDEX...REBUILD command.

This will make a pass through the table, generating a new index with correct rowid pointers
for each index key. When the new index is completed, the original unusable index is dropped.

The syntax of the REBUILD command has several options. The more important ones are TABLESPACE, ONLINE, and NOLOGGING. By default, the index will be rebuilt within its current tablespace, but by specifying a table space with the TABLESPACE keyword, it can be moved to a different one.

Also by default, during the course of the rebuild the table will be locked for DML. This can be avoided by using the ONLINE keyword.

1)Create Table and insert row in it:
----------------------------------------
SQL> create table test ( a number primary key);
Table created.

SQL> insert into test values(1);
1 row created.

SQL> commit;
Commit complete.

2)Check the Index Status
--------------------------
SQL> select index_name, status from user_indexes;
INDEX_NAME STATUS
--------------------------------------
SYS_C0044513 VALID

3)Move the Table and Check Status:
------------------------------------
SQL> alter table test move;
Table altered.

SQL> select index_name, status from user_indexes;
INDEX_NAME STATUS
--------------------------------------
SYS_C0044513 UNUSABLE

4)Rebuild The Index:
-----------------------
SQL> alter index SYS_C0044514 rebuild online;
Index altered.

SQL> select index_name, status from user_indexes;
INDEX_NAME STATUS
-------------------------------------

