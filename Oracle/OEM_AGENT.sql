ir no diretorio
/usr/app/oracle/oms/10.2.0/oms10g/opmn/bin 

startar o oms

opmnctl start all

se tiver algum down start manual:

opmnctl startproc ias-component=

ir no diretorio
/usr/app/oracle/oma/agent10g/bin

startar o agent

emctl start agent
emctl status agent
emctl stop agent

_______________________________________________________________


start stop OEM

opmnctl stopall 
opmnctl startall

opmnctl status


emctl start oms 	Starts the Oracle Application Server components required to run the Management Service J2EE application. Specifically, this command starts OPMN, the Oracle HTTP Server, and the OC4J_EM instance where the Management Service is deployed.

Note: The emctl start oms command does not start Oracle Application Server Web Cache. For more information, see "Starting and Stopping Oracle Application Server Web Cache".
emctl stop oms 	Stops the Management Service.

Note that this command does not stop the other processes that are managed by the Oracle Process Manager and Notification Server (OPMN) utility.To stop the other Oracle Application Server components, such as the Oracle HTTP Server and Oracle Application Server Web Cache, see "Starting and Stopping Oracle Enterprise Manager 10g Grid Control".
emctl status oms 	Displays a message indicating whether or not the Management Service is running. 
5:09:06 AM: Juliano Prisco Dos Santos: http://docs.oracle.com/html/B12013_03/emctl.htm

