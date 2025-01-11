select logins from v$instance;

LOGINS
----------
RESTRICTED

alter system disable restricted session;

System altered.

select logins from v$instance;

LOGINS
----------
ALLOWED

