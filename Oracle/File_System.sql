o /usr se resolve com o commit dos pacotes
o /var se resolve com a eliminacao dos mails
o / normalmente se resolve com eliminacao de lixo de nohup.out e smit scripts

#mudar caracteristicas de FS
chfs
#	#ver quem esta usando o FS
fuser /filesystem
#		#para terminar todos os processos no FS
fuser-kxuc /filesystem

================================================== 

## Criar LV

mklv -y lvxx -t jfs2 -c 2 rootvg 3	//criar lv

3  	//quantidade de pps

-c 2 	// fala se  mirror..ou ex -> melhor distribuicao entre os discos

================================================== 

		AUMENTAR FS

	HP-UX
vgdisplay vg00	// ver qto tem sombrando
sam		// para aumentar

	LINUX
ext2online (Linux)
[root@hofw007vr /]# lvextend -L +100MB /dev/rootvg/rootlv

lvextend -L +500M /dev/vg00/lvol1

  Rounding up size to full physical extent 128.00 MB
  Extending logical volume rootlv to 384.00 MB
  Logical volume rootlv successfully resized

[root@hofw007vr /]# ext2online /dev/rootvg/rootlv
ext2online  /dev/vg00/lvol1
ext2online v1.1.18 - 2001/03/18 for EXT2FS 0.5b

[root@hofw007vr /]# df -k .

Filesystem           		1K-blocks   Used 	 Available	  Use% 	Mounted on
/dev/mapper/rootvg-rootlv        380807    240105    121051    67% 	/
...........................................................................................

	AIX

> ' smit jfs2 '  ou 'jfs'		// programa para aumentar FS no AIX

## Aumentar File System por comando

	- chfs -a size=+<espao> <nome do filesystem>

	# chfs -a size=+1000000 /home   	// para aumentar 300 mega
	
chfs -a size=+50000 /oracle/PRD
chfs -a size=+50000 /dev/lv_optscm  	// para aumentar 25MB

spocpdsv83e
/dev/hd1
chfs -a size=+100M /dev/hd9var 	// para aumentar 50MB

...........................................................................................
		SMIT LV

##Aumentar o Max de Logical partitions

smit lv
Set Characteristic of a Logical Volume
Change a Logical Volume
Evandro Fior/Brazil/IBM: MAXIMUM NUMBER of LOGICAL PARTITIONS               [2048]       

------------------------------------------------------------------------

mount /dev/fslv02 /test		// montar o file system no /test
---

umount /test			// unmount file system
---

rmfs /test				// remover file system

	###Montagem

#montar disquete, leitor de CD
mount /mnt/floppy ; mount /mnt/cdrom

================================================== 

Mudar nome de FS

mkdir oratemp; chown owner:grupo /oratemp
2:59:05 PM: angarcia@br.ibm.com: verifica o ponto de montagem com df -k
2:59:33 PM: angarcia@br.ibm.com: umount /oraarc e mount /dev/xxxxx /oratemp
2:59:51 PM: angarcia@br.ibm.com: depois vai no /etc/filesystems e troca o nome da montagem
3:01:09 PM: angarcia@br.ibm.com: corrige tb o chmod

## RENOMEANDO UM FILESYSTEM - LINUX

Exemplo:

Renomear  /oraarc para  /oratemp

1) Desmontar o mesmo

[root@csc4dbp ~]# umount /oraarc

2) Criar o diretrio com o novo nome

[root@csc4dbp ~]# mkdir /oratemp

3) Dentro de /etc/fstab , renomear o nome antigo para o novo do filesystem (sempre fazer cpia de segurana do arquivo antes de alterar)

4) Dar as permisses do novo diretrio

[root@csc4dbp ~]# chmod 755 /oratemp

[root@csc4dbp ~]# chown -R oracle.dba Restore_124209

5) Montar o filesystem

[root@csc4dbp ~]# mount /oratemp

==================================================

		- / cheio

[root@hofw007vr /]# df -k .		// ver os FS em KB
Filesystem          		 1K-blocks      Used 	Available Use% 	Mounted on
/dev/mapper/rootvg-rootlv          253871    240109      	 655 	100%	 /

> ' du -ks *| sort -n ' 		// lista em ordem qual + consome
> ' lslv xxx '		// detalhar o lv
> ' lsvg '			// ver qual  o VG
> ' lsvg xxx '		// detalhar o VG

===============================================
	-  /var cheio : (/var/spool/mqueue)   (qdeamon)

> var/spool/mqueue		// diretrio de e-mail

> startsrc -s lpd 			// start no processo 

## Se for o clientmqueue rodar:	
sendmail -v -q


> find . -type f -mtime +1 -exec rm {} \;  	// deleta todos os arquivos mais velhos que um dia


sabem quando abrem chamado reclamando de /var com pouco espaco e agente descobre que o /var/spool/mqueue ta com um millhao de arquivinho tonto la dentro?
ai nao da pra fazer nem ls -l
15:13:46: Antonio Garcia: entao executa 
find /var/spool/mqueue -mtime +35 -exec rm {} \;
depois find /var/spool/mqueue -mtime +3 -exec rm {} \;
tem que ver a permissao
Francisco Jose Fogaca De Andrade: chmod 770  /var/spool/mqueue
chmod 6551 /usr/sbin/sendmail
chmod 6555 /usr/bin/bellmail

chmod 770  /var/spool/mqueue ; chmod 6551 /usr/sbin/sendmail ; chmod 6555 /usr/bin/bellmail


ou

		## /var cheio

Verifiquei em vrios Servidores, por exemplo honv001infr e hotv001infr que o mail do root estava zerado e estavam acumulando arquivos no spool e os mesmos no eram processados com o seguinte erro:

root@honv001infr:/ # sendmail -v -q

Running /var/spool/mqueue/lBT1WRHj060756 (sequence 1 of 1)
remarq... Connecting to local...
Operating system error
root@honv001infr:/ #

Pesquisando no PSDB e tambm na net, consegui descobrir que a unica coisa errada era a permisso do sendmail e do bellmail.

Aps alterar a permisso do sendmail para 6551 e o do bellmail para 6555 o problema foi sanado.

Creio que talvez algum CIRATS aplicado nos servidores tenha alterado essas permisses e desse jeito o mail local no funciona.

Caso tenham algum problema no /var e identifiquem que o sendmail no est processando a fila, verifiquem as permisses esto confome abaixo:

drwxrwx---    2 root    system    /var/spool/mqueue
-r-sr-s--x    3 root    system    /usr/sbin/sendmail
-r-sr-sr-x    1 root    mail      /usr/bin/bellmail

Se no estiver, o correto  s acertar as permisses:

chmod 770  /var/spool/mqueue
chmod 6551 /usr/sbin/sendmail
chmod 6555 /usr/bin/bellmail


Para fazer o teste  s digitar:

root@honv001infr:/ # date |mail -v root
root... Connecting to local...
root... Sent

Se a saida for Sent, ento est ok.


===============================================



fuser -uck <nome do filesystem> // mata todos os processos que estao no fs

umount <nome do filesystem> // desmontar o fs
mount <nome do filesystem> // montar filesystem

fsck
fsck -y <nome do filesystem> // corrige os erros que existem no fs, fs tem que estar unmount
fsck -n <nome do filesystem> // verifica os erros no fs

	Ambev

<acsxp6>, root, /etc # mount /dev/mgtws2   /mg/amb/local/tws2
Replaying log for /dev/mgtws2.
Failure replaying log: -1
mount: 0506-324 Cannot mount /dev/mgtws2 on /mg/amb/local/tws2: The media is not formatted or the format is not correct.
0506-342 The superblock on /dev/mgtws2 is dirty.  Run a full fsck to fix.

<acsxp6>, root, /etc # fsck -y /dev/mgtws2

==================================================
/usr que foi feito ml a pouco tempo

root@IBMSAP09 /usr/sap/QAL>uptime
  03:55PM   up 3 days,   4:08,  0 users,  load average: 2.60, 3.01, 3.19


