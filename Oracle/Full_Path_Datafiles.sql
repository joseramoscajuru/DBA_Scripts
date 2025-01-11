
SELECT full_path, dir, sys
FROM (
SELECT CONCAT ('+'|| gname, sys_connect_by_path (aname,'/')) full_path, dir, sys 
FROM ( SELECT 	g.name gname, 
				a.parent_index pindex, 
				a.name aname, 
				a.reference_index rindex, 
				a.alias_directory dir, 
				a.system_created sys 
FROM v$asm_alias a, v$asm_diskgroup g 
WHERE a.group_number = g.group_number) 
START WITH (mod(pindex, power(2, 24))) = 0 
CONNECT BY PRIOR rindex = pindex 
ORDER BY dir desc, full_path asc) ;
--WHERE full_path LIKE upper('%/br%');