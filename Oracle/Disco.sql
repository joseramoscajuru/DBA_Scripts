errpt de disco

lsvg -p xxxvg	// para ver em quais discos estao o vg

----------------------------------------------------------------------------------------------------------------------

qapan:[root]/> lsdev -Cc disk |grep hdisk234
hdisk234 Available 1A-08-02     IBM FC 2105

qapan:[root]/> datapath query device |grep hdisk234
    1        fscsi2/hdisk234           OPEN   NORMAL    4483240          0

lsdev -Cc adapter

[root@SAPASQ01-RIG]# lsvpcfg |grep hdisk4

vpath0 (Avail pv dblogvg) 31727499 = hdisk2 (Avail ) hdisk17 (Avail ) hdisk58 (Avail ) hdisk87 (Avail ) hdisk104 (Avail ) hdisk112 (Avail ) hdisk120 (Avail ) hdisk128 (Avail )
vpath3 (Avail pv s0qvg1) 20727499 = hdisk20 (Avail ) hdisk26 (Avail ) hdisk31 (Avail ) hdisk34 (Avail ) hdisk44 (Avail ) hdisk53 (Avail ) hdisk57 (Avail ) hdisk63 (Avail )
vpath5 (Avail pv s0qvg1) 40727499 = hdisk23 (Avail ) hdisk29 (Avail ) hdisk32 (Avail ) hdisk39 (Avail ) hdisk49 (Avail ) hdisk54 (Avail ) hdisk60 (Avail ) hdisk66 (Avail )
vpath6 (Avail pv dblogvg) 50F27499 = hdisk5 (Avail ) hdisk18 (Avail ) hdisk61 (Avail ) hdisk89 (Avail ) hdisk105 (Avail ) hdisk113 (Avail ) hdisk121 (Avail ) hdisk129 (Avail )
vpath10 (Avail pv s0qvg1) 50627499 = hdisk25 (Avail ) hdisk30 (Avail ) hdisk33 (Avail ) hdisk42 (Avail ) hdisk50 (Avail ) hdisk55 (Avail ) hdisk62 (Avail ) hdisk67 (Avail )
vpath17 (Avail pv stgvg) 71027499 = hdisk14 (Avail ) hdisk51 (Avail ) hdisk82 (Avail ) hdisk102 (Avail ) hdisk110 (Avail ) hdisk118 (Avail ) hdisk126 (Avail ) hdisk134 (Avail )
vpath18 (Avail pv stgvg) 71827499 = hdisk16 (Avail ) hdisk56 (Avail ) hdisk84 (Avail ) hdisk103 (Avail ) hdisk111 (Avail ) hdisk119 (Avail ) hdisk127 (Avail ) hdisk135 (Avail )

[root@SAPASQ01-RIG]# datapath query adapter

Active Adapters :2

Adpt#     Name   State     Mode             Select     Errors  Paths  Active
    0   fscsi0  NORMAL   ACTIVE           35143817          0     60      60
    1   fscsi1  NORMAL   ACTIVE           35286136          0     60      60


lsvg -p rootvg
rootvg:
PV_NAME           PV STATE          TOTAL PPs   FREE PPs    FREE DISTRIBUTION
hdisk0            active            447         178         19..00..00..69..90
hdisk1            missing           447         149         54..00..00..05..90

Existem dois filesystems que no esto com mirror para o rootvg:
[sapaf11p:root:/:] lsvg -l rootvg
rootvg:
LV NAME TYPE LPs PPs PVs LV STATE MOUNT POINT
hd5 boot 		1   2   2 		closed/syncd 	N/A
hd6 paging 	80 160 2 		open/stale 	N/A
paging00 paging 	80 160 2 		open/stale 	N/A
hd8 jfs2log 	1   2   2 		open/stale 	N/A
hd4 jfs2 		1   2   2 		open/stale 	/
hd2 jfs2 		26 52 2 		open/stale 	/usr
hd9var jfs	2	1   2   2 		open/stale 	/var
hd3 jfs2 		2   4   2 		open/stale 	/tmp
hd1 jfs2 		1   2   2 		open/stale 	/home
hd10opt jfs2 	1   2   2 		open/stale 	/opt
lg_dumplv sysdump 16 16 1 		open/syncd 	N/A
fslv00 jfs2 	4   8   2 		open/stale 	/opt/Tivoli
fslv01 jfs2 	1   2   2 		open/stale 	/opt/IBM
fslv02 jfs2 	1   2   2 		open/stale 	/so_ibm
fslv03 jfs2 	64 128 2 		open/stale 	/usr/sap/AFP
fslv04 jfs2 	2   4   2 		open/syncd 	/oracle
fslv05 jfs2 	2   4   2 		open/stale 	/oracle/AFP/920_64
fslv06 jfs2 	1   2   2 		open/stale 	/oracle/client/92x_64
fslv07 jfs2 	12 12 1 		open/syncd 	/tws
fslv08 jfs2 	1   1   1 		open/syncd 	/producao/backup
[sapaf11p:root:/:]