smit install
3:55:34 PM: angarcia@br.ibm.com: smit install, software maintenance and utilities, Commit applied software updates , ai vai aparecer uma janela mais ou menos assim
Rhanier Leandro da Cruz/Brazil/IBM: estou na janela

  SOFTWARE name                                      		[all]                                                                                                +
  PREVIEW only? (commit operation will NOT occur)     	no                                                                                                  +
  COMMIT requisites?                                  		yes                                                                                                 +
  EXTEND file systems if space needed?                		yes                                                                                                 +
  DETAILED output?                                    		no                                                                                                  +

3:56:20 PM: angarcia@br.ibm.com: ai voce tecla entra
==================================================
/ cheio
smit.log
smit.script
...
/ cheio

find / -xdev -size +1024 | xargs ls -l|more

=============================================
========================================

## CRIANDO UM FILESYSTEM

Exemplo: Criando o filesystem /WEWITS/ENVIO

1) Criar o LV primeiro para que possa melhor organizao no S.O.

Verificar em qual VG ser criado, neste caso, criaremos no  vgPRD_01

root@cabrshorsap03:/# lsvg vgPRD_01
VOLUME GROUP:       vgPRD_01                 VG IDENTIFIER:  00cc052e00004c00000001142272f15b
VG STATE:           active                   PP SIZE:        4 megabyte(s)
VG PERMISSION:      read/write               TOTAL PPs:      133376 (533504 megabytes)
MAX LVs:            256                      FREE PPs:       70895 (283580 megabytes)
LVs:                4                        USED PPs:       62481 (249924 megabytes)
OPEN LVs:           4                        QUORUM:         5
TOTAL PVs:          8                        VG DESCRIPTORS: 8
STALE PVs:          0                        STALE PPs:      0
ACTIVE PVs:         8                        AUTO ON:        yes
MAX PPs per VG:     262144                   MAX PVs:        1024
LTG size (Dynamic): 256 kilobyte(s)          AUTO SYNC:      no
HOT SPARE:          no                       BB POLICY:      relocatable
root@cabrshorsap03:/#

Cria-se um LV para colocar o filesystem:

# smitty lvm

	Logical Volumes
	Add a Logical Volume

[TOP]                                                   [Entry Fields]
  Logical volume NAME                                [lv1_wenits01] ----> O nome do LV a ser criado ( Colocar sempre relacionado ao filesystem )
* VOLUME GROUP name                                   vgPRD_01 -----> Selecionar o VG onde ser criado o LV
* Number of LOGICAL PARTITIONS                       [500]  ------> Neste campo, verifica o total de pp do VG, e multiplica por um valor at chegar ao tamanho a ser criado do filesystem

Logical volume TYPE                                [jfs2]  ----> Verificar sempre como esto os outros filesystems ( lsvg -l vg )

  POSITION on physical volume                         center     ------> Alterar para center                                 
  RANGE of physical volumes                           maximum  ------> Alterar para maximum    

Estes valores referem-se a posio do fs no disco, espalhar o mximo no disco.

2) Criar o filesystem

# smitty jfs2

Add an Enhanced Journaled File System on a Previously Defined Logical Volume ----> Esta opo cria a partir de lv existente, se quiser criar direto sem lv definido, opo anterior.

* LOGICAL VOLUME name                                 lv1_wenits01                                    ----> Nome do LV criado
* MOUNT POINT                                        [/WEWITS/ENVIO]                                 ----> Nome do filesystem a criar
  Mount AUTOMATICALLY at system restart?              yes                                             +

3) Dar as permisses pro filesystem antes de montar e aps tambm, pois j ocorreram problemas com filesystems de banco/sap neste sentido.


==============================

Comando LSOF
---------------------

lsof	arquivo preso

$ lsof -u usurio 	Mostra os arquivos abertos identificado pelo nome de usurio, representado aqui pelo identificador usurio. 

$ lsof -g n 	Mostra os arquivos abertos por um determinado grupo, identificado aqui numericamente pela varivel n. 

$ lsof -p n 	Mostra os arquivos abertos por um determinado nmero de processo (PID), representado aqui pela varivel n. 

$ ls -u usurio -g n 	Existem ainda muitos outros parmetros que podem ser verificados com o comando: 


....................

Ofile can also be used to examine network sockets.  To list all open
files
associated with internet connections use the "-i" option. This will look
somewhat like the output from a "netstat -a -p".
You can see the network sockets by doing the following.
# lsof -i          # examine all network sockets
# lsof -i :22      # to see what is happening on PORT 22
# lsof -i :ssh     # to see what is happening on SERVICE ssh
# lsof -i @ghent.itt.com  # to see what CONNECTIONS this hostname is
using

To see what process are accessing a directory you can use the "+d"
# lsof +d /var/log/samba  # see what proccess are accessing this
directory

To run a lsof every x number of seconds use the "-r" option
# lsof -r 3 -i :22   # to see what is using port 22 every 3 seconds


  # ./lsof -p 980
   COMMAND  PID USER  FD  TYPE DEVICE SIZE/OFF   NODE NAME
   remotelp 980 root cwd  VDIR  121,0     1024      2 /
   remotelp 980 root txt  VREG  121,0    99704  78131 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root txt  VREG  121,0   534076 200740 /lib/libc.so.1
   remotelp 980 root txt  VREG  121,0   206964  78133
/usr/lib/libsocket.so.1.1
   remotelp 980 root txt  VREG  121,0    35300 200874 /lib/nss_dns.so.1
   remotelp 980 root txt  VREG  121,0    41312 200731 /lib/libsec.so
   remotelp 980 root txt  VREG  121,0   353980  78132 /usr/lib/libnsl.so
   remotelp 980 root txt  VREG  121,0   203240 200732 /lib/libseq.so
   remotelp 980 root txt  VREG  121,0    19160 200724 /lib/libevent.so
   remotelp 980 root   0r VCHR    3,2      0t0   8221 /dev/null
   remotelp 980 root   1w VCHR    3,2      0t0   8221 /dev/null
   remotelp 980 root   2w VREG  121,0    16978  28915 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root   3w VREG  121,0        0 450591 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root   4u VCHR   54,6      0t0
STR:/dev/sp-->strpipe
   remotelp 980 root   5u VCHR   54,7      0t0
STR:/dev/spx->strpipe
   remotelp 980 root   6u inet 0x025b7538  0t0        TCP *:printer
(LISTEN)

==================================================

Pessoal s pra informao caso alguem ainda no tenha se deparado com uma situao desta o /amb na acsxr8 tava com 92% de ocupao porm quando executava o du para verificar o tamanho dos arquivos no bate a informao que e trazida pelo comando, executando o comando fuser com as opes abaixo identificamos que o jacclient tava segurando a rea do fs, ai fiz um stop do processo e um kill ai liberou a rea no fs.

Chamado: 662368

<acsxr8>, root, /amb/local # df -k .
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     10116   92%     3079    11% /amb

<acsxr8>, root, /amb # du -ks * |sort -n
4       Bin
4       adsm
4       lost+found
4       pilotbin
4       samples
20      util
128     dm
276     boot
696     genbin
856     bkp
888     global
1012    gensbin
1784    cfg
2612    scripts
2812    operador
4212    sbin
5284    log
5572    bin
9320    eventbin
857828  local

<acsxr8>, root, / # fuser -cdfV /amb
/amb:
inode=4162   size=71868434     fd=1       37446
inode=4162   size=71868434     fd=1       57958

<acsxr8>, root, / # ps -ef|grep 37446
    root  37446      1   0   Apr 10      - 43:45 sh /amb/local/scm/client/jacclient restart
    root  57958  37446   0 07:41:18      -  0:00 sleep 10
    root 130494  46912   0 07:41:26  pts/0  0:00 grep 37446
<acsxr8>, root, / # ps -ef|grep 57958
    root 132628  46912   0 07:41:33  pts/0  0:00 grep 57958

<acsxr8>, root, / # /amb/local/scm/client/jacclient stop
Stopping the Tivoli Security Compliance Manager client.
The client stopped successfully.
<acsxr8>, root, / # df -k /amb
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     10096   92%     3079    11% /amb

