

-- To view a list of all users, type the following command from the mysql> prompt:

mysql> SELECT user FROM mysql.user GROUP BY user;
+----------------+
| user           |
+----------------+
| hue            |
| metastore      |
| mysql.session  |
| mysql.sys      |
| rman           |
| root           |
| schemaregistry |
| scm            |
| scooziem       |
| smm            |
+----------------+
10 rows in set (0.00 sec)

mysql> SELECT host,user,authentication_string FROM mysql.user;
+-----------------------------+------------------+-------------------------------------------+
| host                        | user             | authentication_string                     |
+-----------------------------+------------------+-------------------------------------------+
| localhost                   | root             | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| localhost                   | mysql.session    | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| localhost                   | mysql.sys        | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| %                           | amon_user        | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | amon_user        | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | activity_monitor | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | activity_monitor | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | report_manager   | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| rrpfsao01a6502.record.cloud | report_manager   | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | hive             | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | hue              | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | oozie            | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | smm              | *827D97950E1B179457FEB7E1716E139E1F6DAAB9 |
| %                           | veeam_bkp        | *D81778CA0A1E3CC6DDFB8020F8F3D3EDF8640628 |
| %                           | IBMITMSE         | *208B5899B048F4796DDDFB97477FCA42BE53DFD9 |
+-----------------------------+------------------+-------------------------------------------+
15 rows in set (0.07 sec)

mysql> SHOW CREATE USER hue;
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CREATE USER for hue@%                                                                                                                                            |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CREATE USER 'hue'@'%' IDENTIFIED WITH 'mysql_native_password' AS '*827D97950E1B179457FEB7E1716E139E1F6DAAB9' REQUIRE NONE PASSWORD EXPIRE DEFAULT ACCOUNT UNLOCK |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> SHOW VARIABLES LIKE 'validate_password%';
+--------------------------------------+--------+
| Variable_name                        | Value  |
+--------------------------------------+--------+
| validate_password_check_user_name    | OFF    |
| validate_password_dictionary_file    |        |
| validate_password_length             | 8      |
| validate_password_mixed_case_count   | 1      |
| validate_password_number_count       | 1      |
| validate_password_policy             | MEDIUM |
| validate_password_special_char_count | 1      |
+--------------------------------------+--------+
7 rows in set (0.00 sec)

mysql> SELECT PLUGIN_NAME, PLUGIN_STATUS
    ->        FROM INFORMATION_SCHEMA.PLUGINS
    ->        WHERE PLUGIN_NAME LIKE 'validate%';
+-------------------+---------------+
| PLUGIN_NAME       | PLUGIN_STATUS |
+-------------------+---------------+
| validate_password | ACTIVE        |
+-------------------+---------------+
1 row in set (0.01 sec)

SELECT user,
authentication_string, 
CHAR_LENGTH(authentication_string)  AS 'Password length' 
FROM mysql.user ;