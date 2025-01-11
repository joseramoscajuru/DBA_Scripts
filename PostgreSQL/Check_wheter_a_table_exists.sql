
How to check whether a table (or view) exists, and the current user has access to it?

SELECT EXISTS (
   SELECT FROM information_schema.tables 
   WHERE  table_schema = 'public'
   AND    table_name   = 'hosts'
   );
 exists 
--------
 t
(1 row)


SELECT * FROM information_schema.tables 
   WHERE table_name   = 'hosts';

 table_catalog | table_schema | table_name | table_type | self_referencing_column_name | reference_generation | user_defined_type_catalog | user_defined_type_schema | user_def
ined_type_name | is_insertable_into | is_typed | commit_action 
---------------+--------------+------------+------------+------------------------------+----------------------+---------------------------+--------------------------+---------
---------------+--------------------+----------+---------------
 zabbix        | public       | hosts      | BASE TABLE |                              |                      |                           |                          |         
               | YES                | NO       | 
(1 row)

How to check whether a table exists?

SELECT EXISTS (
   SELECT FROM pg_catalog.pg_class c
   JOIN   pg_catalog.pg_namespace n ON n.oid = c.relnamespace
   WHERE  n.nspname = 'public'
   AND    c.relname = 'hosts'
   AND    c.relkind = 'r'    -- only tables
   );
   

   SELECT * FROM pg_catalog.pg_class c
   JOIN   pg_catalog.pg_namespace n ON n.oid = c.relnamespace
   WHERE  n.nspname = 'public'
   AND    c.relname = 'hosts'
   AND    c.relkind = 'r'   ; -- only tables

SELECT EXISTS (
   SELECT FROM pg_tables
   WHERE  schemaname = 'public'
   AND    tablename  = 'hosts'
   );   