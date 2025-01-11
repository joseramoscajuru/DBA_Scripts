$ ls -slh
total 24G
196M -rw-r----- 1 oracle oinstall 196M Sep 25 00:40 listener_lppwd523.log
 19G -rw-rw---- 1 oracle oinstall  19G Sep 25 00:40 ora_5696_47156398525168.trc
4.2G -rw-rw---- 1 oracle oinstall 4.2G Sep 25 00:40 ora_5696_47156398525168.trm

lppwd523@oracle{POPE0P1}:/usr/app/oracle/diag/tnslsnr/lppwd523/listener_lppwd523/trace>

$ fuser ora_5696_47156398525168.trc

ora_5696_47156398525168.trc:   407   424   428   470   498   511   594   714   765   843  1272  1351  2330  2340  2345  2354  2366  2551  2577  2990  3309  3441  3452  3498  3512  3515  4194  4198  4209  4219  4231  4262  4273  4301  4313  5092  5290  5360  5385  5415  5425  5442  5455  5475  5492  5544  5590  5696  5709  5948  6069  7857  7870  7931 10790 11602 11827 12227 12889 12914 12928 13122 13155 13164 13168 13217 13238 13755 14192 14233 14267 14294 14301 14313 14363 14753 14784 14846 14850 14860 14864 14872 14888 14891 14908 15455 15709 16144 16736 16986 17598 17925 18440 19339 21343 21887 23675 23812 24634 26799 27511 27527 27538 27603 27664 28139 28160 28164 28175 28190 28502 29546 29767 30242 30584 31663 32313 32428
lppwd523@oracle{POPE0P1}:/usr/app/oracle/diag/tnslsnr/lppwd523/listener_lppwd523/trace>

$ df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg_root-lv_oracle
                       40G   34G  4.4G  89% /usr/app/oracle
					   
lppwd523@oracle{POPE0P1}:/usr/app/oracle/diag/tnslsnr/lppwd523/listener_lppwd523/trace>
$ tail -50000 ora_5696_47156398525168.trc > trc_trace.bkp

lppwd523@oracle{POPE0P1}:/usr/app/oracle/diag/tnslsnr/lppwd523/listener_lppwd523/trace>
$ ls -altr
total 24205704
drwxrwxr-- 11 oracle oinstall        4096 Nov 26  2010 ..
-rw-r--r--  1 oracle oinstall     2902973 Sep 25 00:47 trc_trace.bkp
drwxrwxr--  2 oracle oinstall        4096 Sep 25 00:47 .
-rw-rw----  1 oracle oinstall  4410598312 Sep 25 00:47 ora_5696_47156398525168.trm
-rw-rw----  1 oracle oinstall 20143564313 Sep 25 00:47 ora_5696_47156398525168.trc
-rw-r-----  1 oracle oinstall   205330973 Sep 25 00:47 listener_lppwd523.log

lppwd523@oracle{POPE0P1}:/usr/app/oracle/diag/tnslsnr/lppwd523/listener_lppwd523/trace>
$ > ora_5696_47156398525168.trc

lppwd523@oracle{POPE0P1}:/usr/app/oracle/diag/tnslsnr/lppwd523/listener_lppwd523/trace>
$ df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg_root-lv_oracle
                       40G   15G   24G  39% /usr/app/oracle
					   
lppwd523@oracle{POPE0P1}:/usr/app/oracle/diag/tnslsnr/lppwd523/listener_lppwd523/trace>
$ ls -al
total 4515572
drwxrwxr--  2 oracle oinstall       4096 Sep 25 00:47 .
drwxrwxr-- 11 oracle oinstall       4096 Nov 26  2010 ..
-rw-r-----  1 oracle oinstall  205332484 Sep 25 00:48 listener_lppwd523.log
-rw-rw----  1 oracle oinstall     453816 Sep 25 00:48 ora_5696_47156398525168.trc
-rw-rw----  1 oracle oinstall 4410705494 Sep 25 00:48 ora_5696_47156398525168.trm
-rw-r--r--  1 oracle oinstall    2902973 Sep 25 00:47 trc_trace.bkp

