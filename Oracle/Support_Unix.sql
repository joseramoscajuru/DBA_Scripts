
		
		PROCEDIMENTOS

	- Node Down  :  caiu a mquina
> ' who -b ' 		( mostra qdo foi dado o ltimo reboot na mquina)

....................................................................................................................................................
	- /home low (ou outros)  :  o FileSystem est cheio

> ' df -k . ' 	( ver os FS em KB) entrar nele
> ' du -ks *| sort -n ' 	( lista em ordem qual + consome)

	- / cheio

[root@hofw007vr /]# df -k .
Filesystem          		 1K-blocks      Used 	Available Use% 	Mounted on
/dev/mapper/rootvg-rootlv          253871    240109      	 655 	100%	 /

[root@hofw007vr /]# lvextend -L +100MB /dev/rootvg/rootlv

  Rounding up size to full physical extent 128.00 MB
  Extending logical volume rootlv to 384.00 MB
  Logical volume rootlv successfully resized

[root@hofw007vr /]# ext2online /dev/rootvg/rootlv

ext2online v1.1.18 - 2001/03/18 for EXT2FS 0.5b

[root@hofw007vr /]# df -k .

Filesystem           		1K-blocks   Used 	 Available	  Use% 	Mounted on
/dev/mapper/rootvg-rootlv        380807    240105    121051    67% 	/


	- Aumentar FileSystem  :  
AIX
## Aumentar File System por comando

	- chfs -a size=+<espao> <nome do filesystem>
## Aumentar File System por linha de comando

	# chfs -a size=+600000 /opt/Tivoli   ====> para aumentar 300 mega
	
chfs -a size=+50000 /dev/lv_optscm  para aumentar 25MB

a ver!!

spocpdsv83e
/dev/hd1
chfs -a size=+100000 /dev/hd1 para aumentar 50MB
....
bizu para metadevice
# metattach <soft-partition-name> <size>
# growfs -M /<dir-name> /dev/md/rdsk/<soft-partition-name>

root@dborap016 # metattach d105 10g
root@dborap016 # growfs -M  /acxp01 /dev/md/rdsk/d105   ----obsverdar que tem que ser o raw device


..............................................................................................................................................................................................
	- ERRPT  :  

> caso de console...rodar um script...? 
fechar

ps -ef | grep gssd
> lssrc -a | grep gssd
startsrc -s gssd

errpt de disco
...
qapan:[root]/> lsdev -Cc disk |grep hdisk234
hdisk234 Available 1A-08-02     IBM FC 2105
qapan:[root]/> datapath query device |grep hdisk234
    1        fscsi2/hdisk234           OPEN   NORMAL    4483240          0

lsdev -Cc adapter

fecho! :)
....



..............................................................................................................................................................................................
	- Impressora  :  

> ' enable xxx '	( enable a mquina)
> ' netstat -p xxx '	( ver o status)
> ' lpr -p '		( )


# Para verificar se a impressora est ativa

	# lpstat -p<nome>

## Verificar se o spooler est operante, se no estiver dar um startsrc

	# lssrc -g spooler		(para ver status da impressora_ tem que estar todas ativadas)

	# startsrc -g spooler

## Para startar a impressora

	# enable <nome_da_fila>

## Para limpar a impressora

	# cancel <numero do job>   ===> apagar um por vez
	# enq -X -P<nome_da_fila> ===> apaga tudo

## Para imprimir um teste

	# lpr -Pprinter <file>

## Para cadastrar uma impressora ou conferir configurao

	# /etc/qconfig
	# /etc/hosts

...

## Impressora

	- lpstat -v<nomedafila> ( limpar fila de impresso )

	- lpstat -p<nomedafila> ( verificar status da impressora )

	- enable <nome da fila> ( habilitar a fila de impresso )

	- disable <nome da fila> ( desabilitar fila de impresso )

	- pr -Pprinter <file> ( enviar teste para impresso )

	- banner "teste" | lpr -Pprinter ( enviar teste para impresso e acompanhar imediatamente )

	- banner "teste" | lp -d<teste>

	- lpstat -t |grep -i " nome da fila "
	
	-cancel <numero do job> 	cancelar um job na impressora
	- cancel -u "usuario (..admin)" " nome da fila "

	- enq -X -P<nome_da_fila ( apaga tudo na fila de impresso )

## Impressora Bunge

	- more /etc/qconfig

	- Efetuar telnet no host da impressora

	- Senha < enter >

	- Port Configuration ( Verificar nome das portas )

	- Retornar
	
	- Display information

	- Display port Status

		( Identificar status da porta ( impressora ) )

## Bunge

	- su - ulibimp ( usuario para liberar fila de impresso )
..............................................................................................................................................................................................
	- Ativaao de trace  :  

> Tem um processo no DB 

..............................................................................................................................................................................................
	-  /var cheio : (/var/spool/mqueue)   (qdeamon)

> var/spool/mqueue	(diretrio de e-mail)

> startsrc -s lpd 		( start no processo )
se for o clientmqueue rodar:	
sendmail -v -q



> find . -type f -mtime +1 -exec rm {} \;  ( deleta todos os arquivos mais velhos que um dia)


..............................................................................................................................................................................................
	-   :  

> enviar arquivo via FTP, 
scp <arquivo> <nome da pessoa>@<ip>:
> 

===============================================================================================
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

					OUTROS COMANDOS
......................................

df -k
ls -ltr |grep xxx
lsvg -l xxx
uname -a
tail -f

lssrc -ls topsvcs
lspv | grep diskhb01vg
ps  lspv | more
lquerypr -vh /dev/vpath0
find / -name clfindres	(achar o cluster)

grep <nome do usurio> /etc/passwd	(ver nome completo do usrio)
grep <processo> /etc/passwd		(ver nome do usrio)
passwd <nome> /etc/passwd		(reset senha)

haemd

 .....................................

/etc/filesystems	aonde ficam os FS desmontados

var/spool/mqueue		(diretrio de impressora...)

startsrc -s lpd ( start no processo )

lssrc -g spooler (para ver status da impressora_ tem que estar todas ativadas)

find . -type f -mtime +1 -exec rm {} \;  ( deleta todos os arquivos mais velhos que um dia)

......................................

===============================================================================================
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
				
				Comandos desconhecidos

.........................

more filesystem

...........................

lsof	arquivo preso

$ lsof -u usurio 	Mostra os arquivos abertos identificado pelo nome de usurio, representado aqui pelo identificador usurio. 

$ lsof -g n 	Mostra os arquivos abertos por um determinado grupo, identificado aqui numericamente pela varivel n. 

$ lsof -p n 	Mostra os arquivos abertos por um determinado nmero de processo (PID), representado aqui pela varivel n. 

$ ls -u usurio -g n 	Existem ainda muitos outros parmetros que podem ser verificados com o comando: 

....................
.
ERRPT

lssrc -a |grep -i configrm	- 
lsrpdomain
lsrpnode -i

entstat

ifconfig -au

..........

SWAP

prstat -s size -n 10

svmon -P -t 1 |more		ele vai te dar o kra que masi come memoria
ps -ef |grep <numero do pid>
ps aux |head -10
...............


fuser -uck <nome do filesystem> // mata todos os processos que estao no fs

umount <nome do filesystem> // desmontar o fs

fsck
fsck -y <nome do filesystem> // corrige os erros que existem no fs
fsck -n <nome do filesystem> // verifica os erros no fs

mount <nome do filesystem> // montar filesystem

.........................

find / -name syslog -print

.........................

start do servico do syslog

>> cd /etc/init.d
>> ./syslogd start
ou
>> ./syslog start

.........................

bindprocessor -q

.....................................

jacclient		Serve para fazer health checking

......................................

xargs
xargs -l

.....................................



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

quando o dtgreet  filho e consome muita cpu...(verificar abaixo e perguntar ao evandro ou xico)


Starting CDE
To start CDE, enter: 

/usr/dt/bin/dtconfig -e 
/etc/rc.dt;exit 


To stop CDE, enter: 
	 /usr/dt/bin/dtconfig -d


To reset CDE, enter: 
	 /usr/dt/bin/dtconfig - reset


To force a logout, enter: 
	ps -ef | grep dtsession kill -9 <pid>






---------------------------------------------------------
The percentage of available storage space is low (38.437693585510026 percent) . - Memria Real

