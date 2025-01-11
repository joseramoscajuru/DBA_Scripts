#Listar BDs registrados com Listener
lsnrctl services <Nome do listener>
	#EXEMPLOS:
	lsnrctl services LISTENERAIM
	lsnrctl services LISTENER_USS1UDB010AMPRB

#Forar um BD a registrar com o listener
alter system register;

#Checar que portas o Listener est "escutando"
netstat -a|grep LISTEN|grep -i 152

PARA RENOMEAR O LISTENER.LOG:

% cd /u01/app/oracle/product/9.2.0/network/log
% lsnrctl set log_status off
% mv listener.log listener.old
% lsnrctl set log_status on


$ lsnrctl
LSNRCTL> set current_listener <listener_name> # necessrio apenas se o listener tiver nome diferente de LISTENER, que  o default
LSNRCTL> set password
Password: <enter password>
LSNRCTL> # entre com os comandos que forem necessrios, por exemplo:
LSNRCTL> status / reload



sqlplus teste/steste@crmvaprd


#### Listerner UP
ERROR:
ORA-01017: invalid username/password; logon denied

##### Checar config do listener
more $ORACLE_HOME/network/admin/listener.ora
# l vo estar o pass e os bancos que aquele listener cuida

###Path padro do listener no 11.2.0
/usr/app/oracle/product/11.2.0/network/admin


#Listar BDs registrados com Listener
lsnrctl services <Nome do listener>
	#EXEMPLOS:
	lsnrctl services LISTENERAIM
	lsnrctl services LISTENER_USS1UDB010AMPRB

#Forar um BD a registrar com o listener
alter system register;

#Checar que portas o Listener est "escutando"
netstat -a|grep LISTEN|grep -i 152