<acsxr8>, root, / # ps -ef|grep 37446
    root  37446      1   0   Apr 10      - 43:45 sh /amb/local/scm/client/jacclient restart
    root  58014  37446   0 07:41:58      -  0:00 sleep 10
    root 132662  46912   0 07:42:03  pts/0  0:00 grep 37446
<acsxr8>, root, / # kill -9 37446

<acsxr8>, root, / # ps -ef|grep 37446
    root  51268  46912   1 07:42:13  pts/0  0:00 grep 37446

<acsxr8>, root, / # fuser -cdfV /amb
/amb:
inode=4162   size=71869744     fd=1       58028

<acsxr8>, root, / # ps -ef|grep 58028
    root  37448  46912   1 07:42:20  pts/0  0:00 grep 58028

<acsxr8>, root, / # df -k /amb
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     80360   30%     3078    11% /amb

=============================================
# metattach <soft-partition-name> <size>
# growfs -M /<dir-name> /dev/md/rdsk/<soft-partition-name>


root@dborap016 # metattach d105 10g
root@dborap016 # growfs -M /acxp01 /dev/md/rdsk/d105 ----obsverdar que tem que ser o raw devic

OBS: Foi enviado pelo Daniel Carneiro

-VERIFICAES ANTES DO AUMENTO 

xinguilingue>metastat -s pora5ds -p 
pora5ds/d61 -p /dev/md/pora5ds/rdsk/d50 -o 255852672 -b 209715200 
pora5ds/d50 5 1 /dev/dsk/c2t5005076300CB0B15d0s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d1s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d2s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d3s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d4s0 
pora5ds/d59 -p /dev/md/pora5ds/rdsk/d50 -o 155189344 -b 100663296 
pora5ds/d52 -p /dev/md/pora5ds/rdsk/d50 -o 20971584 -b 134217728  -o 465567904 -b 41943040 
pora5ds/d51 -p /dev/md/pora5ds/rdsk/d50 -o 32 -b 20971520 

xinguilingue>metastat -s pora5ds 
pora5ds/d61: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 209715200 blocks (100 GB) 
        Extent              Start Block              Block count 
             0                255852672                209715200 

pora5ds/d50: Concat/Stripe 
    Size: 574636032 blocks (274 GB) 
    Stripe 0: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d0s0          0     No            Okay   No 
    Stripe 1: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d1s0          0     No            Okay   No 
    Stripe 2: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d2s0          0     No            Okay   No 
    Stripe 3: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d3s0          0     No            Okay   No 
    Stripe 4: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d4s0          0     No            Okay   No 

pora5ds/d59: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 100663296 blocks (48 GB) 
        Extent              Start Block              Block count 
             0                155189344                100663296 

pora5ds/d52: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 176160768 blocks (84 GB) 
        Extent              Start Block              Block count 
             0                 20971584                134217728 
             1                465567904                 41943040 

pora5ds/d51: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 20971520 blocks (10 GB) 
        Extent              Start Block              Block count 
             0                       32                 20971520 

Device Relocation Information: 
Device                           Reloc  Device ID 
/dev/dsk/c2t5005076300CB0B15d0   No     - 
/dev/dsk/c2t5005076300CB0B15d1   No     - 
/dev/dsk/c2t5005076300CB0B15d2   No     - 
/dev/dsk/c2t5005076300CB0B15d3   No     - 
/dev/dsk/c2t5005076300CB0B15d4   No     - 


xinguilingue>ls -1 /dev/dsk/c2t50050*s2 | awk '{print "prtvtoc "$1"| tail -2 | head -1"}' | sh | \ 
awk '{SOMA += $6} END {printf("O diskset possui %.0f GB alocado.\n", (SOMA/2)/1048576) }' 

-PROCEDIMENTO PARA AUMENTO DE FILESYSTEM UFS COM SOLARIS VOLUME MANAGER (DISK SUITE) 

xinguilingue>df -k /u02 
Filesystem            kbytes    used   avail capacity  Mounted on 
/dev/md/pora5ds/dsk/d52 
                     66092522 65154179  277418   100%    /u02 

xinguilingue>metattach -s pora5ds d52 20g 
pora5ds/d52: Soft Partition has been grown 

xinguilingue>growfs -M /u02 /dev/md/pora5ds/rdsk/d52 
/dev/md/pora5ds/rdsk/d52:       176160768 sectors in 10752 cylinders of 64 tracks, 256 sectors 
        86016.0MB in 1792 cyl groups (6 c/g, 48.00MB/g, 5824 i/g) 
super-block backups (for fsck -F ufs -o b=#) at: 
 32, 98592, 197152, 295712, 394272, 492832, 591392, 689952, 788512, 887072, 
Initializing cylinder groups: 
o /usr se resolve com o commit dos pacotes
o /var se resolve com a eliminacao dos mails
o / normalmente se resolve com eliminacao de lixo de nohup.out e smit scripts

#mudar caracteristicas de FS
chfs
#	#ver quem esta usando o FS
fuser /filesystem
#		#para terminar todos os processos no FS
fuser-kxuc /filesystem

================================================== 

## Criar LV

mklv -y lvxx -t jfs2 -c 2 rootvg 3	//criar lv

3  	//quantidade de pps

-c 2 	// fala se  mirror..ou ex -> melhor distribuicao entre os discos

================================================== 

		AUMENTAR FS
	HP-UX
vgdisplay vg00	// ver qto tem sombrando
sam		// para aumentar
	LINUX

ext2online (Linux)
[root@hofw007vr /]# lvextend -L +100MB /dev/rootvg/rootlv

lvextend -L +500M /dev/vg00/lvol1

  Rounding up size to full physical extent 128.00 MB
  Extending logical volume rootlv to 384.00 MB
  Logical volume rootlv successfully resized

[root@hofw007vr /]# ext2online /dev/rootvg/rootlv
ext2online  /dev/vg00/lvol1
ext2online v1.1.18 - 2001/03/18 for EXT2FS 0.5b

[root@hofw007vr /]# df -k .

Filesystem           		1K-blocks   Used 	 Available	  Use% 	Mounted on
/dev/mapper/rootvg-rootlv        380807    240105    121051    67% 	/
...........................................................................................

	AIX

> ' smit jfs2 '  ou 'jfs'		// programa para aumentar FS no AIX

## Aumentar File System por comando

	- chfs -a size=+<espao> <nome do filesystem>

	# chfs -a size=+1000000 /home   	// para aumentar 300 mega
	
chfs -a size=+50000 /oracle/PRD
chfs -a size=+50000 /dev/lv_optscm  	// para aumentar 25MB

spocpdsv83e
/dev/hd1
chfs -a size=+100M /dev/hd9var 	// para aumentar 50MB

...........................................................................................
		SMIT LV

##Aumentar o Max de Logical partitions

smit lv
Set Characteristic of a Logical Volume
Change a Logical Volume
Evandro Fior/Brazil/IBM: MAXIMUM NUMBER of LOGICAL PARTITIONS               [2048]       

------------------------------------------------------------------------

mount /dev/fslv02 /test		// montar o file system no /test
---

umount /test			// unmount file system
---

rmfs /test				// remover file system

	###Montagem

#montar disquete, leitor de CD
mount /mnt/floppy ; mount /mnt/cdrom

================================================== 

Mudar nome de FS

mkdir oratemp; chown owner:grupo /oratemp
2:59:05 PM: angarcia@br.ibm.com: verifica o ponto de montagem com df -k
2:59:33 PM: angarcia@br.ibm.com: umount /oraarc e mount /dev/xxxxx /oratemp
2:59:51 PM: angarcia@br.ibm.com: depois vai no /etc/filesystems e troca o nome da montagem
3:01:09 PM: angarcia@br.ibm.com: corrige tb o chmod

## RENOMEANDO UM FILESYSTEM - LINUX

Exemplo:

Renomear  /oraarc para  /oratemp

1) Desmontar o mesmo

[root@csc4dbp ~]# umount /oraarc

2) Criar o diretrio com o novo nome

[root@csc4dbp ~]# mkdir /oratemp

