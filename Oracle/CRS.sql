sudo su - root:

START:

/usr/app/crs/bin/crsctl start crs
/u01/app/oracle/oracle/product/10.2.0/crs/bin/crsctl start crs

STOP:

/usr/app/crs/bin/crsctl stop crs
/u01/app/oracle/oracle/product/10.2.0/crs/bin/crsctl stop crs

CHECAR STATUS

/usr/app/crs/bin/crs_stat -t
/u01/app/oracle/oracle/product/10.2.0/crs/bin/crs_stat -t

/usr/app/crs/bin/crs_stat -n | grep -i <Instancia>

/u01/app/oracle/oracle/product/10.2.0/crs/bin/crs_stat -t

Caso o comando acima no retorne nada, o CRS esta com problema

#Logs
/u01/app/crs/log/nodename/crsd/crsd.log

/usr/app/crs/log/us97udb036ampsb/crsd


#### LAST HOPE
/etc/init.d/init.evmd run >/dev/null 2>&1 </dev/null
/etc/init.d/init.cssd fatal >/dev/null 2>&1 </dev/null
/etc/init.d/init.crsd run >/dev/null 2>&1 </dev/null
7:38:59 PM: Arthur Jose Urbano: qdo o crsctl start crs nao funfa
7:39:11 PM: Arthur Jose Urbano: estes comandos ai .. sao the last hope

e as vezes .. trava a sessao onde vc rodou
7:39:38 PM: Arthur Jose Urbano: mas  assim mesmo
7:39:39 PM: Arthur Jose Urbano: lol
7:39:47 PM: Arthur Jose Urbano: abre outra .. roda os outros
7:40:12 PM: Arthur Jose Urbano: as vezes .. o CTRL+C .. funciona para destravar a sessao e deixar eles rodando
7:40:25 PM: Arthur Jose Urbano: eles seriam a saida do -> ps -ef|grep d.bin
7:40:26 PM: Arthur Jose Urbano: ;)
7:40:37 PM: Arthur Jose Urbano: mas para isto .. a rede tem que estar legal

