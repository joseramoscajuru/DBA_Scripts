declare c clob;
begin
for t in( select tablespace_name from dba_tablespaces)
loop
 select dbms_metadata.get_ddl('TABLESPACE', t.tablespace_name) into c from dual;
 dbms_output.put_line(c);
 dbms_output.put(';');
end loop;
end;
/

declare c clob;
begin
for t in( select tablespace_name from dba_tablespaces)
loop
 select dbms_metadata.get_ddl('TABLESPACE', t.tablespace_name) into c from dual;
 dbms_output.put_line(c);
 dbms_output.put(';');
end loop;
end;
/