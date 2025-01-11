
Section # R.1.1.1
Section Heading: Password Requirements
System Value / Parameter: Blank passwords
"Description": Set passwords for all accounts, especially root account.
"Recommended Value": No blank passwords
Agreed to Value: TBD

Security Rationale
Without password only knowing user name and the list of allowed host will allow someone to connect to the server and assume the identity of the user.

"Guideline To Validate
In all cases, a method is provided; however, any means that verifies the required control may be used."

select user, host FROM mysql.user  
WHERE (plugin IN('mysql_native_password', 'mysql_old_password')   
AND (LENGTH(Password) = 0   OR Password IS NULL)) 
OR (plugin='sha256_password' AND LENGTH(authentication_string) = 0);

select user, host FROM mysql.user  
WHERE (plugin IN('mysql_native_password', 'mysql_old_password')   
AND (LENGTH(authentication_string) = 0   OR authentication_string IS NULL)) 
OR (plugin='sha256_password' AND LENGTH(authentication_string) = 0);

mysql> select authentication_string, plugin
    -> from mysql.user;
+-------------------------------------------+-----------------------+
| authentication_string                     | plugin                |
+-------------------------------------------+-----------------------+
| *543631CE2BA546F4A9785C6779B797757B85F13C | mysql_native_password |
| *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE | mysql_native_password |
| *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE | mysql_native_password |
| *827D97950E1B179457FEB7E1716E139E1F6DAAB9 | mysql_native_password |
| *827D97950E1B179457FEB7E1716E139E1F6DAAB9 | mysql_native_password |
| *827D97950E1B179457FEB7E1716E139E1F6DAAB9 | mysql_native_password |
| *827D97950E1B179457FEB7E1716E139E1F6DAAB9 | mysql_native_password |
| *827D97950E1B179457FEB7E1716E139E1F6DAAB9 | mysql_native_password |
| *827D97950E1B179457FEB7E1716E139E1F6DAAB9 | mysql_native_password |
| *827D97950E1B179457FEB7E1716E139E1F6DAAB9 | mysql_native_password |
+-------------------------------------------+-----------------------+
10 rows in set (0.00 sec)


"Guideline To Configure
In all cases, a method is provided; however, any means that achieves the required control may be used."