3) Dentro de /etc/fstab , renomear o nome antigo para o novo do filesystem (sempre fazer cpia de segurana do arquivo antes de alterar)

4) Dar as permisses do novo diretrio

[root@csc4dbp ~]# chmod 755 /oratemp

[root@csc4dbp ~]# chown -R oracle.dba Restore_124209

5) Montar o filesystem

[root@csc4dbp ~]# mount /oratemp

==================================================

		- / cheio

[root@hofw007vr /]# df -k .		// ver os FS em KB
Filesystem          		 1K-blocks      Used 	Available Use% 	Mounted on
/dev/mapper/rootvg-rootlv          253871    240109      	 655 	100%	 /

> ' du -ks *| sort -n ' 		// lista em ordem qual + consome
> ' lslv xxx '		// detalhar o lv
> ' lsvg '			// ver qual  o VG
> ' lsvg xxx '		// detalhar o VG

===============================================
	-  /var cheio : (/var/spool/mqueue)   (qdeamon)

> var/spool/mqueue		// diretrio de e-mail

> startsrc -s lpd 			// start no processo 

## Se for o clientmqueue rodar:	
sendmail -v -q


> find . -type f -mtime +1 -exec rm {} \;  	// deleta todos os arquivos mais velhos que um dia


sabem quando abrem chamado reclamando de /var com pouco espaco e agente descobre que o /var/spool/mqueue ta com um millhao de arquivinho tonto la dentro?
ai nao da pra fazer nem ls -l
15:13:46: Antonio Garcia: entao executa 
find /var/spool/mqueue -mtime +35 -exec rm {} \;
depois find /var/spool/mqueue -mtime +3 -exec rm {} \;
tem que ver a permissao
Francisco Jose Fogaca De Andrade: chmod 770  /var/spool/mqueue
chmod 6551 /usr/sbin/sendmail
chmod 6555 /usr/bin/bellmail

chmod 770  /var/spool/mqueue ; chmod 6551 /usr/sbin/sendmail ; chmod 6555 /usr/bin/bellmail


ou

		## /var cheio

Verifiquei em vrios Servidores, por exemplo honv001infr e hotv001infr que o mail do root estava zerado e estavam acumulando arquivos no spool e os mesmos no eram processados com o seguinte erro:

root@honv001infr:/ # sendmail -v -q

Running /var/spool/mqueue/lBT1WRHj060756 (sequence 1 of 1)
remarq... Connecting to local...
Operating system error
root@honv001infr:/ #

Pesquisando no PSDB e tambm na net, consegui descobrir que a unica coisa errada era a permisso do sendmail e do bellmail.

Aps alterar a permisso do sendmail para 6551 e o do bellmail para 6555 o problema foi sanado.

Creio que talvez algum CIRATS aplicado nos servidores tenha alterado essas permisses e desse jeito o mail local no funciona.

Caso tenham algum problema no /var e identifiquem que o sendmail no est processando a fila, verifiquem as permisses esto confome abaixo:

drwxrwx---    2 root    system    /var/spool/mqueue
-r-sr-s--x    3 root    system    /usr/sbin/sendmail
-r-sr-sr-x    1 root    mail      /usr/bin/bellmail

Se no estiver, o correto  s acertar as permisses:

chmod 770  /var/spool/mqueue
chmod 6551 /usr/sbin/sendmail
chmod 6555 /usr/bin/bellmail


Para fazer o teste  s digitar:

root@honv001infr:/ # date |mail -v root
root... Connecting to local...
root... Sent

Se a saida for Sent, ento est ok.


===============================================



fuser -uck <nome do filesystem> // mata todos os processos que estao no fs

umount <nome do filesystem> // desmontar o fs
mount <nome do filesystem> // montar filesystem

fsck
fsck -y <nome do filesystem> // corrige os erros que existem no fs, fs tem que estar unmount
fsck -n <nome do filesystem> // verifica os erros no fs

	Ambev

<acsxp6>, root, /etc # mount /dev/mgtws2   /mg/amb/local/tws2
Replaying log for /dev/mgtws2.
Failure replaying log: -1
mount: 0506-324 Cannot mount /dev/mgtws2 on /mg/amb/local/tws2: The media is not formatted or the format is not correct.
0506-342 The superblock on /dev/mgtws2 is dirty.  Run a full fsck to fix.

<acsxp6>, root, /etc # fsck -y /dev/mgtws2

==================================================
/usr que foi feito ml a pouco tempo

root@IBMSAP09 /usr/sap/QAL>uptime
  03:55PM   up 3 days,   4:08,  0 users,  load average: 2.60, 3.01, 3.19


smit install
3:55:34 PM: angarcia@br.ibm.com: smit install, software maintenance and utilities, Commit applied software updates , ai vai aparecer uma janela mais ou menos assim
Rhanier Leandro da Cruz/Brazil/IBM: estou na janela

  SOFTWARE name                                      		[all]                                                                                                +
  PREVIEW only? (commit operation will NOT occur)     	no                                                                                                  +
  COMMIT requisites?                                  		yes                                                                                                 +
  EXTEND file systems if space needed?                		yes                                                                                                 +
  DETAILED output?                                    		no                                                                                                  +

3:56:20 PM: angarcia@br.ibm.com: ai voce tecla entra
==================================================
/ cheio
smit.log
smit.script
...
/ cheio

find / -xdev -size +1024 | xargs ls -l|more

=============================================
========================================

## CRIANDO UM FILESYSTEM

Exemplo: Criando o filesystem /WEWITS/ENVIO

1) Criar o LV primeiro para que possa melhor organizao no S.O.

Verificar em qual VG ser criado, neste caso, criaremos no  vgPRD_01

root@cabrshorsap03:/# lsvg vgPRD_01
VOLUME GROUP:       vgPRD_01                 VG IDENTIFIER:  00cc052e00004c00000001142272f15b
VG STATE:           active                   PP SIZE:        4 megabyte(s)
VG PERMISSION:      read/write               TOTAL PPs:      133376 (533504 megabytes)
MAX LVs:            256                      FREE PPs:       70895 (283580 megabytes)
LVs:                4                        USED PPs:       62481 (249924 megabytes)
OPEN LVs:           4                        QUORUM:         5
TOTAL PVs:          8                        VG DESCRIPTORS: 8
STALE PVs:          0                        STALE PPs:      0
ACTIVE PVs:         8                        AUTO ON:        yes
MAX PPs per VG:     262144                   MAX PVs:        1024
LTG size (Dynamic): 256 kilobyte(s)          AUTO SYNC:      no
HOT SPARE:          no                       BB POLICY:      relocatable
root@cabrshorsap03:/#

Cria-se um LV para colocar o filesystem:

# smitty lvm

	Logical Volumes
	Add a Logical Volume

[TOP]                                                   [Entry Fields]
  Logical volume NAME                                [lv1_wenits01] ----> O nome do LV a ser criado ( Colocar sempre relacionado ao filesystem )
* VOLUME GROUP name                                   vgPRD_01 -----> Selecionar o VG onde ser criado o LV
* Number of LOGICAL PARTITIONS                       [500]  ------> Neste campo, verifica o total de pp do VG, e multiplica por um valor at chegar ao tamanho a ser criado do filesystem

Logical volume TYPE                                [jfs2]  ----> Verificar sempre como esto os outros filesystems ( lsvg -l vg )

  POSITION on physical volume                         center     ------> Alterar para center                                 
  RANGE of physical volumes                           maximum  ------> Alterar para maximum    

Estes valores referem-se a posio do fs no disco, espalhar o mximo no disco.

2) Criar o filesystem

# smitty jfs2

Add an Enhanced Journaled File System on a Previously Defined Logical Volume ----> Esta opo cria a partir de lv existente, se quiser criar direto sem lv definido, opo anterior.

* LOGICAL VOLUME name                                 lv1_wenits01                                    ----> Nome do LV criado
* MOUNT POINT                                        [/WEWITS/ENVIO]                                 ----> Nome do filesystem a criar
  Mount AUTOMATICALLY at system restart?              yes                                             +

