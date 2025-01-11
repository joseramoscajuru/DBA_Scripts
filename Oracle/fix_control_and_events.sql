ONLINE:

For _FIX_CONTROL to work, several conditions must be met:

1) The patch that is referenced must have the option to use _FIX_CONTROL.  
Using _FIX_CONTROL can't be used to backout any patch.  The patch (usually an Optimizer patch)  
has to be enabled to use the _FIX_CONTROL parameter.

2)  The patch must be installed and visible in the V$SYSTEM_FIX_CONTROL view.  To check this:

SQL>  SELECT * FROM V$SYSTEM_FIX_CONTROL;

Note: To determine which bug fixes have been altered one can select from the fixed views GV$SYSTEM_FIX_CONTROL, 
GV$SESSION_FIX_CONTROL or their V$ counterparts.

_fix_control=
5705630:ON
6055658:OFF
6120483:OFF
6399597:ON
6430500:ON
6440977:ON
6626018:ON
5099019:ON
18405517:2
14595273:ON
14255600:ON
13627489:ON
13077335:ON
9495669:ON
9196440:ON
8937971:ON
7168184:OFF
6972291ON

OFFLINE:

event=
10183
10027
10028
10142
10191
10995 level 2
31991
38068 level 100
38085
44951 level 1024
38087

ALTER SYSTEM SET "_fix_control"= '7324224:OFF','5705630:ON','6055658:OFF','6120483:OFF','6399597:ON',
                                 '6430500:ON','6440977:ON','6626018:ON','5099019:ON','18405517:2','14595273:ON',
								 '14255600:ON','13627489:ON','13077335:ON','9495669:ON','9196440:ON',
                                  '8937971:ON','7168184:OFF','6972291:ON'
SCOPE=BOTH;

EVENTS:
------

1) If you need to alter, add or remove an event, you have to enter the whole new list in the ALTER SYSTEM command and restart.

2) To remove all events, use:
           
SQL> ALTER SYSTEM RESET EVENT SCOPE=SPFILE SID='*' ;

System altered.

How To Set EVENTS In The SPFILE (Doc ID 160178.1)	

PARA CHECAR OS EVENTOS JA SETADOS:

1) Verificar ultimo STARTUP do banco no alert log

2) Executar o PL/SQL abaixo:

set serveroutput on
 declare
  event_level number;
 begin
  for i in 00000..99999 loop
     sys.dbms_system.read_ev(i,event_level);
     if (event_level > 0) then
        dbms_output.put_line('Event '||to_char(i)||' set at level '||
                             to_char(event_level));
     end if;
   end loop;
end;
 /

3) OS EVENTOS LISTADOS DEVEM SER INCLUIDOS NO COMANDO ABAIXO:

ALTER SYSTEM SET EVENT='10183 trace name context forever',
						'10027 trace name context forever',
						'10028 trace name context forever',
						'10142 trace name context forever',
						'10191 trace name context forever',
						'10995 trace name context forever, level 2',
						'31991 trace name context forever',
						'38068 trace name context forever, level 100',
						'38085 trace name context forever',
						'44951 trace name context forever, level 1024',
						'38087 trace name context forever' 
SCOPE=SPFILE;


4) RESTART DO BANCO E VERIFICAR EVENTOS:

4.1) VERIRIFICAR ALERT.LOG

4.2) EXECUTAR:

set serveroutput on
 declare
  event_level number;
 begin
  for i in 00000..99999 loop
     sys.dbms_system.read_ev(i,event_level);
     if (event_level > 0) then
        dbms_output.put_line('Event '||to_char(i)||' set at level '||
                             to_char(event_level));
     end if;
   end loop;
end;
 /
	