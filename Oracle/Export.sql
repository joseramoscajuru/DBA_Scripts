###Exemplos de export com nohup logando com o usurio SYS

nohup expdp userid=\"/ as sysdba\" dumpfile=expdpSCHEMA_GSDM820B_20111003.DMP directory=IMR_31483764 schemas=GSDM820B logfile=expdpSCHEMA_GSDM820B_20111003.log & 

nohup expdp userid=\"/ as sysdba\" dumpfile=expdpSCHEMA_GS820_ADMB_20111003.DMP directory=IMR_31483764 schemas=GS820_ADMB logfile=expdpSCHEMA_GS820_ADMB_20111003.log &; 


nohup expdp userid=\"/ as sysdba\" dumpfile=FULL_CAMILION_20111202.DMP directory=IMR_31483764 schemas=GS820_ADMB logfile=expdpSCHEMA_GS820_ADMB_20111003.log &; 

nohup exp system/HFTTHYPN_5y5t1m@HFTTHYPN file=hyphfm_admin_full_20052011.dmp log=hyphfm_admin_full_20052011. direct=y owner=hyphfm_admin statistics=none &

nohup exp system/HFTTHYPN_5y5t1m@HFTTHYPN file=hyphfm_admin_full_20052011.dmp log=hyphfm_admin_full_20052011. direct=y owner=hyphfm_admin statistics=none &


select sum(bytes)/1024/1024/1024 GB from dba_segments;

export ORACLE_SID=CAMILION 

export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252

exp userid=\"/ as sysdba\" file=J:\backups\CAMILION\expFull_Camilion_20111202.dmp log=J:\backups\CAMILION\expFull_Camilion_20111202.log full=y direct=Y

#VERIFICAR O CHARSET DO BD
select DECODE(parameter, 'NLS_CHARACTERSET', 'CHARACTER SET',
 'NLS_LANGUAGE', 'LANGUAGE',
 'NLS_TERRITORY', 'TERRITORY') name,
 value from v$nls_parameters
 WHERE parameter IN ( 'NLS_CHARACTERSET', 'NLS_LANGUAGE', 'NLS_TERRITORY');
 /

LANGUAGE      AMERICAN
TERRITORY     AMERICA
CHARACTER SET WE8MSWIN1252

export NLS_LANG=<language>_<territory>.<character set>
 
export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252



exp userid=system/password file=output.dmp log=ouput.log full=y direct=Y

LANGUAGE      AMERICAN
TERRITORY     AMERICA
CHARACTER SET WE8MSWIN1252

####################### EXEMPLO EXPORT E IMPORT NA PANASONIC
imp userid=\"/ as sysdba\" file=expVISION_SR_ISC_INVENTORY20120209.dmp log=expVISION_SR_ISC_INVENTORY20120209.log tables=(VISION.SR_ISC_INVENTORY)

imp scott/tiger file=emp.dmp fromuser=scott touser=scott tables=dept

imp userid=\"/ as sysdba\" file=expVISION_SR_ISC_INVENTORY20120209.dmp log=expVISION_SR_ISC_INVENTORY20120209.log fromuser =VISION TOUSER=VISION tables=SR_ISC_INVENTORY

imp userid=\"/ as sysdba\" file=C:\TEMP\exportSECU\expVISION_SR_ISC_INVENTORY20120209.dmp log=C:\TEMP\exportSECU\impVISION_SR_ISC_INVENTORY20120209.log fromuser=VISION touser=VISION tables=(SR_ISC_INVENTORY);

imp userid=\"/ as sysdba\" file=expVISION_SR_ISC_INVENTORY20120209.dmp log=expVISION_SR_ISC_INVENTORY20120209.log tables=(VISION.SR_ISC_INVENTORY)

imp scott/tiger file=emp.dmp fromuser=scott touser=scott tables=dept

imp userid=\"/ as sysdba\" file=expVISION_SR_ISC_INVENTORY20120209.dmp log=expVISION_SR_ISC_INVENTORY20120209.log fromuser =VISION TOUSER=VISION tables=SR_ISC_INVENTORY

imp userid=\"/ as sysdba\" file=C:\TEMP\exportSECU\expVISION_SR_ISC_INVENTORY20120209.dmp log=C:\TEMP\exportSECU\impVISION_SR_ISC_INVENTORY20120209.log fromuser=VISION touser=VISION tables=(SR_ISC_INVENTORY);