3) Dar as permisses pro filesystem antes de montar e aps tambm, pois j ocorreram problemas com filesystems de banco/sap neste sentido.


==============================

Comando LSOF
---------------------

lsof	arquivo preso

$ lsof -u usurio 	Mostra os arquivos abertos identificado pelo nome de usurio, representado aqui pelo identificador usurio. 

$ lsof -g n 	Mostra os arquivos abertos por um determinado grupo, identificado aqui numericamente pela varivel n. 

$ lsof -p n 	Mostra os arquivos abertos por um determinado nmero de processo (PID), representado aqui pela varivel n. 

$ ls -u usurio -g n 	Existem ainda muitos outros parmetros que podem ser verificados com o comando: 


....................

Ofile can also be used to examine network sockets.  To list all open
files
associated with internet connections use the "-i" option. This will look
somewhat like the output from a "netstat -a -p".
You can see the network sockets by doing the following.
# lsof -i          # examine all network sockets
# lsof -i :22      # to see what is happening on PORT 22
# lsof -i :ssh     # to see what is happening on SERVICE ssh
# lsof -i @ghent.itt.com  # to see what CONNECTIONS this hostname is
using

To see what process are accessing a directory you can use the "+d"
# lsof +d /var/log/samba  # see what proccess are accessing this
directory

To run a lsof every x number of seconds use the "-r" option
# lsof -r 3 -i :22   # to see what is using port 22 every 3 seconds


  # ./lsof -p 980
   COMMAND  PID USER  FD  TYPE DEVICE SIZE/OFF   NODE NAME
   remotelp 980 root cwd  VDIR  121,0     1024      2 /
   remotelp 980 root txt  VREG  121,0    99704  78131 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root txt  VREG  121,0   534076 200740 /lib/libc.so.1
   remotelp 980 root txt  VREG  121,0   206964  78133
/usr/lib/libsocket.so.1.1
   remotelp 980 root txt  VREG  121,0    35300 200874 /lib/nss_dns.so.1
   remotelp 980 root txt  VREG  121,0    41312 200731 /lib/libsec.so
   remotelp 980 root txt  VREG  121,0   353980  78132 /usr/lib/libnsl.so
   remotelp 980 root txt  VREG  121,0   203240 200732 /lib/libseq.so
   remotelp 980 root txt  VREG  121,0    19160 200724 /lib/libevent.so
   remotelp 980 root   0r VCHR    3,2      0t0   8221 /dev/null
   remotelp 980 root   1w VCHR    3,2      0t0   8221 /dev/null
   remotelp 980 root   2w VREG  121,0    16978  28915 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root   3w VREG  121,0        0 450591 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root   4u VCHR   54,6      0t0
STR:/dev/sp-->strpipe
   remotelp 980 root   5u VCHR   54,7      0t0
STR:/dev/spx->strpipe
   remotelp 980 root   6u inet 0x025b7538  0t0        TCP *:printer
(LISTEN)

==================================================

Pessoal s pra informao caso alguem ainda no tenha se deparado com uma situao desta o /amb na acsxr8 tava com 92% de ocupao porm quando executava o du para verificar o tamanho dos arquivos no bate a informao que e trazida pelo comando, executando o comando fuser com as opes abaixo identificamos que o jacclient tava segurando a rea do fs, ai fiz um stop do processo e um kill ai liberou a rea no fs.

Chamado: 662368

<acsxr8>, root, /amb/local # df -k .
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     10116   92%     3079    11% /amb

<acsxr8>, root, /amb # du -ks * |sort -n
4       Bin
4       adsm
4       lost+found
4       pilotbin
4       samples
20      util
128     dm
276     boot
696     genbin
856     bkp
888     global
1012    gensbin
1784    cfg
2612    scripts
2812    operador
4212    sbin
5284    log
5572    bin
9320    eventbin
857828  local

<acsxr8>, root, / # fuser -cdfV /amb
/amb:
inode=4162   size=71868434     fd=1       37446
inode=4162   size=71868434     fd=1       57958

<acsxr8>, root, / # ps -ef|grep 37446
    root  37446      1   0   Apr 10      - 43:45 sh /amb/local/scm/client/jacclient restart
    root  57958  37446   0 07:41:18      -  0:00 sleep 10
    root 130494  46912   0 07:41:26  pts/0  0:00 grep 37446
<acsxr8>, root, / # ps -ef|grep 57958
    root 132628  46912   0 07:41:33  pts/0  0:00 grep 57958

<acsxr8>, root, / # /amb/local/scm/client/jacclient stop
Stopping the Tivoli Security Compliance Manager client.
The client stopped successfully.
<acsxr8>, root, / # df -k /amb
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     10096   92%     3079    11% /amb

<acsxr8>, root, / # ps -ef|grep 37446
    root  37446      1   0   Apr 10      - 43:45 sh /amb/local/scm/client/jacclient restart
    root  58014  37446   0 07:41:58      -  0:00 sleep 10
    root 132662  46912   0 07:42:03  pts/0  0:00 grep 37446
<acsxr8>, root, / # kill -9 37446

<acsxr8>, root, / # ps -ef|grep 37446
    root  51268  46912   1 07:42:13  pts/0  0:00 grep 37446

<acsxr8>, root, / # fuser -cdfV /amb
/amb:
inode=4162   size=71869744     fd=1       58028

<acsxr8>, root, / # ps -ef|grep 58028
    root  37448  46912   1 07:42:20  pts/0  0:00 grep 58028

<acsxr8>, root, / # df -k /amb
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     80360   30%     3078    11% /amb

=============================================
# metattach <soft-partition-name> <size>
# growfs -M /<dir-name> /dev/md/rdsk/<soft-partition-name>


root@dborap016 # metattach d105 10g
root@dborap016 # growfs -M /acxp01 /dev/md/rdsk/d105 ----obsverdar que tem que ser o raw devic

OBS: Foi enviado pelo Daniel Carneiro

-VERIFICAES ANTES DO AUMENTO 

xinguilingue>metastat -s pora5ds -p 
pora5ds/d61 -p /dev/md/pora5ds/rdsk/d50 -o 255852672 -b 209715200 
pora5ds/d50 5 1 /dev/dsk/c2t5005076300CB0B15d0s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d1s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d2s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d3s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d4s0 
pora5ds/d59 -p /dev/md/pora5ds/rdsk/d50 -o 155189344 -b 100663296 
pora5ds/d52 -p /dev/md/pora5ds/rdsk/d50 -o 20971584 -b 134217728  -o 465567904 -b 41943040 
pora5ds/d51 -p /dev/md/pora5ds/rdsk/d50 -o 32 -b 20971520 

xinguilingue>metastat -s pora5ds 
pora5ds/d61: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 209715200 blocks (100 GB) 
        Extent              Start Block              Block count 
             0                255852672                209715200 

pora5ds/d50: Concat/Stripe 
    Size: 574636032 blocks (274 GB) 
    Stripe 0: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d0s0          0     No            Okay   No 
    Stripe 1: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d1s0          0     No            Okay   No 
    Stripe 2: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d2s0          0     No            Okay   No 
    Stripe 3: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d3s0          0     No            Okay   No 
    Stripe 4: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d4s0          0     No            Okay   No 

pora5ds/d59: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 100663296 blocks (48 GB) 
        Extent              Start Block              Block count 
             0                155189344                100663296 

pora5ds/d52: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 176160768 blocks (84 GB) 
        Extent              Start Block              Block count 
             0                 20971584                134217728 
             1                465567904                 41943040 

pora5ds/d51: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 20971520 blocks (10 GB) 
        Extent              Start Block              Block count 
             0                       32                 20971520 

Device Relocation Information: 
Device                           Reloc  Device ID 
/dev/dsk/c2t5005076300CB0B15d0   No     - 
/dev/dsk/c2t5005076300CB0B15d1   No     - 
/dev/dsk/c2t5005076300CB0B15d2   No     - 
/dev/dsk/c2t5005076300CB0B15d3   No     - 
/dev/dsk/c2t5005076300CB0B15d4   No     - 


