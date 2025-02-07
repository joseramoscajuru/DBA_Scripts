
Calculate export dmp size

Summary

Sometimes you have to export all the database or many schemas but you don't have all the necessary space needed, or you don't know exactly how much space the dmp file it will take.

Oracle with exports (or expdp) stores at the dmp file the table data. Indexes are just "Create index statements" which will be created after loading the table data. So the key factor of how big will be your dmp file, depends on how much table data you have.

The following query calculates how much table data each schema takes on your database

SELECT owner, ROUND(SUM(size_mb)) MBytes FROM 
(
SELECT owner, segment_name, segment_type, partition_name, ROUND(bytes/(1024*1024),2) SIZE_MB, tablespace_name 
FROM DBA_SEGMENTS 
WHERE SEGMENT_TYPE IN ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION') 
--AND TABLESPACE_NAME LIKE 'COSTE%' 
--AND SEGMENT_NAME LIKE 'OE_ORDER_LINES_ALL%' 
--AND partition_name LIKE 'USAGE_FCT_NEW%'
--AND OWNER = 'TARGET_DW' 
--AND ROUND(bytes/(1024*1024),2) > 1000)
) 
GROUP BY owner 
ORDER BY MBytes DESC;

OWNER                              MBYTES
------------------------------ ----------
TARGET_DW                         3774208
TARGET_POC                         673192
STAGE_DW                           469263
PRESTAGE_DW                        389326
SHADOW_DW                          257233
PRESENT_PERIF                      148063
SNAP                               141565
PKIOUSIS                           117535
DM_SPSS                             44760
MONITOR_DW                          35336
CUSTOMER_VIEW                       29807

for example if you export the SHADOW_DW schema, it will create a dmp file approximately 257233MB->250GBytes.

Tip:
Bear in mind that the actual dump file will have smaller size than 250GB!!!, because in most cases the TABLE DATA are fragmented!. Export-Datapump, removes fragmentation!.

Indexes, packages, procedures, views, etc, are not taking too much space in the dmp file, are just DDL statements.

SELECT 'expdp SYSTEM/oracle DUMPFILE=' || owner || '_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=' || owner ||'.log schemas= ' || owner SQL
FROM (
SELECT owner, ROUND(SUM(size_mb)) MBytes FROM 
(
SELECT owner, segment_name, segment_type, partition_name, ROUND(bytes/(1024*1024),2) SIZE_MB, tablespace_name 
FROM DBA_SEGMENTS 
WHERE SEGMENT_TYPE IN ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION') 
AND owner = 'SAPSR3'
--AND TABLESPACE_NAME LIKE 'COSTE%' 
--AND SEGMENT_NAME LIKE 'OE_ORDER_LINES_ALL%' 
--AND partition_name LIKE 'USAGE_FCT_NEW%'
--AND OWNER <> 'SYSTEM' 
--AND ROUND(bytes/(1024*1024),2) > 1000)
) 
GROUP BY owner 
ORDER BY MBytes DESC);

