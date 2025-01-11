You could capture users and when they change their passwords with a password verify function.  An example is below.  
If you have users where you would not want to log their changes, leave them out of the anonymous block at the end that alters the profile.

--Create a table to hold the log
CREATE TABLE PW_CHANGE_LOG
( USERNAME VARCHAR2(100),
  CHANGE_DATE DATE)
TABLESPACE USERS;

--Create a function to log the change
CREATE OR REPLACE FUNCTION password_change_log (
  username varchar2,
  password varchar2,
  old_password varchar2
) RETURN boolean
IS
BEGIN
  INSERT INTO PW_CHANGE_LOG VALUES (USERNAME, SYSDATE);
  RETURN(TRUE);
END;
/

--Create a profile that will call the function
CREATE PROFILE LOG_PW_CHANGE;
ALTER PROFILE LOG_PW_CHANGE LIMIT PASSWORD_VERIFY_FUNCTION PASSWORD_CHANGE_LOG;

--Assign all users to the profile
BEGIN
  FOR C1 IN (SELECT USERNAME FROM DBA_USERS) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'ALTER USER ' || C1.USERNAME || ' PROFILE LOG_PW_CHANGE';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END LOOP;
END;
/