xinguilingue>ls -1 /dev/dsk/c2t50050*s2 | awk '{print "prtvtoc "$1"| tail -2 | head -1"}' | sh | \ 
awk '{SOMA += $6} END {printf("O diskset possui %.0f GB alocado.\n", (SOMA/2)/1048576) }' 

-PROCEDIMENTO PARA AUMENTO DE FILESYSTEM UFS COM SOLARIS VOLUME MANAGER (DISK SUITE) 

xinguilingue>df -k /u02 
Filesystem            kbytes    used   avail capacity  Mounted on 
/dev/md/pora5ds/dsk/d52 
                     66092522 65154179  277418   100%    /u02 

xinguilingue>metattach -s pora5ds d52 20g 
pora5ds/d52: Soft Partition has been grown 

xinguilingue>growfs -M /u02 /dev/md/pora5ds/rdsk/d52 
/dev/md/pora5ds/rdsk/d52:       176160768 sectors in 10752 cylinders of 64 tracks, 256 sectors 
        86016.0MB in 1792 cyl groups (6 c/g, 48.00MB/g, 5824 i/g) 
super-block backups (for fsck -F ufs -o b=#) at: 
 32, 98592, 197152, 295712, 394272, 492832, 591392, 689952, 788512, 887072, 
Initializing cylinder groups: 


==========================================

Comando 	Nmero 	Permisso
chmod 	000 	---------
chmod 	400 	r--------
chmod 	444 	r--r--r--
chmod 	600 	rw-------
chmod 	620 	-rw--w----
chmod 	640 	-rw-r-----
chmod 	644 	rw-r--r--
chmod 	645 	-rw-r--r-x
chmod 	646 	-rw-r--rw-
chmod 	650 	-rw-r-x---
chmod 	660 	-rw-rw----
chmod 	661 	-rw-rw---x
chmod 	662 	-rw-rw--w-
chmod 	663 	-rw-rw--wx
chmod 	664 	-rw-rw-r--
chmod 	666 	rw-rw-r--
chmod 	700 	rwx------
chmod 	750 	rwxr-x---
chmod 	755 	rwxr-xr-x
chmod 	777 	rwxrwxrwx
chmod 	4711 	-rws--x--x


=============================================
o /usr se resolve com o commit dos pacotes
o /var se resolve com a eliminacao dos mails
o / normalmente se resolve com eliminacao de lixo de nohup.out e smit scripts

#mudar caracteristicas de FS
chfs
#	#ver quem esta usando o FS
fuser /filesystem
#		#para terminar todos os processos no FS
fuser-kxuc /filesystem

================================================== 

## Criar LV

mklv -y lvxx -t jfs2 -c 2 rootvg 3	//criar lv

3  	//quantidade de pps

-c 2 	// fala se  mirror..ou ex -> melhor distribuicao entre os discos

================================================== 

		AUMENTAR FS
	HP-UX
vgdisplay vg00	// ver qto tem sombrando
sam		// para aumentar
	LINUX

ext2online (Linux)
[root@hofw007vr /]# lvextend -L +100MB /dev/rootvg/rootlv

lvextend -L +500M /dev/vg00/lvol1

  Rounding up size to full physical extent 128.00 MB
  Extending logical volume rootlv to 384.00 MB
  Logical volume rootlv successfully resized

[root@hofw007vr /]# ext2online /dev/rootvg/rootlv
ext2online  /dev/vg00/lvol1
ext2online v1.1.18 - 2001/03/18 for EXT2FS 0.5b

[root@hofw007vr /]# df -k .

Filesystem           		1K-blocks   Used 	 Available	  Use% 	Mounted on
/dev/mapper/rootvg-rootlv        380807    240105    121051    67% 	/
...........................................................................................

	AIX

> ' smit jfs2 '  ou 'jfs'		// programa para aumentar FS no AIX

## Aumentar File System por comando

	- chfs -a size=+<espao> <nome do filesystem>

	# chfs -a size=+1000000 /home   	// para aumentar 300 mega
	
chfs -a size=+50000 /oracle/PRD
chfs -a size=+50000 /dev/lv_optscm  	// para aumentar 25MB

spocpdsv83e
/dev/hd1
chfs -a size=+100M /dev/hd9var 	// para aumentar 50MB

...........................................................................................
		SMIT LV

##Aumentar o Max de Logical partitions

smit lv
Set Characteristic of a Logical Volume
Change a Logical Volume
Evandro Fior/Brazil/IBM: MAXIMUM NUMBER of LOGICAL PARTITIONS               [2048]       

------------------------------------------------------------------------

mount /dev/fslv02 /test		// montar o file system no /test
---

umount /test			// unmount file system
---

rmfs /test				// remover file system

	###Montagem

#montar disquete, leitor de CD
mount /mnt/floppy ; mount /mnt/cdrom

================================================== 

Mudar nome de FS

mkdir oratemp; chown owner:grupo /oratemp
2:59:05 PM: angarcia@br.ibm.com: verifica o ponto de montagem com df -k
2:59:33 PM: angarcia@br.ibm.com: umount /oraarc e mount /dev/xxxxx /oratemp
2:59:51 PM: angarcia@br.ibm.com: depois vai no /etc/filesystems e troca o nome da montagem
3:01:09 PM: angarcia@br.ibm.com: corrige tb o chmod

## RENOMEANDO UM FILESYSTEM - LINUX

Exemplo:

Renomear  /oraarc para  /oratemp

1) Desmontar o mesmo

[root@csc4dbp ~]# umount /oraarc

2) Criar o diretrio com o novo nome

[root@csc4dbp ~]# mkdir /oratemp

3) Dentro de /etc/fstab , renomear o nome antigo para o novo do filesystem (sempre fazer cpia de segurana do arquivo antes de alterar)

4) Dar as permisses do novo diretrio

[root@csc4dbp ~]# chmod 755 /oratemp

[root@csc4dbp ~]# chown -R oracle.dba Restore_124209

5) Montar o filesystem

[root@csc4dbp ~]# mount /oratemp

==================================================

		- / cheio

[root@hofw007vr /]# df -k .		// ver os FS em KB
Filesystem          		 1K-blocks      Used 	Available Use% 	Mounted on
/dev/mapper/rootvg-rootlv          253871    240109      	 655 	100%	 /

> ' du -ks *| sort -n ' 		// lista em ordem qual + consome
> ' lslv xxx '		// detalhar o lv
> ' lsvg '			// ver qual  o VG
> ' lsvg xxx '		// detalhar o VG

===============================================
	-  /var cheio : (/var/spool/mqueue)   (qdeamon)

> var/spool/mqueue		// diretrio de e-mail

> startsrc -s lpd 			// start no processo 

## Se for o clientmqueue rodar:	
sendmail -v -q


> find . -type f -mtime +1 -exec rm {} \;  	// deleta todos os arquivos mais velhos que um dia


sabem quando abrem chamado reclamando de /var com pouco espaco e agente descobre que o /var/spool/mqueue ta com um millhao de arquivinho tonto la dentro?
ai nao da pra fazer nem ls -l
15:13:46: Antonio Garcia: entao executa 
find /var/spool/mqueue -mtime +35 -exec rm {} \;
depois find /var/spool/mqueue -mtime +3 -exec rm {} \;
tem que ver a permissao
Francisco Jose Fogaca De Andrade: chmod 770  /var/spool/mqueue
chmod 6551 /usr/sbin/sendmail
chmod 6555 /usr/bin/bellmail

chmod 770  /var/spool/mqueue ; chmod 6551 /usr/sbin/sendmail ; chmod 6555 /usr/bin/bellmail


ou

		## /var cheio

Verifiquei em vrios Servidores, por exemplo honv001infr e hotv001infr que o mail do root estava zerado e estavam acumulando arquivos no spool e os mesmos no eram processados com o seguinte erro:

root@honv001infr:/ # sendmail -v -q

Running /var/spool/mqueue/lBT1WRHj060756 (sequence 1 of 1)
remarq... Connecting to local...
Operating system error
root@honv001infr:/ #

Pesquisando no PSDB e tambm na net, consegui descobrir que a unica coisa errada era a permisso do sendmail e do bellmail.