The percentage of storage space **** is low (38.437693585510026 percent) . - File system                                                          

The percentage of swap space is low (38.437693585510026 percent) . - SWAP

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Adicionar Gateway no LInux

	- route add default gw <IP>

## Verificar status do servio que esta vinculado ao inetd.d

	- lssrc -l -s inetd

## faillog ( Linux ) 

	- Para ele comear a registrar; Adicionar no /etc/pam.d/system-auth a seguinte linha

		auth        required      //lib/security/$ISA/pam_tally.so onerr=fail no_magic_root

	- Apartir dai o comando : faillog -u <usuario>, ira funcionar


## Solaris - Start / Stop de servio

	- cd /etc/rc2.d

	- ./xxxxxxxx start/stop

## Identificar portas

	- netstat -pa

	- netstat -nap | grep <porta>

## Identificar io ( IO ) de disco

	- iostat aux 1 1

	- sar -d 1 1

## Alterar a hora no Linux ( Horario de Vero )

	1) Ir para o Diretorio /usr/share/zoneinfo/Brazil

	[root@lxlasa02 ~]# cd /usr/share/zoneinfo/Brazil
	[root@lxlasa02 Brazil]# ls -l
	total 48
	drwxr-xr-x   2 root root 4096 Nov 22 07:52 .
	drwxr-xr-x  21 root root 4096 Nov 22 07:52 ..
	-rw-r--r--   3 root root  226 Mar 17  2006 Acre
	-rw-r--r--   2 root root  276 Mar 17  2006 DeNoronha
	-rw-r--r--   2 root root  721 Mar 17  2006 East
	-rw-r--r--   2 root root  236 Mar 17  2006 West

	2) Editar o arquivo/Criar o arquivo (se no existir) 

	[root@lxlasa02 Brazil]# vi zic.verao
	Rule Brazil 2006    only     -       Oct    15   22:00   1       D
	Rule Brazil 2007    only     -       Feb    24   22:00   0       S

	Zone    Brazil/East             -3:00   Brazil          BR%sT
	~
	"zic.verao" [New] 4L, 197C written
	[root@lxlasa02 Brazil]# ls -l zic.verao
	-rw-r-----  1 root root 197 Feb 25 09:28 zic.verao
	
	3) Criar o arquivos East, com o comando zic:


	[root@lxlasa02 Brazil]# zic zic.verao
	[root@lxlasa02 Brazil]# ls -l
	total 48
	drwxr-xr-x   2 root root 4096 Feb 25 09:13 .
	drwxr-xr-x  21 root root 4096 Nov 22 07:52 ..
	-rw-r--r--   3 root root  226 Mar 17  2006 Acre
	-rw-r--r--   2 root root  276 Mar 17  2006 DeNoronha
	-rw-r-----   1 root root   80 Feb 25 09:13 East
	-rw-r--r--   2 root root  236 Mar 17  2006 West
	-rw-r-----   1 root root  197 Feb 25  2007 zic.verao

	4) verificar a data do sistema:

	[root@lxlasa02 Brazil]# date
	Sun Feb 25 09:13:32 BRT 2007


	5) Copiar o arquivo East para o /etc/localtime

	[root@lxlasa02 Brazil]# cp East /etc/localtime
	[root@lxlasa02 Brazil]# date
	Sun Feb 25 09:14:19 BRST 2007


	6) Fazer o sincronisto com o serivdor de ntp neste caso 52.31.152.205

	[root@lxlasa02 Brazil]# ntpdate 52.31.152.205
	25 Feb 09:15:53 ntpdate[24146]: step time server 52.31.152.205 offset 26.953700 sec


	7) checando novamente a data do serivdor:

	[root@lxlasa02 Brazil]# date
	Sun Feb 25 09:16:05 BRST 2007
	[root@lxlasa02 Brazil]# ls -l /etc/localtime
	-rw-r--r--  1 root root 80 Feb 25 09:14 /etc/localtime


## Gateway ( Linux ) 

	- route -n

## Verificar quantidade de disco em Solaris
	
	- format < /dev/null ( sem o Veritas )

	- vsdisplay ( com veritas )

	- format / escolher o disco / partition / print ( File system e parties embaixo do disco )

## Verificar processador em Solaris

	- psrinfo ( Quantidade de memria )

	- psrinfo -v ( clock de processador )

## Verificar quantidade de memoria em Solaris

	- prtconf |more

	- prtdiag

## Verificar Memoria,processador, disco ( HP-UX )

	- print_manifest |more

	- grep Phys /var/adm/syslog/syslog.log ( memoria )

	- echo physmem /D | adb /stand/vmunix /dev/kmem ( memoria )

## Verificar CPU ( processador ) memoria e system clock

	- prtdiag -v |more

## Testes de fibra e placa de fibra ( qlogic ) - Linux

	- /opt/QLogic_Corporation/SANsurferCLI/scli

	- opo 13 ( Diagnostics )

	- opo 1 ( Loopback Test )


## Verificar Memria, CPU etc

	- prtconf ( AIX )

	- dmidecode ( Linux ) 

	- dmidecode |grep -i cpu ( Linux )

	- dmesg |grep activated |more ( linux )

	- grep processor /proc/cpuinfo ( Linux )

	- cat /proc/cpuinfo ( Linux )

	- cat /proc/meminfo ( linux )

## Fitas DDS

	- 20Gb - DDS4

	- 12Gb - DDS3

	- < - DDS2

