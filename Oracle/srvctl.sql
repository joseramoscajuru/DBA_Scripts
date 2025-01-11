###########List all srvctl commands
srvctl h

###########Shutdown service
srvctl stop service -d database_name

###########Shutdown the database on all nodes
srvctl stop database -d <database_name> 

###########Shutdown a specific instance
srvctl stop instance -d database_name -i instance_name

###########Shutdown nodeapps (includes listener)
srvctl stop nodeapps -n node_name

! node_name is usually the hostname of the machine

###########Shutdown the listener
srvctl stop listener -n node_name
srvctl start listener -n uss1udb010amprb

###########Shutdown ASM
srvctl stop asm -n node_name

###########To Startup, replace stop with start.

If you shutdown the database it will stop the service since the service is dependent upon the database. The reverse is also true. If you startup the service it will implicitly startup the database.

###########To check to see if your services are running.

$CRS_HOME/bin/crs_stat -t

If you want more detailed information, drop the t.

$CRS_HOME/bin/crs_stat

srvctl start instance -d POARCSS -i POARCSS0

srvctl start database -d QOPE2P