Aps alterar a permisso do sendmail para 6551 e o do bellmail para 6555 o problema foi sanado.

Creio que talvez algum CIRATS aplicado nos servidores tenha alterado essas permisses e desse jeito o mail local no funciona.

Caso tenham algum problema no /var e identifiquem que o sendmail no est processando a fila, verifiquem as permisses esto confome abaixo:

drwxrwx---    2 root    system    /var/spool/mqueue
-r-sr-s--x    3 root    system    /usr/sbin/sendmail
-r-sr-sr-x    1 root    mail      /usr/bin/bellmail

Se no estiver, o correto  s acertar as permisses:

chmod 770  /var/spool/mqueue
chmod 6551 /usr/sbin/sendmail
chmod 6555 /usr/bin/bellmail


Para fazer o teste  s digitar:

root@honv001infr:/ # date |mail -v root
root... Connecting to local...
root... Sent

Se a saida for Sent, ento est ok.


===============================================



fuser -uck <nome do filesystem> // mata todos os processos que estao no fs

umount <nome do filesystem> // desmontar o fs
mount <nome do filesystem> // montar filesystem

fsck
fsck -y <nome do filesystem> // corrige os erros que existem no fs, fs tem que estar unmount
fsck -n <nome do filesystem> // verifica os erros no fs

	Ambev

<acsxp6>, root, /etc # mount /dev/mgtws2   /mg/amb/local/tws2
Replaying log for /dev/mgtws2.
Failure replaying log: -1
mount: 0506-324 Cannot mount /dev/mgtws2 on /mg/amb/local/tws2: The media is not formatted or the format is not correct.
0506-342 The superblock on /dev/mgtws2 is dirty.  Run a full fsck to fix.

<acsxp6>, root, /etc # fsck -y /dev/mgtws2

==================================================
/usr que foi feito ml a pouco tempo

root@IBMSAP09 /usr/sap/QAL>uptime
  03:55PM   up 3 days,   4:08,  0 users,  load average: 2.60, 3.01, 3.19


smit install
3:55:34 PM: angarcia@br.ibm.com: smit install, software maintenance and utilities, Commit applied software updates , ai vai aparecer uma janela mais ou menos assim
Rhanier Leandro da Cruz/Brazil/IBM: estou na janela

  SOFTWARE name                                      		[all]                                                                                                +
  PREVIEW only? (commit operation will NOT occur)     	no                                                                                                  +
  COMMIT requisites?                                  		yes                                                                                                 +
  EXTEND file systems if space needed?                		yes                                                                                                 +
  DETAILED output?                                    		no                                                                                                  +

3:56:20 PM: angarcia@br.ibm.com: ai voce tecla entra
==================================================
/ cheio
smit.log
smit.script
...
/ cheio

find / -xdev -size +1024 | xargs ls -l|more

=============================================
========================================

## CRIANDO UM FILESYSTEM

Exemplo: Criando o filesystem /WEWITS/ENVIO

1) Criar o LV primeiro para que possa melhor organizao no S.O.

Verificar em qual VG ser criado, neste caso, criaremos no  vgPRD_01

root@cabrshorsap03:/# lsvg vgPRD_01
VOLUME GROUP:       vgPRD_01                 VG IDENTIFIER:  00cc052e00004c00000001142272f15b
VG STATE:           active                   PP SIZE:        4 megabyte(s)
VG PERMISSION:      read/write               TOTAL PPs:      133376 (533504 megabytes)
MAX LVs:            256                      FREE PPs:       70895 (283580 megabytes)
LVs:                4                        USED PPs:       62481 (249924 megabytes)
OPEN LVs:           4                        QUORUM:         5
TOTAL PVs:          8                        VG DESCRIPTORS: 8
STALE PVs:          0                        STALE PPs:      0
ACTIVE PVs:         8                        AUTO ON:        yes
MAX PPs per VG:     262144                   MAX PVs:        1024
LTG size (Dynamic): 256 kilobyte(s)          AUTO SYNC:      no
HOT SPARE:          no                       BB POLICY:      relocatable
root@cabrshorsap03:/#

Cria-se um LV para colocar o filesystem:

# smitty lvm

	Logical Volumes
	Add a Logical Volume

[TOP]                                                   [Entry Fields]
  Logical volume NAME                                [lv1_wenits01] ----> O nome do LV a ser criado ( Colocar sempre relacionado ao filesystem )
* VOLUME GROUP name                                   vgPRD_01 -----> Selecionar o VG onde ser criado o LV
* Number of LOGICAL PARTITIONS                       [500]  ------> Neste campo, verifica o total de pp do VG, e multiplica por um valor at chegar ao tamanho a ser criado do filesystem

Logical volume TYPE                                [jfs2]  ----> Verificar sempre como esto os outros filesystems ( lsvg -l vg )

  POSITION on physical volume                         center     ------> Alterar para center                                 
  RANGE of physical volumes                           maximum  ------> Alterar para maximum    

Estes valores referem-se a posio do fs no disco, espalhar o mximo no disco.

2) Criar o filesystem

# smitty jfs2

Add an Enhanced Journaled File System on a Previously Defined Logical Volume ----> Esta opo cria a partir de lv existente, se quiser criar direto sem lv definido, opo anterior.

* LOGICAL VOLUME name                                 lv1_wenits01                                    ----> Nome do LV criado
* MOUNT POINT                                        [/WEWITS/ENVIO]                                 ----> Nome do filesystem a criar
  Mount AUTOMATICALLY at system restart?              yes                                             +

3) Dar as permisses pro filesystem antes de montar e aps tambm, pois j ocorreram problemas com filesystems de banco/sap neste sentido.


==============================

Comando LSOF
---------------------

lsof	arquivo preso

$ lsof -u usurio 	Mostra os arquivos abertos identificado pelo nome de usurio, representado aqui pelo identificador usurio. 

$ lsof -g n 	Mostra os arquivos abertos por um determinado grupo, identificado aqui numericamente pela varivel n. 

$ lsof -p n 	Mostra os arquivos abertos por um determinado nmero de processo (PID), representado aqui pela varivel n. 

$ ls -u usurio -g n 	Existem ainda muitos outros parmetros que podem ser verificados com o comando: 


....................

Ofile can also be used to examine network sockets.  To list all open
files
associated with internet connections use the "-i" option. This will look
somewhat like the output from a "netstat -a -p".
You can see the network sockets by doing the following.
# lsof -i          # examine all network sockets
# lsof -i :22      # to see what is happening on PORT 22
# lsof -i :ssh     # to see what is happening on SERVICE ssh
# lsof -i @ghent.itt.com  # to see what CONNECTIONS this hostname is
using

To see what process are accessing a directory you can use the "+d"
# lsof +d /var/log/samba  # see what proccess are accessing this
directory

To run a lsof every x number of seconds use the "-r" option
# lsof -r 3 -i :22   # to see what is using port 22 every 3 seconds


  # ./lsof -p 980
   COMMAND  PID USER  FD  TYPE DEVICE SIZE/OFF   NODE NAME
   remotelp 980 root cwd  VDIR  121,0     1024      2 /
   remotelp 980 root txt  VREG  121,0    99704  78131 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root txt  VREG  121,0   534076 200740 /lib/libc.so.1
   remotelp 980 root txt  VREG  121,0   206964  78133
/usr/lib/libsocket.so.1.1
   remotelp 980 root txt  VREG  121,0    35300 200874 /lib/nss_dns.so.1
   remotelp 980 root txt  VREG  121,0    41312 200731 /lib/libsec.so
   remotelp 980 root txt  VREG  121,0   353980  78132 /usr/lib/libnsl.so
   remotelp 980 root txt  VREG  121,0   203240 200732 /lib/libseq.so
   remotelp 980 root txt  VREG  121,0    19160 200724 /lib/libevent.so
   remotelp 980 root   0r VCHR    3,2      0t0   8221 /dev/null
   remotelp 980 root   1w VCHR    3,2      0t0   8221 /dev/null
   remotelp 980 root   2w VREG  121,0    16978  28915 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root   3w VREG  121,0        0 450591 /
