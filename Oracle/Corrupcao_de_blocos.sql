#LISTAR BLOCOS
select * from dba_extents where file_id = 12 and 707034 between block_id and block_id+blocks-1;

#EXEMPLO DE PLANO DE AO - Cada situao deve ser analisada com cuidado!

Primeiro identifiquei o tipo de obejto que estava corrompido

select * from dba_extents where file_id = 9 and 1763502 between block_id and block_id+blocks-1;

Criei uma tabela de backup.

create table recover_block as select * from GSDM820.FT_WF_WFRV;

commit;


Extrai os ddls dos objetos a serem dropados

select dbms_metadata.get_ddl('TABLE', 'FT_WF_WFRV','GSDM820') from dual

select dbms_metadata.get_ddl('INDEX', 'FT_WF_WFRV_PK','GSDM820') from dual

Guardei os grants relacionados a tabela

select 'grant '||privilege||' on GSDM820.FT_WF_WFRV to '||grantee||'; '
from   dba_tab_privs
where  table_name ='FT_WF_WFRV'

Dropei a tabela, recriei e depois foi a vez do ndice

alter table  GSDM820.FT_WF_WFRV  drop primary key 

  CREATE UNIQUE INDEX "GSDM820"."FT_WF_WFRV_PK" ON "GSDM820"."FT_WF_WFRV" ("VARIABLE_ID", "VARIABLE_NME")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 4194304 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "FES_INDEX_SM"

alter table  GSDM820.FT_WF_WFRV add constraint FT_WF_WFRV_PK primary key ("VARIABLE_ID", "VARIABLE_NME")

