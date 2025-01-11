
Section #: R.1.1.4
Section Heading: Password Requirements
System Value / Parameter: Insecure passwords
"Description": For previous-MySQL versions (pre-4.1-style passwords) Remove all insecure passwords.
"Recommended Value": No insecure passwords
Agreed to Value: TBD

Security Rationale
This point is very important, if password is insecure then any user can access the database.

"Guideline To Validate
In all cases, a method is provided; however, any means that verifies the required control may be used."

Ensure   'secure_auth' is set to 'ON'

"Guideline To Configure
In all cases, a method is provided; however, any means that achieves the required control may be used."

mysql> SELECT @@GLOBAL.secure_auth;
+----------------------+
| @@GLOBAL.secure_auth |
+----------------------+
|                    1 |
+----------------------+
1 row in set (0.00 sec)

mysql> SHOW GLOBAL VARIABLES LIKE '%secure_auth%';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| secure_auth   | ON    |
+---------------+-------+
1 row in set (0.01 sec)


"Add the below line in my.cnf or my.ini file
secure_auth=ON"

