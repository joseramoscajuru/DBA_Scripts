REORG DE TABELAS:

brspace -u / -c force -f tbreorg -a reorg -t "J_1BNFDOC",¨TABELA2¨,¨TABELA3¨ -p 3 -e 2


COMPRESSAO DE INDIKCES:

brspace -u / -c force -f idrebuild -o sapsr3 -m online "ZARIXBC3~0","ZCMD_PRODCHAR_OS~0" -c cind -e 2 -p 2


REBUILD DE INDICES:

brspace -u / -c force -f idrebuild -i "BCST_SR~IN2","BCST_SR~DAT","RORQSTPRMS~0","SWWOUTBOX~002","SWWEI~0" -e 4 -p 2


COLETA DE ESTATISTICAS:

brconnect -u / -c -f stats -f collect -t ZARIXBC8,ZGLOCT_DELIV_MSG,ZCMD_PRODCHAR_OS,ZARIXBC3,SWW_CONT -p 5