PERMM

[sapbi00q:root:/:]fget_config -Av | grep hdisk18
hdisk18  dac1   16

[sapbi00q:root:/:]fget_config -Av

---dar0---

User array name = 'DS4800_SAP'
dac0 ACTIVE dac1 ACTIVE

Disk     DAC   LUN Logical Drive
utm             31
hdisk2   dac0    0 94

----------------------------------------------------------------------------------------------------------------------
[root@n27sp03:/] > dd if=/dev/hdisk2 of=/dev/null bs=1024
dd: 0511-051 The read failed.
: The media surface is damaged.
8331824+0 records in.
8331824+0 records out.

----------------------------------------------------------------------------------------------------------------------

SPDB100STA-ROOT:/dev>pcmpath wwpn

Invalid command

Usage:  pcmpath query adapter [n]
        pcmpath query device [n/-d <device_model>]
        pcmpath query adaptstats [n]
        pcmpath query devstats[n/-d <device_model>]
        pcmpath query portmap
        pcmpath query essmap
        pcmpath query wwpn
        pcmpath query version
        pcmpath set adapter <n> online/offline
        pcmpath set device <n> path <m> online/offline
        pcmpath set device <n>/(<n> <n>) algorithm rr/fo/lb
        pcmpath set device <n>/(<n> <n>) hc_interval <t>
        pcmpath set device <n>/(<n> <n>) hc_mode nonactive/enabled/failed
        pcmpath open device <n> path <m>
        pcmpath clear device <n>/(<n> <n>) count error/all
        pcmpath disable/enable ports <connection> ess <essid>
           single port          = R1-Bx-Hy-Zz
           all ports on card    = R1-Bx-Hy
           all ports on bay     = R1-Bx
           refer portmap output for the connection string and ESS serial number

        Examples of valid device model include:
         2105    - Displays all 2105 models (ESS)
         2145    - Displays all 2145 devices
         1750    - Displays all 1750 devices (DS 6000)
         2107    - Displays all 2107 devices (DS 8000)




====================================================================
Abrir chamado de HW caso aconteca:


Chamado: P2F2SZP

root@gw01ambev[/][69]# lsvg -p rootvg
rootvg:
PV_NAME           PV STATE    TOTAL PPs   FREE PPs    FREE DISTRIBUTION
hdisk0            active      542         74          00..00..00..00..74
hdisk1            missing     542         25          00..00..01..14..10

root@gw01ambev[/][43]# dd if=/dev/hdisk1 of=/dev/null count=1 bs=512
dd: 0511-051 The read failed.
: The device is not ready for operation.
0+0 records in.
0+0 records out.
root@gw01ambev[/][44]# lqueryvg -Atp hdisk1
0516-062 lqueryvg: Unable to read or write logical volume manager
        record. PV may be permanently corrupted. Run diagnostics


root@gw01ambev[/][76]# syncvg -v rootvg			//Tentei Sincronizar o VG sem sucesso conforme abaixo.
0516-068 lresynclv: Unable to completely resynchronize volume. Run
        diagnostics if neccessary.
0516-932 /etc/syncvg: Unable to synchronize volume group rootvg.
0516-068 lresynclv: Unable to completely resynchronize volume. Run
        diagnostics if neccessary.
0516-932 /etc/syncvg: Unable to synchronize volume group rootvg.
0516-068 lresynclv: Unable to completely resynchronize volume. Run
        diagnostics if neccessary.