(/dev/vx/dsk/ROOTVOL)
   remotelp 980 root   4u VCHR   54,6      0t0
STR:/dev/sp-->strpipe
   remotelp 980 root   5u VCHR   54,7      0t0
STR:/dev/spx->strpipe
   remotelp 980 root   6u inet 0x025b7538  0t0        TCP *:printer
(LISTEN)

==================================================

Pessoal s pra informao caso alguem ainda no tenha se deparado com uma situao desta o /amb na acsxr8 tava com 92% de ocupao porm quando executava o du para verificar o tamanho dos arquivos no bate a informao que e trazida pelo comando, executando o comando fuser com as opes abaixo identificamos que o jacclient tava segurando a rea do fs, ai fiz um stop do processo e um kill ai liberou a rea no fs.

Chamado: 662368

<acsxr8>, root, /amb/local # df -k .
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     10116   92%     3079    11% /amb

<acsxr8>, root, /amb # du -ks * |sort -n
4       Bin
4       adsm
4       lost+found
4       pilotbin
4       samples
20      util
128     dm
276     boot
696     genbin
856     bkp
888     global
1012    gensbin
1784    cfg
2612    scripts
2812    operador
4212    sbin
5284    log
5572    bin
9320    eventbin
857828  local

<acsxr8>, root, / # fuser -cdfV /amb
/amb:
inode=4162   size=71868434     fd=1       37446
inode=4162   size=71868434     fd=1       57958

<acsxr8>, root, / # ps -ef|grep 37446
    root  37446      1   0   Apr 10      - 43:45 sh /amb/local/scm/client/jacclient restart
    root  57958  37446   0 07:41:18      -  0:00 sleep 10
    root 130494  46912   0 07:41:26  pts/0  0:00 grep 37446
<acsxr8>, root, / # ps -ef|grep 57958
    root 132628  46912   0 07:41:33  pts/0  0:00 grep 57958

<acsxr8>, root, / # /amb/local/scm/client/jacclient stop
Stopping the Tivoli Security Compliance Manager client.
The client stopped successfully.
<acsxr8>, root, / # df -k /amb
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     10096   92%     3079    11% /amb

<acsxr8>, root, / # ps -ef|grep 37446
    root  37446      1   0   Apr 10      - 43:45 sh /amb/local/scm/client/jacclient restart
    root  58014  37446   0 07:41:58      -  0:00 sleep 10
    root 132662  46912   0 07:42:03  pts/0  0:00 grep 37446
<acsxr8>, root, / # kill -9 37446

<acsxr8>, root, / # ps -ef|grep 37446
    root  51268  46912   1 07:42:13  pts/0  0:00 grep 37446

<acsxr8>, root, / # fuser -cdfV /amb
/amb:
inode=4162   size=71869744     fd=1       58028

<acsxr8>, root, / # ps -ef|grep 58028
    root  37448  46912   1 07:42:20  pts/0  0:00 grep 58028

<acsxr8>, root, / # df -k /amb
Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on
/dev/lv03          114688     80360   30%     3078    11% /amb

=============================================
# metattach <soft-partition-name> <size>
# growfs -M /<dir-name> /dev/md/rdsk/<soft-partition-name>


root@dborap016 # metattach d105 10g
root@dborap016 # growfs -M /acxp01 /dev/md/rdsk/d105 ----obsverdar que tem que ser o raw devic

OBS: Foi enviado pelo Daniel Carneiro

-VERIFICAES ANTES DO AUMENTO 

xinguilingue>metastat -s pora5ds -p 
pora5ds/d61 -p /dev/md/pora5ds/rdsk/d50 -o 255852672 -b 209715200 
pora5ds/d50 5 1 /dev/dsk/c2t5005076300CB0B15d0s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d1s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d2s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d3s0 \ 
         1 /dev/dsk/c2t5005076300CB0B15d4s0 
pora5ds/d59 -p /dev/md/pora5ds/rdsk/d50 -o 155189344 -b 100663296 
pora5ds/d52 -p /dev/md/pora5ds/rdsk/d50 -o 20971584 -b 134217728  -o 465567904 -b 41943040 
pora5ds/d51 -p /dev/md/pora5ds/rdsk/d50 -o 32 -b 20971520 

xinguilingue>metastat -s pora5ds 
pora5ds/d61: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 209715200 blocks (100 GB) 
        Extent              Start Block              Block count 
             0                255852672                209715200 

pora5ds/d50: Concat/Stripe 
    Size: 574636032 blocks (274 GB) 
    Stripe 0: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d0s0          0     No            Okay   No 
    Stripe 1: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d1s0          0     No            Okay   No 
    Stripe 2: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d2s0          0     No            Okay   No 
    Stripe 3: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d3s0          0     No            Okay   No 
    Stripe 4: 
        Device                             Start Block  Dbase        State Reloc Hot Spare 
        /dev/dsk/c2t5005076300CB0B15d4s0          0     No            Okay   No 

pora5ds/d59: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 100663296 blocks (48 GB) 
        Extent              Start Block              Block count 
             0                155189344                100663296 

pora5ds/d52: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 176160768 blocks (84 GB) 
        Extent              Start Block              Block count 
             0                 20971584                134217728 
             1                465567904                 41943040 

pora5ds/d51: Soft Partition 
    Device: pora5ds/d50 
    State: Okay 
    Size: 20971520 blocks (10 GB) 
        Extent              Start Block              Block count 
             0                       32                 20971520 

Device Relocation Information: 
Device                           Reloc  Device ID 
/dev/dsk/c2t5005076300CB0B15d0   No     - 
/dev/dsk/c2t5005076300CB0B15d1   No     - 
/dev/dsk/c2t5005076300CB0B15d2   No     - 
/dev/dsk/c2t5005076300CB0B15d3   No     - 
/dev/dsk/c2t5005076300CB0B15d4   No     - 


xinguilingue>ls -1 /dev/dsk/c2t50050*s2 | awk '{print "prtvtoc "$1"| tail -2 | head -1"}' | sh | \ 
awk '{SOMA += $6} END {printf("O diskset possui %.0f GB alocado.\n", (SOMA/2)/1048576) }' 

-PROCEDIMENTO PARA AUMENTO DE FILESYSTEM UFS COM SOLARIS VOLUME MANAGER (DISK SUITE) 

xinguilingue>df -k /u02 
Filesystem            kbytes    used   avail capacity  Mounted on 
/dev/md/pora5ds/dsk/d52 
                     66092522 65154179  277418   100%    /u02 

xinguilingue>metattach -s pora5ds d52 20g 
pora5ds/d52: Soft Partition has been grown 

xinguilingue>growfs -M /u02 /dev/md/pora5ds/rdsk/d52 
/dev/md/pora5ds/rdsk/d52:       176160768 sectors in 10752 cylinders of 64 tracks, 256 sectors 
        86016.0MB in 1792 cyl groups (6 c/g, 48.00MB/g, 5824 i/g) 
super-block backups (for fsck -F ufs -o b=#) at: 
 32, 98592, 197152, 295712, 394272, 492832, 591392, 689952, 788512, 887072, 
Initializing cylinder groups: 


==========================================

Comando 	Nmero 	Permisso
chmod 	000 	---------
chmod 	400 	r--------
chmod 	444 	r--r--r--
chmod 	600 	rw-------
chmod 	620 	-rw--w----
chmod 	640 	-rw-r-----
chmod 	644 	rw-r--r--
chmod 	645 	-rw-r--r-x
chmod 	646 	-rw-r--rw-
chmod 	650 	-rw-r-x---
chmod 	660 	-rw-rw----
chmod 	661 	-rw-rw---x
chmod 	662 	-rw-rw--w-
chmod 	663 	-rw-rw--wx
chmod 	664 	-rw-rw-r--
chmod 	666 	rw-rw-r--
chmod 	700 	rwx------
chmod 	750 	rwxr-x---
chmod 	755 	rwxr-xr-x
chmod 	777 	rwxrwxrwx
chmod 	4711 	-rws--x--x


=============================================

