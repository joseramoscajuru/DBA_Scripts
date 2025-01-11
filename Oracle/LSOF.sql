lsof (check for files marked as deleted)

http://www.ibm.com/developerworks/aix/library/au-lsof.html 
2:30:03 PM: regiscp@br.ibm.com - Regis Correa Pavinato/Brazil/IBM: 1)Check for files marked as deleted
/usr/sbin/lsof -s | grep -i oracle | grep -i deleted

Ex.:
COMMAND     PID      USER   FD      TYPE             DEVICE  SIZE/OFF                 NODE NAME

oracle    23126    oracle   41w      REG              253,8      1728              4292647 /usr/app/oracle/diag/asm/+asm/+ASM2/trace/+ASM2_diag_23126.trc (deleted)
oracle    23126    oracle   42w      REG              253,8       142              4292653 /usr/app/oracle/diag/asm/+asm/+ASM2/trace/+ASM2_diag_23126.trm (deleted)
oracle    23128    oracle   36w      REG              253,8       830              4292662 /usr/app/oracle/diag/asm/+asm/+ASM2/trace/+ASM2_ping_23128.trc (deleted)
oracle    23128    oracle   37w      REG              253,8        61              4292663 /usr/app/oracle/diag/asm/+asm/+ASM2/trace/+ASM2_ping_23128.trm (deleted)

2) Navigate to file location:
cd /proc/23126/fd

3) ls -l to find the file reference (listed in FD)

41 - > 4292647 /usr/app/oracle/diag/asm/+asm/+ASM2/trace/+ASM2_diag_23126.trc

4) Truncade file:
> 41 

