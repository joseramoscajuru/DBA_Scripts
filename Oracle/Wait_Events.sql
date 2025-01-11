Introduction

There are four types of numeric events

Immediate dumps
Conditional dumps
Trace dumps
Events that change database behaviour
Every event has a number which is in the Oracle error message range e.g. event 10046 is ORA-10046

-- Each event has one or more levels which can be

range e.g. 1 to 10
bitmask e.g. 0x01 0x02 0x04 0x08 0x10
flag e.g. 0=off; 1=on
identifier e.g. object id, memory address etc

Note that events change from one release to another. As existing events become deprecated and then obsolete, the event number is frequently reused for a new event. Note also that the message file sometimes does not reflect the events in the current release.

Many events change the behaviour of the database. Some testing events may cause the database to crash. Never set an event on a production database without obtaining permission from Oracle support. In addition, never set an event on a development database without first making a backup.

-- Enabling Events

-- Events can be enabled at instance level in the init.ora file using

event='<event> trace name context forever, level <level>';

-- Multiple events can be enabled in one of two ways

-- 1 - Use a colon to separate the event text e.g.

event = "10248 trace name context forever, level 10:10249 trace name context forever, level 10"

-- 2 - List events on consecutive lines e.g.

event = "10248 trace name context forever, level 10"

event = "10249 trace name context forever, level 10"

-- Note that in some versions of Oracle, the keyword "event" must be in the same case (i.e. always uppercase or always lowercase).

-- Events can also be enabled at instance level using the ALTER SYSTEM command:

ALTER SYSTEM SET EVENTS '<event> trace name context forever, level <level>';

-- Events are disabled at instance level using:

ALTER SYSTEM SET EVENTS '<event> trace name context off';

-- In Oracle 11.1 and above a more concise syntax is available:

ALTER SYSTEM SET EVENTS '10235';
ALTER SYSTEM SET EVENTS '10235 level 1';
ALTER SYSTEM SET EVENTS '10235 off';

-- Events can also be enabled at session level using the ALTER SESSION command:

ALTER SESSION SET EVENTS '<event> trace name context forever, level <level>';

-- Events are disabled at session level using:

ALTER SESSION SET EVENTS '<event> trace name context off';

-- In Oracle 11.1 and above a more concise syntax is available:

ALTER SESSION SET EVENTS '10235';
ALTER SESSION SET EVENTS '10235 level 1';
ALTER SESSION SET EVENTS '10235 off';

-- Events can be enabled in other sessions using ORADEBUG

-- To enable an event in a process use:

ORADEBUG EVEMT <event> LEVEL <level>

-- For example

ORADEBUG EVEMT 10053 LEVEL 1

-- The default level is 1 so the above can be rewritten as:

ORADEBUG EVEMT 10053 

-- To disable trace again:

ORADEBUG EVEMT 10053 OFF

-- The original syntax still works in Oracle 11g/12c:

-- To enable an event in a process use:

ORADEBUG EVENT <event> TRACE NAME CONTEXT FOREVER, LEVEL <level>

-- For example to set event 10046, level 12 in Oracle process 8 use

ORADEBUG SETORAPID 8
ORADEBUG EVENT 10046 TRACE NAME CONTEXT FOREVER, LEVEL 12

-- To disable an event in a process use:

ORADEBUG EVENT <event> TRACE NAME CONTEXT OFF

-- To enable an event in a session use:

ORADEBUG SESSION_EVENT &;tevent> TRACE NAME CONTEXT FOREVER, LEVEL <level>

-- For example:

ORADEBUG SESSION_EVENT 10046 TRACE NAME CONTEXT FOREVER, LEVEL 12

-- To disable an event in a session use:

ORADEBUG SESSION_EVENT <event> TRACE NAME CONTEXT OFF

-- For example:

ORADEBUG SESSION_EVENT 10046 TRACE NAME CONTEXT OFF

-- Events can be also enabled in other sessions using DBMS_SYSTEM.SETEV

-- The SID and the serial number of the target session must be obtained from V$SESSION.

-- For example to enable event 10046 level 8 in a session with SID 9 and serial number 29 use:

EXECUTE dbms_system.set_ev (9,29,10046,8,'');

-- To disable event 10046 in the same session use

EXECUTE dbms_system.set_ev (9,29,10046,0,'');

-- Listing All Events

-- Most events are numbered in the range 10000 to 10999. To dump all event messages in this range use:

SET SERVEROUTPUT ON
    
DECLARE 
  err_msg VARCHAR2(120);
BEGIN
  dbms_output.enable (1000000);
  FOR err_num IN 10000..10999
  LOOP
    err_msg := SQLERRM (-err_num);
    IF err_msg NOT LIKE '%Message '||err_num||' not found%' THEN
      dbms_output.put_line (err_msg);
    END IF;
  END LOOP;
END;
/

-- On Unix systems event messages are in the formatted text file:

$ORACLE_HOME/rdbms/mesg/oraus.msg

-- To print detailed event messages (Unix only) use the following script:

event=10000
while [ $event -ne 10999 ]
do
    event=`expr $event + 1`
    oerr ora $event
done

-- Listing Enabled Events

To check which events are enabled in the current session:

SET SERVEROUTPUT ON
DECLARE
    l_level NUMBER;
BEGIN
    FOR l_event IN 10000..10999
    LOOP
        dbms_system.read_ev (l_event,l_level);
        IF l_level > 0 THEN
            dbms_output.put_line ('Event '||TO_CHAR (l_event)||
            ' is set at level '||TO_CHAR (l_level));
        END IF;
    END LOOP;
END;
/