## Identificar Verso do LInux

	- cat /etc/*release

## Senha Redhat Pacotes

	- ibm_rhn / bigblue
 

## Criar file system ( Linux )

	- lvcreate -L 2500M <VG> -n <LV>

	- mke2fs -j /dev/<VG>/<LV> ( Formatar LV )

	- mkdir <ponto de montagem>

	- mount /dev/<VG>/<LV> <ponto de montagem>

## for i in

	- Exemplo : ( Apagar conteudo de /var/spool/mqueue )

		- for i in `ls -ltr |awk '{ print $9 }'`; do ( Apagara tudo )

		- for i in `ls -ltr |grep "May " |awk '{ print $9 }'`; do ( Apagara somente o mes de Maio )

		- echo $i ( rm $i )

		- done

## xargs

	- ls -ltr |grep "Feb " |awk '{print $9}' |xargs rm

		Removendo tudo do mes de Fevereiro ( Feb )


## Alterar hostname no Linux ( redhat )

	- hostname nomedesejado

	- vi /etc/rc.local ( adicionar a linha abaixo no final do arquivo, para o nome no mudar aps o boot )

	- /bin/./hostname nomedesejado

## Processos para TSM subir automatico ( inittab )
	
	- tsm0:3:respawn:/opt/tivoli/tsm/client/ba/bin/dsmc sched >/dev/console 2>&1 #Start the service schedule TSM Client
	- tsm1:3:respawn:/opt/tivoli/tsm/client/ba/bin/dsmc sched -optfile=/opt/tivoli/tsm/client/ba/bin/dsm_arch.opt >/dev/console 2>&
	1

## Nivel de firmware

	- lscfg -vl <adapter>

	- Verificar nivel na coluna (Z9)

	- uname -M ( modelo da maquina )

## Identifiar cluster

	- Localizar o arquivo "clfindres" 

	- executar arquivo para identificar quais maquina esto no cluster

## Backup - HP-UX

	- /var/opt/ignite/logs

		ou
	- /var/opt/ignite/recovery

## LSDEV

	- lsdev -Cc disk ( ver os discos )

	- lsdev -Cc tape ( fita )

	- lsdev -Cc if ( interface de rede )

	- lsdev -Cc adapter ( Adaptadores )

	- 

## banner ( AIX )

	- Ex : banner rodrigo

## Rotas

	- /etc/sysconfig/network/routes ( Suse )

	- netstat -rn ( verificar rotas )

## DUMP

	- sysdumpdev -l ( Verificar status/configurao )

	- sysdumpdev -K ( Alterar o parametro always allow dump , que gera o dump quando ocorre reboot inesperado )


## Aplicar firmware no switch

	- Download do firmware 

	- FTP do firmware para uma maquina qualquer

	- Logar no switch

	- Digitar : firmwareDownload

		As telas abaixo seguir :

		hosan005bng:admin> firmwareDownload
		Server Name or IP Address: 10.176.12.23
		FTP User Name: rgalvao
		File Name: /home/rgalvao/baan/sw/v5.1.1a/release.plist
		FTP Password:
		You can run firmwaredownloadstatus to get the status
		of this command.

		This command will cause the switch to reset and will
		require that existing telnet, secure telnet or SSH
		sessions be restarted.

		Do you want to continue [Y]: y
		Firmware is being downloaded to the switch. This step may take up to 30 minutes.
		Checking system settings for firmwaredownload...
		Start to install packages...

## Criar espelhamento (paging tbm)
 
	- mklvcopy -k <nomedolv> <quantidade>

## Perdigo ( Abre fila )

	- Quando cliente reclamar de filas de relatrio paradas

	- Servidor : DEVUXRH

	- No caminho : /prd/rh/ex , existe o arquivo "abre"

	- Basta digitar no prompt de comando : abre

	- Ira aparecer algo como : 

			devuxrh/prd/rh/ex# abre

			Sending output to nohup.out
			Sending output to nohup.out
			Sending output to nohup.out
			Sending output to nohup.out
			Sending output to nohup.out
			Sending output to nohup.out
			Sending output to nohup.out
			Sending output to nohup.out 
			atn: Fila rh ja' esta' Aberta !!! 
			atn: Fila rh2 ja' esta' Aberta !!!
			Sending output to nohup.out
			Sending output to nohup.out
			devuxrh/prd/rh/ex# Sending output to nohup.out

	- OK, fila liberada !!!!

## Requisio Carrefour
	
	- Logar via Remote Desktop Connection ( Iniciar/acessorios/communications )

	- IP ( ux14 ) 10.105.185.50 / senha ( bribm133/icanlive2006 )

	- Efetuar FTP do UX14 para uma pasta do Windows

	- Disponibilizar no caminho solicitado

## Verificar disco usado no boot

	- bootlist -m normal -o

## Problemas com e-mail ( sendmail )
 
	Pela descrio do problema, acredito que o AIX e o sendmail esto tendo alguma dificuldade para enviar mensagens e por isso, os mails ficampresos na fila e, todos estes arquivos temporrios so gerados. Aprincpio, sugiro que a fila seja processada:

	1 - Verifique a quantidade de arquivos no diretrio /var/spoo/mqueue: 

		# ls | wc -l

	2 - Execute os comandos abaixo para verificar e processar a fila:

		# mailq -v

		# /usr/sbin/sendmail -q -v

	3 - Verifique se a quantidade de arquivos  a mesma:
	
		# ls | wc -l...

		Uma hiptese para a causa do problema  o daemon sendmail ter sido startado 
	de forma incorreta ou com um tempo de processamento de queue muito grande. 
		Ao dar start ,sempre definimos o tempo em que a fila deve ser processada.
		 No caso de start automatico (no boot), o tempo de processamento da fila  
	definido no arquivo /etc/rc.tcpip, no parmetro qpi. 
		O daemon foi startado ou restartado manualmente nestes ultimos dias? 
	Caso sim, podemos fazer uma tentativa de start e stop, de acordocom o procedimento abaixo:

		# stopsrc -s sendmail

		# startsrc -s sendmail -a "-bd -q15"

	ou





		# /usr/lib/sendmail -bd -q15 

	4 - Para acertar problemas de permisso.

		# chmod 777 /var/spool/mail

		# chmod +t /var/spool/mail

		# ls -ld /var/spool/mail
	   	drwxrwxrwt   2 bin      mail            256 Feb 19 09:08 /var/spool/mail

		# cd /var/spool/mail

		# ls
	   	1                 mmcnanny          pvonbarg          wberrettlocal-host-names  psmith            root

		# date |mail -v root
	  	root... Connecting to local...root... Sent


## Aplicar ML

	- Entrar no diretrio onde esto as ML's

	- smitty update_all

	- Digitar "." ( pois estamos no diretrio de onde o sistema ira pegar as atualizaes )

	- Commit Software Update - NO

	- Accept new license agreements - YES

	- Enter

	- Comando para verificar se ML foram aplicadas ( instfix -i |grep ML )

## Verificar quantidade de arquivos no diretrio

	- ls |wc -l

## Rotas Bunge ( todos os servidores Bunge )

	- entrar no caminho /scripts/netperf/

	- executar o comando netperf 

		Ex: ./netperf -H <servidor_destino>

		Executar indo e voltando, ou seja, executar nos 2 servidores o mesmo comando

	- Caso o netperf no esteja ativo executar o ./netserver

## LPAR

	- prtconf | more ( Identifica se a maquina  uma regata, atravs do Processor Type < PowerPC_POWER4 / PowerPC_POWER5 > )

	- lparstat -i ( identifica se  uma partio de regata ou no )

		Ex Particionado : 

			root@brsvpux28:/> lparstat -i
			Node Name                                  : brspvux28
			Partition Name                             : BRSVPUX28
			Partition Number                           : 7

		EX No Particionado : 

			root@HODB506VR/> lparstat -i
			Node Name                                  : HODB506VR
			Partition Name                             : - ou serial da maquina
			Partition Number                           : -

## Setar maquina de 32 para 64 bits

	- prtconf -k ( Identifica tipo de Kernel , 64 ou 32 bits )

	- prtconf -c ( Identifica tipo de CPU , 64 ou 32 bits )	

	- ln -sf /usr/lib/boot/unix_64 /unix

	- ln -sf /usr/lib/boot/unix_64 /usr/lib/boot/unix

	- bosboot -ad /dev/ipldevice

	- shutdown -Fr



## Verificar se disco esta espelhado

	- lsvg -l <vg>

## Modulo modgest

	- subir para modgest ( su - modgest )

	- desativar o modulo ( /home53/nr/bin/modgest/desativa_modgest )

	- Aguardar uns 30 segundos at sumir todos processo relacionados ( ps -fu modgest )

	- reativar o modulo ( /home53/nr/bin/modgest/ativa_modgest )


	

## HP-UX ( Impressora )

	- atn ls ( listar arquivos na fila )

	

## Utilizao do SHARK TotalStorage Solutions ( ESS Specialist )

	- https://158.98.178.198/specialist

		administrator / password

	- Storage Allocation

	- open System Storage

	- Modify Volume Assignments

	- Marcar o disco a ser assinado

	- Clicar em ASSIGN SELECTED VOLUMES TO TARGET HOSTS

	- Do lado direito escolher a qual servidor o disco vai ser alocado

	- Clicar em " Perfom Configuration Update

		No servidor

	- cfgmgr ( para reconhecer o novo disco )

	- extendvg <nomedovg> <disco>
	
	- chfs -a <tamanho> <filesystem>

## Ajustar monitor pela metade no HP-UX

	- resize

## File system /USR

	- Verificar se existem arquivos antigos de ML ( commit )

	- smitty

	- Software Installation and Maintenance

	- Software Maintenance and Utilities

	- Commit Applied Software Updates (Remove Saved Files)

	- PREVIEW only? (commit operation will NOT occur) - ( colocar em yes ) - Para o sistema verificar se existe arquivos a serem comitados

	- Caso exista arquivos :

		- Voltar esse parametro para "NO" - PREVIEW only? (commit operation will NOT occur)
	
	- Provavelmente o /usr ja reduz o tamanho

## Raid 

	- cat /proc/mdstat

	- lsraid -p ( Verificando o status do RAID )

## Configurar mensagens ao logar no server

	- /etc/motd

## Enviar e-mail

	- mail -s "subject" <endereo> - Ex : mail -s "teste" rgalvao@br.ibm.com <enter>
 
	- cat /etc/passwd|mailx levyas@br.ibm.com ( exemplo de enviar arquivo do AIX para e-mail )

	- Digitar corpo do e-mail <enter>

	- CTRL + D 

## rpm 	

	- rpm -qf arquivo( verificar a qual pacote pertence um arquivo )

	- rpm -ql pacote ( Verificar quais arquivos fazer parte de um pacote


## Linha do TSM ( Para subir automtico aps o boot )

	- Inserir no /etc/inittab a seguinte linha : 	

		#Servico TSM Scheduler
		tsm:3:respawn:/opt/tivoli/tsm/client/ba/bin/dsmc sched -optfile=/opt/tivoli/tsm/client/ba/bin/dsm.opt

## Adicionar rota no linux

	- route add -net 126.0.49.0 netmask 255.255.255.0 gw 10.28.146.43

# WWPN - Verificar numero da fibra

	- datapath query wwpn

## Informaes da maquina como : processador,memoria etc...

	- prtdiag -v

## Criar uma copia de uma estrutura atravs do TAR ( onde copia.tar,  o arquivo gerado )

	- Dentro do diretorio executar o seguinte comando

		- tar -cvf copia.tar *

		- Compactar atravs do ZIP o arquivo gerado

	- Enviar para outro servidor 

		- scp copia.tar.gz apizarro@10.124.85.201:/tmp

	- Extrair os arquivos do TAR

		- tar xvf copia.tar 

## ConfigRM ( Servio que roda continuamente para verificao, atravs do DIAG , para mostrar o status do cluster )

	- lssrc -ls IBM.ConfigRM ( Verifica detalhe no servio )	

	- lsrpnode -i ( Verificada o status do cluster )

## Migrar disco ( TVA )

	- lscfg -vl hdiskxxx

		Verificar o Serial do disco para checar no Storage Manager 

	- rmdev -dl hdiskxxx

		Remover antes de desassociar do storage 

## Montar NFS 

	- Verificar no arquivo /etc/exports se o diretorio esta com permisso para export. Caso no esteja, inserir e dar o comando : exportfs -a

	- Verificar se no servidor de origem o NFS esta ativo

	- Linux - Digitar o comando na maquina de destino :  mount -t nfs <IP_origem> :<caminho_origem> <caminho_destino> ( Linux )

		( No linux para o NFS subir automatico no boot aplicar a linha no /etc/fstab : Segue exemplo - <IP_Origem>:<Diretorio_origem> <ponto_de_montegem destino> nfs     defaults        0 0 )

	- AIX - Digitar comando na maquina de destino : mount <IP_origem> :/home/elucid/ue /elucid/celpafn ( AIX )


## Alterar IP no LINUX 

	- ifconfig eth0 <ip> netmask <mascara> 

	- Local onde a alterao tambm pode ser feito ( /etc/sysconfig/network-scripts/ifcfg-ethxxx )

## Alterar senha sem que tenha que trocar no primeiro logon

	- Alterar senha do usuario

	- Executar o comando : pwdadm -c ncverdi 

## Aumento de file system - Linux Rehhat

	- Verificar se existe o comando ext2online ( Ira aparecer algo parecido com ext2online v1.1.18 - 2001/03/18 for EXT2FS 0.5b )

	- Verificar se existe espao no VG atravs do comando - vgdisplay

	- vgdisplay -v |grep "rootvg" ( para identificar qual o caminho do VG )

	- lvextend -L +tamanhoM lv ( Exemplo - lvextend -L +200M /dev/nwsbrvg/nwsbrlv ) 	lvextend -L +20M /dev/rootvg/scmlv	ext2online /dev/rootvg/scmlv

	- Executar o extend on line - ext2online /dev/nwsbrvg/nwsbrlv

## Aumento de file system - HP-UX

	- HPUX AUMENTAR FS TIPO VXFS    

	- Verificar o tipo do FS #fstyp /dev/sp_sapdb_vg/oracle_PRO_sapdata09

	- Para mudar o lvol para 54Gb (54 * 1024 = 55296) (tamanho final do lvol independente de quanto tinha)#lvextend -L 55296 /dev/sp_sapdb_vg/oracle_PRO_sapdata09

	- Para Visualisar se aumentou corretamente# lvdisplay -v /dev/sp_sapdb_vg/oracle_PRO_sapdata09 | grep "Mbytes"LV Size (Mbytes) 55296

	- Para aumentar o FS tipo vxfs para 54Gb (54 * 1024 * 1024 = 56623104)#fsadm -F vxfs -b 56623104 /oracle/PRO/sapdata9
 

## Aumento de file system - Solaris ( com SOLARIS VOLUME MANAGER (DISK SUITE) )

	- metastat ( para identificar se existe DISK SUITE ) 

	- Ex de file system antes do aumento : /dev/md/dsk/d110     9929785 9794260   36228   100%    /u06
	
	- metattach d110 2g ( comando para aumentar 2Gb )

	- growfs -M /u06 /dev/md/rdsk/d110

	- Ex de file system aps aumento : /dev/md/dsk/d110     11995112 9796308 2099507    83%    /u06

## Daemon DOWN

	- chkconfig --list ( Checar configurao de Daemon )

	- cat /etc/inittab |grep default ( Verificar qual rc. esta para subir automaticamente - initdefault )

	- chkconfig snmpd on ( Colocar para daemon subir automaticamente )

## Verficar se existe servidor NTP 

	- grep /etc/ntp.conf

## verificao de Servios Redhat / SUse

	- chkconfig --list

## Verificar limite definido para determinado usuario

	- ulimit -a <user>

	- Para setar tamanho de criao de arquivos ilimitados :
		
		- Smitty user

		- entrar na configurao do usuario

		- Setar - Soft FILE size  = -1 

## Fazer o start do Patrol ( Carrefour )

	- su - patrol

	- cd /opt/bmc/Patrol3/

	- ./PatrolAgent -p 3181

## Menus de SO

	- yast ( Linux - Suse)

	- sam ( HP-UX ) 

	- smitty ( AIX )

## Alterar horario de servidor

	- date <mes/dia/hora/minuto>

## Verificar erro no sistema

	- fsck -n "/opt"

## Linha do TSM Sched adicionada no AIX ou Linux

	Linux ( Suse )
		- cd /etc/rc.d
		- who -r ( Inserir dentro do nivel que aparecer )
		- touch "nome_do_arquivo" (Criar arquivo)
		- vi "nome_do_arquivo"
		- Inserir a linha desejada dentro do arquivo
		- Entrar dentro do nivel desejado (ex: rc3.d ) e criar um link : ln -s ../"nome_do_arquivo" "nome_do_link"
		

	- tsmsched:2:respawn:/usr/tivoli/tsm/client/ba/bin/dsmc sched > /dev/null 2>&1 #TSM autostart

## Migrar paginao de um disco pro outro

	- migratepv -l hd6 hdisk1 hdisk0

	- reducevg rootvg hdisk1

	- extendvg rootvg hdiskX

	- extendvg4vp rootvg vpathX 

## Fibra ( fsci2 )		

	- Quando erro for na fibra 2 ( que no vai para disco ) fazer o seguinte : 

		- lsdev -Cc adapter ( pegar o microcdigo - fcs2 Available 0C-08 FC Adapter - e digitar o seguinte comando )

		- lsdev -C |grep 0C-08 ( 0C-08 -  o microcdigo conseguido atravs do comando acima )		

## Configurao NTPD

	- Verificar no /etc/ntp.conf se existe servidor associado para verificao de hora

## Desbloquear usuario travado por tentativas erradas de senha - Linux

	- faillog -u <user>

	- faillog -u <user> -r 

## Verificar se o servio esta para subir automatico quando cair

	- chkconfig --list

	- chkconfig --list <servio> - lista a condio do servio

	- chkconfig <servio> on - Deixar o servio com start automatico

## Quando a configurao da tela no Putty estiver "embaralhada"

	- export TERM=vt100

## Verificar se o file system esta em uso por algum processo/user

	- fuser -u <pontodemontagem> <filesystem>

		ex : fuser -u /dev/md/dsk/d5  /oracle

## Verificar configurao ( nivel ) de fibra 

	- lscfg -vl < fcs0 >

## Analise de possvel reboot ( Linux )
	
	- last

	- more /var/log/messages

more /var/log/messages |grep restart

## Menu para matar usuarios

	- menuti

## Montar file system ( NFS ) no servidor hoas010dts.( script a ser rodado quando ocorrer erro de mapeamento de Samba )

	- /home/adm_datasul/mount_fs_hoas009dts.sh

## Swap - HP-UX

	- ps -el | sort -n +9 | tail -50 | pg 

## Comando para verificar processos que esto utilizando determinado file system

	- lsof <file system>

##  Comando para ver especificaes do device ( rmt0 , ent0 , etc...)

	- lscfg -vpl <rmt0>

## Comando para Solaris


	- iostat -en ( Lista discos e status do disco )

	- iostat -En ( Mostra configurao do disco entre elas , n de srie )

	- /usr/platform/sun4u/sbin/prtdiag -v ( Mostra status da mquina : CPU / Memria / Disco )

	Ele tem discos internos de fibra interno alarmando errors (c0t6d0)

## Para gerar o explorer:

	- /opt/SUNWexplo/bin/explorer

	a saida fica em:

	- /opt/SUNWexplo/output


## Listar status do processo

	- lssrc -g <nfs>

	- lsrc -s <snmpd>

## vi - copiar linha e colar inteira

	- yyp

## Verso do SO ( AIX )

	- oslevel -r ( Verso do Sistema operacional )
	- uname -M ( Modelo do servidor )

## Arquivos .dcl OPTIO ( Multibras ) SAP ( ZHMP0A01 / zhmq2dci )

	- Pegar arquivo zipado que cliente enviou e extrair na minha mquina
	- Enviar via Winscp para o servidor ( normalmente o zhmq2dci )


## Caminho do OPTIO ( Multibras )

	- /usr/optio/eci77/doc
	- eiconfig ( para entrar no programa do OPTIO )

## Verificar tentativas de logon ( AIX )
	
	Verificar o item :  unsuccessful_login_count=0 
	- lsuser <nomedo usuario>
	
# Verificar compilador C

	- cc ( enter )
		ou
	- lslpp -l | grep -i vac

	- cc teste.c -o teste ( fazer teste se esta funcionando )

# Verificar quantidade de processos por usuario


	- lsattr -El sys0 | grep maxuproc
	- ps aux |grep <usuario> |wc -l ( verifica quantos processos esta sendo usado pelo usuario

# Erro de dump
	- sysdumpdev -l ( verificar onde esta sendo jogado o dump. Primario )
	
	- sysdumpdev -e ( verifica o tamanho da area de dump )

	- sysdumpdev -P -p /dev/lvdump ( mudar rea primaria de dump )

	- criar lv para dump.

# Processos Solaris

	- cd /etc/init.d ( Processos ficam dentro deste diretrio )

# Start no processo Patrol

	- cd /etc/rc3.d ( ou rc2.d)
	- ./S91Patrol

## Fazer FTP

	- ftp localhost ( com usuario solicitante )

	Enviar arquivo da minha maquina para servidor qualquer

		- Logar-se no DOS

		- Entrar no diretrio de origem do arquivo a ser transferido

		- Digitar : ftp

		- Digitar : open <IP_de_destino>

		- Digitar : pwd ( para saber o local onde esta no servidor )

		- Digitar : put ou mput <arquivo a ser transferido>


	Trazer pra minha maquina arquivo de um determinado servidor

		
		- Logar-se no DOS

		- Entrar no diretrio de origem do arquivo a ser transferido

		- Digitar : ftp

		- Digitar : open <IP_de_destino>

		- Digitar : pwd ( para saber o local onde esta no servidor )

		- Digitar : get ou mget <arquivo a ser transferido>

## Caminho de configuarao de rede para Linux Redhat

	- /etc/sysconfig/network-scripts
	- ifcfg-eth<0,1..>	

## Copiando via scp

	- scp <arquivoasercopiado> rgalvao@<servidor><diretorio>

## Alertando Solaris_Msgs/Correct_Mem_Err/Msg_Status

	- ?

## Linha de comando para adicionar usuario em servidores LINUX

	- useradd -g users -G wheel,so -u <user> -c 'Diego Guaris;42688;100' <user> ; echo <senha> | passwd --stdin <user>

## Fazer um disco ficar piscando na torre SSA

	- smit dev
	- ssa disks
	- ssa physical disks
	- Identify an SSA Physical Disk
	- ( escolher o disco e mandar piscar )

## Startar JACCLIENT

	- Diretrios onde esta JACCLIENT
	- /amb/usr/local
 	- /opt/IBM/SCM 

	- ./jacclient stop ( parar JACCLIENT )

	- ./jacclient start ( startar JACCLIENT )

	- /opt/IBM/SCM/client/jacclient ( start|stop|restart|status|version )

		Ex : /opt/IBM/SCM/client/jacclient restart

## Criar raw device

	- smitty
	- System Storage Management ( Physical & Logical Storage )
	- Logical Volume Manager
	- Logical Volume
	- Add Logical Volume
	- esc 4 ( escolher VG )
	- colocar logical volume name / Number of Logical Partitions
	- Entrar em /dev e alterar o owner conforme solicitao

## Verificar modelo da mquina e nveis de ml etc...

	- prtconf |more
	- oslevel -r

##  Verificar shared memory, semaforo, message queues

	- ipcs -a
	- ipcrm - <numero>

## Fitas - Resaponsveis

	- rmt0 Available 04-B0-00-5,0 4.0 GB 4mm Tape Drive - UNIX
	- rmt3 Available 10-88-00-3,0 IBM 3580 Ultrium Tape Drive - STORAGE




## Gerar SNAP

	- snap -r ( apaga snap antigo )

	- snap -gc ( gerar novo snap )

## Verificar rootvg

	- smitty chvg

## Limpar fila de impresso

	- lpstat -v<nomedafila>

## Alterar configurao da placa de rede - Duplex=Full
	
	-  mii-tool -F 100baseTx-FD <eth4>
	-  ethtool -s eth1 speed 100 duplex full

## Fila de impresso

	- dentro do /etc
	- lpstat<nomedafila>
	- ( se a fila estiver down !!! )
	- enable <nomedafila>

## Adicionando disco no shark

	- Aps adicionar o disco fisicamente no shark fazer o seguinte procedimento
	- cfgmgr ( para o sistema reconhecer tudo que foi adicionado de novo na mquina )
	- extendvg <nomedovg> <disco>
	- chfs -a <tamanho> <filesystem>

## Verificar configuraes das placas de rede

	- ethtool "nomedainterface"

## Verificar se mquina esta down

	- ovtopodump "nomedamquina"

## File System /amb/opt - AMBEV

	- cd /amb;operador
	- find . -name fs_clean.sh -type f
	-./bin/fs_clean.sh /amb/log
	- find /usr -xdev -size +1024 | xargs ls -l|more


##Criao de impressora no PROMAX - Ambev ( Host Down - Problema na localidade )

	- Servidor ACSXP6 ( sempre )
	- cd printers/config
	- cp -p qconfig.all qconfig.all."data do dia" ( copiar o arquivo qconfig.all )
	- vi qconfig.all
	- copiar um arquivo com o mesmo compartilhamento
	- Fazer as alteraes conforme solicitado
	- "shift ZZ" ( sair e salvar
	- cd printers/scripts
	- ./upd_qconfig.sh
	- lpstat -v"nome da fila" ( sem espao entre o -v e o nome da fila )
	- ./criaflag_qconfig.sh
	- ./criaflag_hosts.sh

		
## Startar Sendmail

	- startsrc -s sendmail -a "-bd -q30m"

##  Editar Crontab

	- crontab -e ( abre para edio )

	-
## /var/tmp/snmpd.log ( cheio ) - IBMinfr

	- stopsrc -s snmpd
	- > snmpd.log ( dentro do diretrio )		
	- startsrc -s snmpd

## Wait State

	psaux |more

## BKB -    SOLARIS_MSGS \ TRANPORT_FAIL \ MSG_STATUS e MENSAGEM
	   SOLARIS_MSGS \ ERRO_GRAVAO \ MSG_STATUS e MENSAGEM
	   SOLARIS_MSGS \ ERRO_FATAL \ MSG_STATUS e MENSAGEM

	- tail /var/adm/messages ( para ver as mensagens )
	- vxdg list ( listar os dg da mquina )
	- vxprint -g rootdg -ht | more ( verifica as condies do disco , se esta enabled ou no )

##  Netview ( monitora interfaces de rede )

##  FTP

	- /etc/inetd.conf
	- vi inetd.conf ( verificar se o FTP no esta comentado )
	- ftp localhost ( para ver se o FTP esta ativo na mquina )

	Se no estiver fazer o seguinte procedimento

	- stopsrc -s inetd.conf
	- entrar em /etc/inetd.conf
	- descomentar a linha referente ao ftp
	- sair e salvar
	- startsrc -s inetd.conf

	Tentar novamente acesso via ftp
 

## ls -la " caminho  " - mostra nome do usuario

	Ex : ls -la /oraoas/904/j2ee/home/core
	-rw-r--r--   1 oraoas   oinstall  341126771 Jun 16 16:48 /oraoas/904/j2ee/home/core

	grep "usuario" /etc/passwd - mostra o nome do responsavel pelo eth


## Para reduzir arquivo com .gzip ( onde " "  o nome do arquivo a ser zipado )

	gzip -c "maillog" > /tmp/"maillog20060708".gz;>"maillog"; mv /tmp/"maillog20060708".gz .

## Alterar IP da impressora

	- /etc/hosts
	- vi hosts
	-  /"nome da impressora" ( para localizar impressora )
	- i ( para editar )
	- esc:wq ( para sair e salvar )
	- lpstat -p"nome da impressora" 

## SOLARIS -  /usr/ucb/ps aux |more

	- Verificar processos que mais esto ocupando CPU

## Retirar uma rota no AIX

	- halt delete "ip" gateway

##stopsrv -s "nome do processo"

	- parar processo

## startsrc -s "nome do processo"

	- startar processo

## chmod ( permisso )

	- Entrar no diretrio e verificar permisses atravs do comando ls -la 
	- 666 - dar permisso de escrita e leitura a todos os usuarios
	- 777 - dar permisso de tudo a todos osF usuarios

## Editar crontab :

	- crontab -l ( lista os crontab )
	- cronatb -e  ( editar crontab )
	- :wq ( sair e salvar )



## Verificar pdisk

	- ssaxlate -l pdisk14 ( descobrir qual disco esta alocado o pdisk )
	- lspv ( Verificar qual vg esta alocado o disk )
	- lsvg -l <nome do vg>
	- lsvg -p <nome do vg>

## /var cheio - LINUX

	- /var/adm/backup/rpmdb ( apagar .gz )
	- /var/lib/YaST2/you/i386/update/SuSE-SLES/8/rpm/i586 ( apagar conteudo .rpm ) rm -f *.rpm ( dentro do diretrio )
	- rpm -e "pacote" - remove pacote
	- rpm -i pacote - instala um pacote
	- rpm -qa - pesquisa um pacote instado

## Verificar Disco ( disk )

	- datapath query essmap | awk '{ print $1,$2,$5,$8 }' | sort -u
	- datapath query essmap 
	- datapath query device
	- datapath query adapter
	- lsvpcfg |grep hdisk...
	- lsattr -El  < hdisk111 >
	- lspv |grep <hdisk7>
	- dd if=/dev/hdisk0 of=/dev/null bs=10k ( testa a leitura do disco )

## Verificar se Interface esta Up / Down

	- ethtool <interface>
	- ifconfig -a
	- netstat -v "nome da interface"
	- netstat -in ( lista as interfaces UP )
	- lsdev -Cc if ( lista interfaces lgicas )
	- lsdev -C |grep ent ( lista quantas e quais placas de rede existem na mquina )
	- entstat -d "ent3" - lista status da placa
	- lanscan - HP-UX
	- netstat -in ( HP-UX )

## jogar errpt para dentro de algum caminho

	EX : errpt -a> /so_ibm/errpt/errpt_a20060620.out ( copia errpt para dentro de /so_ibm/errpt/errpt_a20060620.out )

## Limpar error log

	errclear 0
	
## Impressora ( alterao / cadastro )

	cd /home/printers
	ls -ltr
	cp qconfig.all qconfig.all "17062006" - criar uma cpia do arquivoa para que no haja problema
	vi qconfig.all
		alterar para nova configurao fornecida
	esc : w q ( sair e salvar alteraes )
	./ upd_qconfig.sh ( executar script para atualizao dos servidores do ambiente )
	

## Fibra ( Discos )

	- pcmpath query device 	

	- datapath query device  - verifica estado das fibras

	- datapath query adapter - verifica saude da fibra

	- lsdev -Cc disk - dispositivos para discos )

	- lsvpcfg |grep hdisk...

## du -ks * | sort -n - dentro do diretrio 

	 verifica quem esta ocupando maior espao no diretrio

## ls -l | wc -l

	quantidade de arquivos


##  HSWV5802E Connection to ESS 082-18751 at cluster 172.31.1.4 was unsuccessful for task PDCT-2 with Reference ID 4850. na. - 15

	Avisar prime da conta. Erro de comunicao entre fibra e link.

## reas de pagging - PctTotalPageSpace PageSpace 85

	lsps -a - verificar os paging spaceFtask

	lsps -s - porcentagem sendo usada de paging

	smit pgsp / activate paging - ativar paging

	chps -ay paging05 - ativar paging quando o sistema for reiniciado


	lsvg ( verificar quantidade de vg na mquina )
	lsvg rootvg ( verificar configurao do vg )
	lsattr -El mem0 ( ver quantidade de memria na mquina )

	smit pgsp - aumentar o VG 
		Change / Show Characteristics of a Paging Space
		escolha o hd
		NUMBER of additional logical partitions 

		criar rea de paging	
		Smit pgsp
		Add Another Paging Space



## MEMORY \ MEMPageOut = 0 Pages

	# Verificar se memria esta paginando atravs do comando vmstat 2 10 ( verificar SI e SO )
	
	r       b          swpd            free           buff            cache                     si        so       bi       bo       in        cs      us     sy      wa      id
                     0       0            0               17964     243608     1035416                   0         0        2         1        0          1       0      0         0       0
                     0       0            0               17960     243608     1035416                   0         0        0          0     189      26      0      0         0     100
 	0       0            0               17960     243608     1035416                   0         0        0         24    192      35      0      0        1      99
                      0       0           0               17960     243608     1035416                   0         0        0         0      189      36      0      0         0     100
 	0        0           0               17960     243608     1035416                   0         0        0        42     192      38     0       0        2      98
 	0        0           0               17960     243608     1035416                    0        0        0         0       187     25     0       0        0      10


## Localizao do .log do TSM

	/opt/tivoli/tsm/client/ba/bin 

## Compactar arquivos

	gzip file  - Compactar arquivos

## Para ver que hora a mquina foi rebootada

	- last

## The percentage of processor time is low

	Verificar os processos rodando na mquina e consumindo CPU

	# ps -ef | grep "usuario" - mostra todos os processos do usuario	

	# ps aux |more
	
	# top ou topas   +  shift P pra ordenar por ordem de consumo
	Verificar se o processo ovw_binary est rodando, ele  referente ao netview.
	Se sim, ligar no ramal do responsvel e pedir pro mesmo fechar a tela, matar o processo no servidor e pedir pra abrir o programa novamente
	
	
	Tambm verificar com vmstat

	# vmstat 2 10

	# for i in `ps -ef |grep root |grep -v grep |awk '{print $2}'|tail -20`; do ps -ef |grep $i |grep -v grep; done

	# no HP UX ==> # glance

## Para listar dentro de um diretrio quem mais est ocupando espao

	# du -ks * | sort -n
	# fuser -uc <arquivo>  -----> verifica o pid de quem ta criando o arquivo
	# du -k .  ---> mostra o tamanho em disco

## Para verificar usurios associados ao diretrio ou file system

	# fuser -uxc <diretrio ou file system>

## Para verificar se a impressora est ativa

	# lpstat -p<nome>

## Verificar se o spooler est operante, se no estiver dar um startsrc

	# lssrc -g spooler
	# startsrc -g spooler

## Para startar a impressora

	# enable <nome_da_fila>
	# /usr/bin/enable <nome da fila >

## Para limpar fila de impresso

	# lpstat -v<nomedafila>
	# cancel <numero do job>   ===> apagar um por vez
	# enq -X -P<nome_da_fila> ===> apaga tudo

## Para imprimir um teste

	# lpr -Pprinter <file>

## Para cadastrar uma impressora ou conferir configurao

	# /etc/qconfig
	# /etc/hosts

	Para cadastrar: Editar o /etc/hosts e colocar o ip e nome da fila.
	Editar o /etc/qconfig e colocar na ultima linha as configuraoes abaixo, mudando apenas o nome da fila:
		

ZDF1:
        device = @ZDF1
        up = TRUE
        host = ZDF1
        s_statfilter = /usr/lib/lpd/aixshort
        l_statfilter = /usr/lib/lpd/aixlong
        rq = ZDF1
@ZDF1:
        backend = /usr/lib/lpd/rembak

	Pra finalizar dar o comando lpstat -pZDF1 para checar.

## XNTPD id down (been killed)

	# lssrc -s xntpd
	# startsrc -s xntpd

## storage space is low

	# topas ou top e verificar utilizacao de memoria
	# svmon -G
	# lsps -s  ou  free no linux

## Para aumentar File System

	# lslv "nome do arquivo " (sem o / dev )	
	# lsvg " volume group "
	# df -k  ---> para ver o file system
	# lsvg -l <vg>

## 'ERRPT alert of type PERM from class SOFTWARE is detected: FAA1D46F PERM SOFTWARE SYSPROC SOFTWARE PROGRAM ABNORMALLY TERMINATED dbsnmp

	# errpt |more
	# errpt -aj <numero_do_erro>
	# errpt -a |more
	# find / -name dbsnmp

	Para zerar o errpt, criar um backup do mesmo no exemplo abaixo:
	<acsxs7>, root, / # errpt -a > errpt.150506.log
	<acsxs7>, root, / # errclear 0

## Fibra

	Quando tiver erro no formato fscsi2,  referente a fibra.

	root@zhmq2dci />errpt |more
	IDENTIFIER TIMESTAMP  T C RESOURCE_NAME  DESCRIPTION
	B8FBD189   0308012506 T S fscsi2         SOFTWARE PROGRAM ERROR

	root@zhmq2dci />datapath query adapter

	Active Adapters :2

	Adpt#     Name   State     Mode             Select     Errors  Paths  Active
    	0   fscsi1  NORMAL   ACTIVE         1096084594          0     38      38
    	1   fscsi0  NORMAL   ACTIVE         1096324126          0     38      38
	root@zhmq2dci />

	# datapath query device | grep -i closed  ==> verifica se existe alguma conexo de fibra down
	


## Quais processos tem dentro de detrminado arquivo

	# fuser -uc /work ( /work  o arquivo )

## The process ovw (pid 181182.0) is using excessive amounts

	# Entrar em contato com a monitorao (4011) e pedir pra fechar o ovw (netview) e startar novamente.
	# matar o processo do ovw



## Verificar se backup terminou OK

	- Smitty 
	- System Storage Management
	- System Backup manager
	- List Files in a System Image
	- esc 4
	- Selecionar a fita de backup
	- Enter

## Para voltar fita de backup

	# mt -f /dev/rmt0 rewind
	# lscfg -vl <rmt0> ( mostra detalhes da unidade de fita )
	# diag -c -d rmt1 ( Fora a retirada da fita )
	# mt -f /dev/st0 status
	# mt -t /dev/rmt/0m status

## Para verificar o status do backup  ( % )

	- tail /logbackup/scripts/backupsharedvg.log

## Para startar o backup image

	# echo "/usr/bin/backtape" | at now  ===> /user/bin/backtape  o local do script, verificar na crontab ( starta o backup )
	# tail -f /tmp/backup_image.log ( acompanha o status )

	* Na Degussa  pelo TSM
	# dsmc
	tsm> q sched

## Reflection - Liberao de Usurio.

	# verificar conexes do usurio: who -u |grep <usuario>
	# caso esteja ok, e o problema for dentro da aplicao, como LP, repassar para a fila SIRMGR. a Accenture  responsavel pelo sistema.

## HODB001FPI-THE PAGE-IN RATE

	BSF: The system is thrashing.  The page-in rate (6.070281216E9 pages per 
	second) and page-out rate (2.3021258752E10 pages per second) are both high.                                                                    

	Verificar a paginao de swap in e out. O normal  estar + ou - abaixo de 2.

	# free  ==> para verifcar memria livre e swap
	

	hodb001fpi:~ # free
             total       used       free     shared    buffers     cached
	Mem:        514504     508276       6228          0      55536     294600
	-/+ buffers/cache:     158140     356364
	Swap:       215896     142120      73776
	

	hodb001fpi:~ # vmstat 2 10
	procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
	 r  b   swpd   free   buff  cache   	si   so    bi    bo   in    cs us sy id wa
 	0  0 142120   6208  55552 294600    0    0     2     2    0     0  1  0 99  0
 	0  0 142120   6204  55552 294600    0    0     0     0    0   136  0  0 100  0
 	1  0 142120   6204  55552 294600    0    0     0     0    0   196  0  0 100  0
	 0  0 142120   6188  55568 294600    0    0     0    16    0   174  0  0 100  0
 	0  0 142120   6188  55568 294600    0    0     0     0    0   174  0  0 100  0
	 0  0 142120   6188  55568 294600    0    0     0     0    0   155  0  0 100  0
 	0  0 142120   6188  55568 294600    0    0     0     0    0   147  0  0 100  0
 	0  0 142120   6188  55568 294600    0    0     0     0    0   204  0  0 100  0
	 0  0 142120   6188  55568 294600    0    0     0     0    0   176  0  0 100  0
	 0  0 142120   6172  55580 294600    0    0     0     8    0   226  0  0 100  0
	hodb001fpi:~ #

## Para ver o software que gerou um core

	# lquerypv -h core 6b0 64

## ERRPT - Queda de servio

	# lssrc -a |grep ctrmc  ==> verifica se o servio est ativo.

## Adicionando rota

	# route add -net 126.0.49.0 netmask 255.255.255.0 gw 10.28.146.43
	Aps isto colocar em /etc/sysconfig/network/routes a rota adicionada para qdo bootar voltar.
	# netstat -rn
	Verifica as rotas adicionadas.
	
## Backup image solicitando segunda fita.

	Verificar os file systems que esto sendo backpeados
	Verificar o que est no exclude (file systems que no esto sendo backpeados)
	# more etc/exclude.rootvg
	Caso necessite excluir algum file system do image, entrar em contato com Storage e verificar
	se o mesmo est incluso no TSM. Se sim, coloca-lo no exclude.

## Para verificar se o hdisk est online ou ativo

	# datapath query device
	# lsvpcfg | grep hdisk2



========================================================================




===============================================================================

* COMANDOS UNIX ** COMANDOS UNIX 

===============================================================================

 * * * * A I X * * * *

@@ vendo a que VG pertence o file system

	# lslv <nome a esquerda sem o /dev>

@@ Setando o vdeo

	# set -o vi

@@ Verificando discos de storage

	# datapath query device

@@ Verificar portas abertas

	# netstat -pa

	# netstat -nap | grep <porta>

@@ Verificar placa de rede

	# lsdev -Cc adapter
	# lsdev -C |grep ent

@@ Verificando fita dat

	# lsdev -Cc tape ( AIX )

	# mt -f /dev/st0 status ( Linux )

@@ Verificar discos

	# lsdev -Cc disk

@@ Verificar fita dat

	# lsdev -Cc tape

@@ Procura dispositivos novos

	# cfgmgr

@@ Lista por tamanho maior os diretrios ou arquivos.

	# du -ks * | sort -rn

@@ Mostra o tamanho total de um diretrio

	# du -ks

@@ Verifica processos, memria, swap, atividades da CPU

	# vmstat 2 10

@@ Volta a fita

	# mt -t /dev/rmt0 rewind
	# tctl -f /dev/rmto rewind

@@ Instalando SSH

## backup das chaves

	/etc/openssh   ---> qdo no achar :  find / -name sshd_config

	tar -cvf backup_chaves.tar *_host_*

	cp sshd_config sshd_config.bkp

## desinstalar o ssh

	smitty install

	opo: freeware.openssh.rte

	lslpp -l |grep -i ssh ==> verifica ssh rodando

## instalar o ssh novo

	vai no diretorio do arquivo, smitty install, 1,1

## voltar bkp das chaves (diretorio /etc/openssh )

	tar -xvf backup_chaves.tar

	mv sshd_config.bkp sshd_config

## startar o ssh

	startsrc -s sshd
	ps -ef | grep ssh
	ssh -v
logar novamente

obs.: se o ssh no startar, proceder(telnet):

	stopsrc -s sshd
	startsrc -s sshd

Caso continue no pedindo pra mudar senha qdo cria usurio, proceder:

# ps -ef |grep ssh
	verifica os processos root
# lssrc -s sshd
	verifica o status, se no estiver active, precisa matar o primeiro processo
	geralmente desta maneira: root 258178      1   0   Feb 06      -  0:00 /usr/local/sbin/sshd

# startsrc -s sshd
# lssrc -s sshd
	verifica-se est active

@@ Verificando no crontab o backup image

	# crontab -l|pg  ====> verifica onde  feito o image backup
	# more /usr/bin/ImageBackuprmt.ksh  ===> verifica onde  gerado o arquivo de log
	# more /tmp/backup_image.log

@@ Fazendo backup image

	# smitty 
		System Storage Management (Physical & Logical Storage)
		System Backup Manager
		Back Up the System
		Back Up This System to Tape/File

		Backup DEVICE or FILE                              	[/dev/rmt0]                                                                                    	 +/
  		Create MAP files?                                   	no                                                                                                  	+
  		EXCLUDE files?                                      	no                                                                                                  +
  		List files as they are backed up?                   	no                                                                                                  +
  		Verify readability if tape device?                  	no                                                                                                  +
  		Generate new /image.data file?                      	yes                                                                                                 +
  		EXPAND /tmp if needed?                              	yes                                                                                                 +
  		Disable software packing of backup?                yes                                                                                                 +
  		Number of BLOCKS to write in a single output    []                                                                                                    #
     		(Leave blank to use a system default)

		
	# smitty mksysb
	


 * * * * S O L A R I S * * * *

@@ Mostra rea de swap da mquina

	# swap -s

## Processos na fila de impressora

	 lpstat -t |grep -i " nome da fila "
	disable "nome da fila"
	cancel -u "usuario (..admin)" " nome da fila "
	enable "nome da fila "

* * * * HP UX * * * *


@@ Verificar file system

	# dbf


* * * * L I N U X * * * *

@@ Montando disquete

	# mount /media/floppy  ou  /mnt/floppy
	pra ver onde monta os drivers: cat /etc/fstab

@@ Verifica utlizao de memria

	# free

@@ Instalando SSH

## backup das chaves

	cd /etc/ssh

	tar -cvf backup_chaves.tar *_host_*

	cp sshd_config sshd_config.bkp


## remove pacotes ssh

	rpm -qa |grep -i ssh

	rpm -e <pacotes>

        rpm --test -e <pacote>
	
## instalar pacote ssh

	rpm -Uvh openssh-4.0p1-1.i386.rpm

## voltar bkp das chaves ssh

	cd /etc/ssh

	tar -xvf backup_chaves.tar

	mv sshd_config.bkp sshd_config

## copiar o pacote sshd para o diretrio /etc/rc.d/init.d/

	cp sshd /etc/rc.d/init.d/

## startar o ssh no runlevel

	chkconfig --level 23456 sshd on

## permisso de execuo para sshd

	chmod 775 /etc/rc.d/init.d/sshd


## caso no exista, criar usurio sshd e diretrio empty

	useradd -s /sbin/nologin sshd

	mkdir /var/empty

## startar o sshd

	/etc/rc.d/init.d/sshd start

## duplicar sesso para testar login


* * * * S O L A R I S * * * *

@@ Verificando erros do sistema

	#  /var/adm# grep transpor messages

@@ Limpando mensagens de erro

	# dentro do /sup ( sh renvaradmmsg.sh )

@@ Listar os discos

	# vxdisk list

@@ Verificando processadores do servidor

	# psrinfo -v

@@ Verificando memria do servidor

	# prtconf -v |more ( AIX ) 


@@ Verificando discos

	# format
	opes: p p / q q


@@ Descrio de softwares

	# pkginfo

======================================================================================

* PARTICULARIDADES DOS CLIENTES ** PARTICULARIDADES DOS CLIENTES ** PARTICULARIDADES DOS CLIENTES *

======================================================================================

## AMBEV 

@@ Este script arruma todas as permisses padres da Ambev, acordadas pela GSD do Cliente.
	
	<acsxo0>, root, /amb/bin # ksh -x ./arruma_protecao


## MULTIBRAS ## MULTIBRAS ## MULTIBRAS ## MULTIBRAS ## MULTIBRAS ## MULTIBRAS ## MULTIBRAS ### 



=======================================================================================


TABELA DE ROTAS 

Netmask Table
Bits   Dotted Decimal     Hexadecimal   Binary Netmask
       Netmask            Netmask
----------------------------------------------------------------------------
/0     0.0.0.0            0x00000000    00000000 00000000 00000000 00000000
/1     128.0.0.0          0x80000000    10000000 00000000 00000000 00000000
/2     192.0.0.0          0xc0000000    11000000 00000000 00000000 00000000
/3     224.0.0.0          0xe0000000    11100000 00000000 00000000 00000000
/4     240.0.0.0          0xf0000000    11110000 00000000 00000000 00000000
/5     248.0.0.0          0xf8000000    11111000 00000000 00000000 00000000
/6     252.0.0.0          0xfc000000    11111100 00000000 00000000 00000000
/7     254.0.0.0          0xfe000000    11111110 00000000 00000000 00000000
/8     255.0.0.0          0xff000000    11111111 00000000 00000000 00000000

/9     255.128.0.0        0xff800000    11111111 10000000 00000000 00000000
/10    255.192.0.0        0xffc00000    11111111 11000000 00000000 00000000
/11    255.224.0.0        0xffe00000    11111111 11100000 00000000 00000000
/12    255.240.0.0        0xfff00000    11111111 11110000 00000000 00000000
/13    255.248.0.0        0xfff80000    11111111 11111000 00000000 00000000
/14    255.252.0.0        0xfffc0000    11111111 11111100 00000000 00000000
/15    255.254.0.0        0xfffe0000    11111111 11111110 00000000 00000000
/16    255.255.0.0        0xffff0000    11111111 11111111 00000000 00000000

/17    255.255.128.0      0xffff8000    11111111 11111111 10000000 00000000
/18    255.255.192.0      0xffffc000    11111111 11111111 11000000 00000000
/19    255.255.224.0      0xffffe000    11111111 11111111 11100000 00000000
/20    255.255.240.0      0xfffff000    11111111 11111111 11110000 00000000
/21    255.255.248.0      0xfffff800    11111111 11111111 11111000 00000000
/22    255.255.252.0      0xfffffc00    11111111 11111111 11111100 00000000
/23    255.255.254.0      0xfffffe00    11111111 11111111 11111110 00000000
/24    255.255.255.0      0xffffff00    11111111 11111111 11111111 00000000

/25    255.255.255.128    0xffffff80    11111111 11111111 11111111 10000000
/26    255.255.255.192    0xffffffc0    11111111 11111111 11111111 11000000
/27    255.255.255.224    0xffffffe0    11111111 11111111 11111111 11100000
/28    255.255.255.240    0xfffffff0    11111111 11111111 11111111 11110000
/29    255.255.255.248    0xfffffff8    11111111 11111111 11111111 11111000
/30    255.255.255.252    0xfffffffc    11111111 11111111 11111111 11111100
/31    255.255.255.254    0xfffffffe    11111111 11111111 11111111 11111110
/32    255.255.255.255    0xffffffff    11111111 11111111 11111111 11111111






############################################################################################################################

			Outros

- correio eletronico (mail , mailx)
- ediao de arquivos ( ed , ex , vi )
- processamento de textos ( sort , sed , wc , awk , grep )
- formatao de textos ( nroff , troff )
- desenvolvimento de programas ( cc , make , lint , lex )
- comunicaao intersistemas ( uucp )
- contabilidade de processos e de usurios ( ps , du , acctcom )




Compactar
gzip -c teste3 > /tmp/teste3.old.gz;>teste3; mv /tmp/teste3.old.gz .

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Segue uma dica legal para descobrir a console de uma regatta, sem precisar recorrer a base

Foi passada pela Susana

hotsm001tms /usr/bin # lsrsrc "IBM.ManagementServer"
Resource Persistent Attributes for IBM.ManagementServer
resource 1:
Name = "172.16.21.4"           ---->>Endereo IP da HMC
Hostname = "172.16.21.4"
ManagerType = "HMC"
LocalHostname = "172.16.21.5"
ClusterTM = "9078-160"
ClusterSNum = ""
ActivePeerDomain = ""
NodeNameList = {"hotsm001tms"}
hotsm001tms /usr/bin #
hotsm001tms /usr/bin #


Obrigado.

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