expdp SYSTEM/oracle DUMPFILE=GLOB_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=GLOB.log schemas= GLOB
expdp SYSTEM/oracle DUMPFILE=HELPDESK_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=HELPDESK.log schemas= HELPDESK
expdp SYSTEM/oracle DUMPFILE=GATH_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=GATH.log schemas= GATH
expdp SYSTEM/oracle DUMPFILE=ANAT_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=ANAT.log schemas= ANAT
expdp SYSTEM/oracle DUMPFILE=BATH_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=BATH.log schemas= BATH
expdp SYSTEM/oracle DUMPFILE=PROM_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=PROM.log schemas= PROM
expdp SYSTEM/oracle DUMPFILE=ATHINA_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=ATHINA.log schemas= ATHINA
expdp SYSTEM/oracle DUMPFILE=DYAT_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=DYAT.log schemas= DYAT
expdp SYSTEM/oracle DUMPFILE=PLDM_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=PLDM.log schemas= PLDM
expdp SYSTEM/oracle DUMPFILE=ANTHES_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=ANTHES.log schemas= ANTHES
expdp SYSTEM/oracle DUMPFILE=PRS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=PRS.log schemas= PRS
expdp SYSTEM/oracle DUMPFILE=HR_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=HR.log schemas= HR
expdp SYSTEM/oracle DUMPFILE=PATRA_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=PATRA.log schemas= PATRA
expdp SYSTEM/oracle DUMPFILE=LRS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=LRS.log schemas= LRS
expdp SYSTEM/oracle DUMPFILE=SYS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=SYS.log schemas= SYS
expdp SYSTEM/oracle DUMPFILE=BER_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=BER.log schemas= BER
expdp SYSTEM/oracle DUMPFILE=ANMAK_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=ANMAK.log schemas= ANMAK
expdp SYSTEM/oracle DUMPFILE=PERFSTAT_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=PERFSTAT.log schemas= PERFSTAT
expdp SYSTEM/oracle DUMPFILE=TRP_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=TRP.log schemas= TRP
expdp SYSTEM/oracle DUMPFILE=LAM_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=LAM.log schemas= LAM
expdp SYSTEM/oracle DUMPFILE=NISIA_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=NISIA.log schemas= NISIA
expdp SYSTEM/oracle DUMPFILE=GIAN_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=GIAN.log schemas= GIAN
expdp SYSTEM/oracle DUMPFILE=KZN_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=KZN.log schemas= KZN
expdp SYSTEM/oracle DUMPFILE=BORAIG_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=BORAIG.log schemas= BORAIG
expdp SYSTEM/oracle DUMPFILE=NDALAVAGAS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=NDALAVAGAS.log schemas= NDALAVAGAS
expdp SYSTEM/oracle DUMPFILE=VDESINIOTIS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=VDESINIOTIS.log schemas= VDESINIOTIS
expdp SYSTEM/oracle DUMPFILE=SYSMAN_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=SYSMAN.log schemas= SYSMAN
expdp SYSTEM/oracle DUMPFILE=FTROULAKIS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=FTROULAKIS.log schemas= FTROULAKIS
expdp SYSTEM/oracle DUMPFILE=XOR_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=XOR.log schemas= XOR
expdp SYSTEM/oracle DUMPFILE=XORTST_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=XORTST.log schemas= XORTST
expdp SYSTEM/oracle DUMPFILE=TEMPUSR_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=TEMPUSR.log schemas= TEMPUSR
expdp SYSTEM/oracle DUMPFILE=SECURITY_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=SECURITY.log schemas= SECURITY
expdp SYSTEM/oracle DUMPFILE=KPI_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=KPI.log schemas= KPI
expdp SYSTEM/oracle DUMPFILE=TOAD_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=TOAD.log schemas= TOAD
expdp SYSTEM/oracle DUMPFILE=LLU_MON_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=LLU_MON.log schemas= LLU_MON
expdp SYSTEM/oracle DUMPFILE=WMSYS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=WMSYS.log schemas= WMSYS
expdp SYSTEM/oracle DUMPFILE=USER112_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=USER112.log schemas= USER112
expdp SYSTEM/oracle DUMPFILE=SPOTLIGHT_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=SPOTLIGHT.log schemas= SPOTLIGHT
expdp SYSTEM/oracle DUMPFILE=DBSNMP_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=DBSNMP.log schemas= DBSNMP
expdp SYSTEM/oracle DUMPFILE=TSMSYS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=TSMSYS.log schemas= TSMSYS
expdp SYSTEM/oracle DUMPFILE=NISA_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=NISA.log schemas= NISA
expdp SYSTEM/oracle DUMPFILE=DMPISIOTIS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=DMPISIOTIS.log schemas= DMPISIOTIS
expdp SYSTEM/oracle DUMPFILE=TMN_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=TMN.log schemas= TMN
expdp SYSTEM/oracle DUMPFILE=MSTRATAKIS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=MSTRATAKIS.log schemas= MSTRATAKIS
expdp SYSTEM/oracle DUMPFILE=SCOTT_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=SCOTT.log schemas= SCOTT
expdp SYSTEM/oracle DUMPFILE=OUTLN_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=OUTLN.log schemas= OUTLN
expdp SYSTEM/oracle DUMPFILE=CTSES_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=CTSES.log schemas= CTSES
expdp SYSTEM/oracle DUMPFILE=SKAPARELIS_%U.dmp DIRECTORY=exp_dir PARALLEL=10 LOGFILE=SKAPARELIS.log schemas= SKAPARELIS


