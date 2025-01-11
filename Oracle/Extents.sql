#Checar tabelas com extents estourados.
# Exemplo de erro: ORA-1631: max # extents 249 reached in table SYS.AUD$

select segment_name, owner, extents, max_extents
from dba_segments
where segment_type = 'TABLE'
and (extents +1) >= max_extents;

ALTER TABLE <OWNER>.<TABLE> STORAGE (MAXEXTENTS UNLIMITED);
Exemplo:
ALTER TABLE SYS.AUD$ STORAGE (MAXEXTENTS UNLIMITED);

#############################################################################################
# Alterando parmetros 

select MAX_EXTENTS, NEXT_EXTENT, PCT_INCREASE from dba_segments where segment_name='AUD$';

MAX_EXTENTS NEXT_EXTENT
----------- -----------
 2147483645   167788544

SQL> desc dba_free_space;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 TABLESPACE_NAME                                    VARCHAR2(30)
 FILE_ID                                            NUMBER
 BLOCK_ID                                           NUMBER
 BYTES                                              NUMBER
 BLOCKS                                             NUMBER
 RELATIVE_FNO                                       NUMBER

select BYTES/1024/1024, count(1) from dba_free_space where bytes >= 167788544  group by bytes order by bytes;

select count(1) from dba_extents where segment_name = 'AUD$';

alter table AUD$ storage (next 100K);

alter table AUD$ storage (pctincrease 0);

SQL> alter table AUD$ storage (next 100K);

Table altered.

SQL> alter table AUD$ storage (pctincrease 0);

Table altered.

