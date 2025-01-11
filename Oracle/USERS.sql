#Recriar User com grants
SELECT dbms_metadata.get_ddl('USER','SCOTT') FROM dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('ROLE_GRANT','SCOTT') from dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('OBJECT_GRANT','SCOTT') from dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT','SCOTT') from dual;

#Recriar Role com grants
SELECT dbms_metadata.get_ddl('ROLE','RESOURCE') from dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT','RESOURCE') from dual;

--------------------------------------------------------------------------------
PARA TROCAR SENHA E VOLTARA A ANTIGA

Você se conecta com um usuário administrativo (DBA ou SYSDBA) e executa a consulta e anota o resultado:

 SQL> spool senha_sys.log
 SQL> SELECT password FROM dba_users     WHERE username='SYS';

PASSWORD                      
------------------------------
F894844C34402B67              

SQL>spool off

 Agora você altera temporariamente a senha do usuário para qualquer uma e poderá realizar a manutenção desejada:

 SQL> ALTER USER scott IDENTIFIED BY manutencao;

 Após a manutenção você apenas retorna para o valor desejado e a senha voltará a ser a mesma de antes:

 SQL> ALTER USER scott IDENTIFIED BY VALUES 'F894844C34402B67';

 Pronto.  É uma ação simples, mas muitos não sabem desta boa idéia na hora de  executar alguma manutenção com esses requisitos. Em migrações também  pode ser útil.

 

-----------------------------------------------------------------
# Ver lock no usuario

select username, profile, account_status from dba_users where lower(username) = 'ro2k5cy';
select username, profile, account_status from dba_users where lower(username) = 'tpnl';
select username, profile, account_status from dba_users where lower(username) = 'DOCLINK';

-----------------------------------------------------------------
# Unlock User
alter user DSRUSER account unlock;
alter user DSG_ZONE03_PROD account unlock;

-----------------------------------------------------------------
# Ver password
select USERNAME,ACCOUNT_STATUS,PASSWORD from dba_users where USERNAME like '%DSG%';

select USERNAME,ACCOUNT_STATUS from dba_users where USERNAME like '%DSG%';
select USERNAME, ACCOUNT_STATUS from dba_users where ACCOUNT_STATUS<>'OPEN';
select 'alter user '||username||' identified by values '''||password||''';' from dba_users where ACCOUNT_STATUS<>'OPEN';

-----------------------------------------------------------------
# mudar password
alter user user_name identified by new_password;
alter user DSG_ZONE04_PROD identified by time2me
alter user DSG_ZONE01_PROD

#Alterar schema:
alter session set current_schema = LPOADM2

# Matar sessao:
alter system kill session 'SID,SERIAL#' immediate;



