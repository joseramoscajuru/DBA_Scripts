[root@rrpvsao01a0401 /]# systemctl status mysqld
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2021-08-06 13:51:06 -03; 4 days ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
 Main PID: 53324 (mysqld)
   CGroup: /system.slice/mysqld.service
           └─53324 /usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid

Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.093368Z 0 [Note] Skipping generation of SSL certificates as certificate files a...irectory.
Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.096375Z 0 [Warning] CA certificate ca.pem is self signed.
Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.096448Z 0 [Note] Skipping generation of RSA key pair as key files are present i...irectory.
Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.098894Z 0 [Note] Server hostname (bind-address): '*'; port: 3306
Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.099188Z 0 [Note] IPv6 is available.
Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.099204Z 0 [Note]   - '::' resolves to '::';
Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.099232Z 0 [Note] Server socket created on IP: '::'.
Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.152161Z 0 [Note] Failed to start slave threads for channel ''
Aug 06 13:51:06 rrpvsao01a0401.record.cloud mysqld[53321]: 2021-08-06T16:51:06.219685Z 0 [Note] Event Scheduler: Loaded 0 events
Aug 06 13:51:06 rrpvsao01a0401.record.cloud systemd[1]: Started MySQL Server.
Hint: Some lines were ellipsized, use -l to show in full.




systemctl stop mysql

or

service mysql stop

sudo usermod -d /var/lib/mysql/ mysql

systemctl start mysql

or

service start mysql
