
dica interessante para verificar espao no dg / solaris com veritas.

Os comandos mais comuns para verificar so os seguintes:

uxcaccrp# vxdg -g bigedg free
DISK         DEVICE       TAG          OFFSET    LENGTH    FLAGS
bigedg_00    c5t0d13s2    c5t0d13      53140416  1296      -

No caso abaixo, o vxassist no conseguiu exibir a quantidade, pois o dg no tem espao suficiente para criar um volume:

uxcaccrp# vxassist -g bigedg maxsize
VxVM vxassist ERROR V-5-1-752 No volume can be created within the given constraints

Reparem que no primeiro comando, o resultado  LENGHT 1296, que  o equivalente a 630Kb.

Para no haver confuso com os clculos, existem duas opes:

1 - Fui informado pelo Henrique da Embratel que os servidores solaris em geral tem o seguinte diretrio:

/var/suporte

com um script chamado totaldg.sh

## Verificar Memoria,processador, disco ( HP-UX )

	- print_manifest |more

	- grep Phys /var/adm/syslog/syslog.log ( memoria )

	- echo physmem /D | adb /stand/vmunix /dev/kmem ( memoria )

## Backup - HP-UX

	- /var/opt/ignite/logs

		ou
	- /var/opt/ignite/recovery


## HP-UX ( Impressora )

	- atn ls ( listar arquivos na fila )

## Ajustar monitor pela metade no HP-UX

	- resize

## Aumento de file system - HP-UX

	- HPUX AUMENTAR FS TIPO VXFS    

	- Verificar o tipo do FS #fstyp /dev/sp_sapdb_vg/oracle_PRO_sapdata09

	- Para mudar o lvol para 54Gb (54 * 1024 = 55296) (tamanho final do lvol independente de quanto tinha)#lvextend -L 55296 /dev/sp_sapdb_vg/oracle_PRO_sapdata09

	- Para Visualisar se aumentou corretamente# lvdisplay -v /dev/sp_sapdb_vg/oracle_PRO_sapdata09 | grep "Mbytes"LV Size (Mbytes) 55296

	- Para aumentar o FS tipo vxfs para 54Gb (54 * 1024 * 1024 = 56623104)#fsadm -F vxfs -b 56623104 /oracle/PRO/sapdata9
 
## Menus de SO

	- sam ( HP-UX ) 

## Swap - HP-UX

	- ps -el | sort -n +9 | tail -50 | pg 
	- swapinfo -a

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

* * * * HP UX * * * *


@@ Verificar file system

	# bdf

## Area de SWAP
10:57:10 AM: rodrigcj@br.ibm.com: # swapinfo -tam
             Mb      Mb      Mb   PCT  START/      Mb
TYPE      AVAIL    USED    FREE  USED   LIMIT RESERVE  PRI  NAME
dev        4096       0    4096    0%       0       -    1  /dev/vg00/lvol2
reserve       -    1863   -1863
memory     6304    3955    2349   63%
total     10400    5818    4582   56%       -       0    -

rodrigcj@br.ibm.com: para verificar os processo, que consomem
10:59:23 AM: rodrigcj@br.ibm.com:  ps -el | sort -n +9 | tail -50 | pg
10:59:39 AM: rodrigcj@br.ibm.com: os ultimos processos da lista o os que esto consumindo mais memoria
10:59:57 AM: rodrigcj@br.ibm.com: a nona coluna eh o nr d epaginas de memoria
11:00:03 AM: rodrigcj@br.ibm.com: vc multiplica por 4

