CUA DATABASE

RMAN_OPTFILE_DB=/opt/tivoli/tsm/client/oracle/bin64/tdpo_HOSSLM00LER_FORAD_CUA.opt
RMAN_OPTFILE_ARC=/opt/tivoli/tsm/client/oracle/bin64/tdpo_HOSSLM00LER_AORAD_CUA.opt

rman target / nocatalog

run {
allocate channel t1 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=/opt/tivoli/tsm/client/oracle/bin64/tdpo_HOSSLM00LER_AORAD_CUA.opt)';
crosscheck archivelog all;
delete expired archivelog all; 
}