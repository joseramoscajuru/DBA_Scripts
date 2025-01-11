
SELECT 
  table_name, 
  pg_size_pretty( pg_total_relation_size(quote_ident(table_name))), 
  pg_total_relation_size(quote_ident(table_name))
FROM 
  information_schema.tables
WHERE 
  table_schema = 'public'
ORDER BY 
  pg_total_relation_size(quote_ident(table_name)) DESC;
  

This will show you the schema name, table name, size pretty and size (needed for sort).

SELECT
  schema_name,
  relname,
  pg_size_pretty(table_size) AS size,
  table_size

FROM (
       SELECT
         pg_catalog.pg_namespace.nspname           AS schema_name,
         relname,
         pg_relation_size(pg_catalog.pg_class.oid) AS table_size

       FROM pg_catalog.pg_class
         JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
     ) t
WHERE schema_name NOT LIKE 'pg_%'
ORDER BY table_size DESC;

This will be more clear.

pg_size_pretty(<numeric_value>) - converts no.of bytes to human-readable format.

pg_database_size(<db_name>) - gets database size in bytes.

pg_total_relation_size(<relation_name>) - gets total size of table and its index in bytes.

pg_relation_size(<relation_name>) - gets relation (table/index) size in bytes.

pg_indexes_size(<relation_name>) - gets index size of the relation in bytes.

current_database() - gets the currently used database on which this query is being performed.

Query:

select current_database() as database,
       pg_size_pretty(total_database_size) as total_database_size,
       schema_name,
       table_name,
       pg_size_pretty(total_table_size) as total_table_size,
       pg_size_pretty(table_size) as table_size,
       pg_size_pretty(index_size) as index_size
       from ( select table_name,
                table_schema as schema_name,
                pg_database_size(current_database()) as total_database_size,
                pg_total_relation_size(table_name) as total_table_size,
                pg_relation_size(table_name) as table_size,
                pg_indexes_size(table_name) as index_size
                from information_schema.tables
                where table_schema=current_schema() and table_name like 'table_%'
                order by total_table_size
            ) as sizes;
            
            


