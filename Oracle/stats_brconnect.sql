nohup brconnect -u / -c -f stats -t /XNFE/INCTEHD,/XNFE/NFE_SRVSTA,/XNFE/INCTENFE,/XNFE/INNFEHD -f collect,sample  -s P100  &

nohup brconnect -u / -c -f stats -t all -f collect -e /XNFE/INCTEHD,/XNFE/NFE_SRVSTA,/XNFE/INCTENFE,/XNFE/INNFEHD -s P100 -p 10 &

nohup brconnect -u / -c -f stats -t all -f collect -s P100 -p 10 &

brconnect -u / -c -f stats -t all -f collect -e /XNFE/INCTEHD,/XNFE/NFE_SRVSTA,/XNFE/INCTENFE,/XNFE/INNFEHD -s P100 -p 10

brconnect -u / -c -f stats -t all -f collect -s P100 -p 10