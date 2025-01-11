The percentage of available storage space is low (38.437693585510026 percent) . - 	Memria Real
The percentage of storage space **** is low (38.437693585510026 percent) . - 		File system                                                          
The percentage of swap space is low (38.437693585510026 percent) . - 		SWAP



To display the top 10 CPU consuming processes.								ps aux | head -1 ; ps aux | sort -rn +2 | head -10
To display the top 10 memory consuming processes.							ps aux | head -1 ; ps aux | sort -rn +3 | head 
	Note:
	10 is the default value for the head command.
To display the top 10 memory consuming processes by sz (virtual size in kilobytes of the data section of the process).	ps -ea1f | head -1 ; ps ea1f| sort -rm +9 | head
To display the processes in order of being penalized by the Virtual Memory Manager (sorted by the C column).		ps -eak1 | head -1 ; ps eak1| sort -rn +5 
To display the processes in priority order.									ps -eak1 | sort -n +6 | head
To display the processes in nice order									ps -eak1 | sort -n +7
To display the processes in CPU time/utilization order.							ps -vx | head -1 ; ps vx| grep -v PID | sort -rn +3 | head -10
To display the processes in order of real memory usage. The RSS value is the size of the working segment and the code segment in 1 kilobyte blocks.	ps -vx | head -1 ; ps vx| grep -v PID | sort -rn +6 | head -10
To display the processes in I/O order. PGIN represents the number of page ins caused by page faults. All AIX I/O is classified as page faults.		ps -vx | head -1 ; ps vx| grep -v PID | sort -rn +4 | head -10


ps vg | grep -v PID | sort -rn +6 | head -10	

svmon -Pu -t 3|grep -p Pid|grep '^.*[0-9]'		para ver que esta consumindo memoria real
...........................................................................
	- Wait State  :  

> ' topas '		( ver o consumo)
> ' ps aux | more '	( mostra oque causa o wait)		*no Solaris tem que entrar antes em ' /usr/ucb '

> shift m >> shift p ( )
> ps aux | head -10

>iostat

ps -elf | egrep -v "STIME|$LOGNAME" | sort +3 -r | head -n 15

...........................................................................
		SWAP no solaris

# cd /usr/ucb 
# ./ps aux |more
		SWAP

lsps -a 	ver quanto tem de swap

prstat -s size -n 10

svmon -P -t 1 |more		ele vai te dar o kra que masi come memoria
ps -ef |grep <numero do pid>
ps aux |head -10

======================================

	FIBRA
fcstat fcs5		// ver estado da fibra

======================================
lsof	arquivo preso

$ lsof -u usurio 	Mostra os arquivos abertos identificado pelo nome de usurio, representado aqui pelo identificador usurio. 

$ lsof -g n 	Mostra os arquivos abertos por um determinado grupo, identificado aqui numericamente pela varivel n. 

$ lsof -p n 	Mostra os arquivos abertos por um determinado nmero de processo (PID), representado aqui pela varivel n. 

$ ls -u usurio -g n 	Existem ainda muitos outros parmetros que podem ser verificados com o comando: 

ps aux|grep oraclePERP |awk '{print $3}'|

