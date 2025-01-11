System privileges for a user:

WITH users AS
 (SELECT 'PSREAD' usr FROM dual),
Roles AS
 (SELECT granted_role
    FROM dba_role_privs rp
    JOIN users
      ON rp.GRANTEE = users.usr
  UNION
  SELECT granted_role
    FROM role_role_privs
   WHERE role IN (SELECT granted_role
                    FROM dba_role_privs rp
                    JOIN users
                      ON rp.GRANTEE = users.usr)),
tab_privilage AS
 (SELECT OWNER, TABLE_NAME, PRIVILEGE
    FROM role_tab_privs rtp
    JOIN roles r
      ON rtp.role = r.granted_role
  UNION
  SELECT OWNER, TABLE_NAME, PRIVILEGE
    FROM Dba_Tab_Privs dtp
    JOIN Users
      ON dtp.grantee = users.usr),
sys_privileges AS
 (SELECT privilege
    FROM dba_sys_privs dsp
    JOIN users
      ON dsp.grantee = users.usr)
SELECT * FROM tab_privilage ORDER BY owner, table_name;