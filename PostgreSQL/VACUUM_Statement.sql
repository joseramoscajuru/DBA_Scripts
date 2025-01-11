
Reclaim Space on a Table
Next, lets look at how to vacuum a specific table, instead of the entire database.

For example:

VACUUM products;

This example would vacuum only the products table. It would free up the space within the products table and leave the space available to be used by only the products table. The size of the database file would not be reduced.

If you wanted to allocate the unused space back to the operating system, you would have to add the FULL option to the VACUUM statement as follows:

VACUUM FULL products;

This would not only free up the unused space in the products table, but it would also allow the operating system to reclaim the space and reduce the database size.

Vacuum Activity Report

Finally, you can add the VERBOSE option to the VACUUM command to display an activity report of the vacuum process.

For example:

VACUUM FULL VERBOSE products;

This would perform a full vacuum of the products table. Let's show you what you can expect to see as output for a vacuum activity report:

totn=# VACUUM FULL VERBOSE products;
INFO:  vacuuming "public.products"
INFO:  "products": found 4 removable, 5 nonremovable row versions in 1 pages
DETAIL:  0 dead row versions cannot be removed yet.
CPU 0.00s/0.00u sec elapsed 0.04 sec.
VACUUM
