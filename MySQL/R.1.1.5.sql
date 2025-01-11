
Section #: R.1.1.5
Section Heading: Password Requirements
System Value / Parameter: old-passwords = 0
"Description": "Do not enable insecure password generation option, as per pre-4.1-style passwords. 
Default value is 1 - this should be changed. (V4.1+)"

"Recommended Value"

"MySQL config file setting:
old-passwords = 0
OR 
old_passwords = 0"

Agreed to Value: TBD

-- Security Rationale
Reusing your password can, increases risk of access to several accounts if your password is hacked. Change your password to something unique for each of your accounts.

-- "Guideline To Validate
-- In all cases, a method is provided; however, any means that verifies the required control may be used."


mysql>  SHOW GLOBAL VARIABLES LIKE '%old_passwords%';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| old_passwords | 0     |
+---------------+-------+
1 row in set (0.01 sec)


"Guideline To Configure
In all cases, a method is provided; however, any means that achieves the required control may be used."

"Add the below line in my.cnf or my.ini file
old_password=0"

