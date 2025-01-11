
To determine the size of a database, type the following command. Replace dbname with the name of the database that you want to check:

SELECT pg_size_pretty( pg_database_size('postgres') );

To determine the size of a table in the current database, type the following command. Replace tablename with the name of the table that you want to check:

SELECT pg_size_pretty( pg_total_relation_size('tablename') );

