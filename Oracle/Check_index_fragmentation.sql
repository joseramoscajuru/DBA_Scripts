Use this pl/sql script to determine which indexes need defragmentation.

create or replace procedure system.my_indfrag (schema_in  in varchar2)
as

	cursor ind_cur(schema varchar2) is
	(select owner, index_name from dba_indexes where owner=
	upper(schema));

	owner varchar2(40);
	ind_name varchar2(30);

	cursor badness_cur is
	(select name, del_lf_rows/(lf_rows+0.00001) badness, height
	from system.ind_temp_table
	where del_lf_rows/(lf_rows+0.00001) > .15 or height > 5 );

	bad_row badness_cur%rowtype;

begin

	/* 
	 * Assumes that you have created a table system.ind_temp_table of 
the same
	 * structure as index_stats. 
         */

	dbms_output.enable(1000000);
	delete from system.ind_temp_table;
	
	open ind_cur(schema_in);
	fetch ind_cur into owner, ind_name; 
	while ind_cur%found
	loop
		begin <>
			execute immediate('analyze index ' || owner  || 
'.' || 
						'"' || ind_name || '"' || 
' validate structure');
			insert into system.ind_temp_table
			(select * from index_stats);
			commit;
		exception
			when others then
				dbms_output.put_line(ind_name || ':' || 
chr(09) || sqlerrm);
				rollback;
		end analyze_block;

		fetch ind_cur into owner, ind_name;
	end loop;
	close ind_cur;

	open badness_cur;
	fetch badness_cur into bad_row;
	if badness_cur%found then
		dbms_output.put_line(rpad('Index Name',30) || chr(09) || 
'% Del. Entries' || chr(09) || 'Height');
	else
		dbms_output.put_line('No indexes in this schema need 
rebuilding.');
	end if;
	while badness_cur%found
	loop
		dbms_output.put_line(rpad(bad_row.name,30) || chr(09) 
			|| rpad(to_char(round(bad_row.badness*100,0)) || 
'%',14) || chr(09) ||
			bad_row.height);
		fetch badness_cur into bad_row;
	end loop;
	close badness_cur;

end;

Sample output


ASP>  exec my_indfrag('HR_DATA');
chairs_index1:  ORA-01418: specified index does not exist
ASP>  exec system.my_indfrag('HR_DATA');
Index Name                      % Del. Entries  Height
IDX_DISC_PERSON_APPT_VERIFIED   50%             2
IDX_DISC_PERSON_APPT_VERIFIED   58%		1
IDX_LEAVE_END_RPT               63%		2
IDX_LEAVE_START_RPT             60%		3
IDX_LEAVES_NAME_KEY             65%		1
TC_WORKGRPS_PK                  48%		1
TC_SYSTEM_ACCRUALS_PK           44%		2
TC_WORKGROUP_SETTINGS_PK        10%		6

PL/SQL procedure successfully completed.





