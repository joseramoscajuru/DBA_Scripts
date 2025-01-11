HOW TO CHECK ORACLE CLIENT VERSION


You can use the v$session_connect_info view against the current session ID (SID from the USERENV namespace in SYS_CONTEXT).

e.g.

SELECT
  DISTINCT
  s.client_version
FROM
  v$session_connect_info s
WHERE
  s.sid = SYS_CONTEXT('USERENV', 'SID');


Issue #1: Multiple Oracle clients are installed.

A very common issue I see in my environment is that I see both workstations and (app) servers with multiple Oracle clients, sometimes as many as four, and possibly with different versions and architectures. If you are relying on the PATH and running a utility like SQLPLUS or TNSPING you'll have one of two unacceptable results:

    either your PATH successfully resolves the executable and you get ONE version result
    or, the PATH didn't resolve the executable, and you get no results.

Either way, you are blind to possibly multiple client installations.

Issue #2: Instant Client doesn't have TNSPING, and sometimes doesn't include SQL*Plus.

If a computer has the Oracle Instant Client (not the full client), then TNSPING is not included, and SQLPLUS is an optional-addon. So can't rely on those tools being there. Furthermore, the Instant Client is sometimes installed as an unzip-and-go solution, so there's no Oracle Inventory and nothing in HKLM.

Issue #3: Client was installed using "Custom", and ODBC, OLEDB, ODP.Net, and JDBC were not installed.

Obvious case, there will be no ODBC or JDBC readme's to scrape version info from.

Solution:

One thing that the Instant client and the full client have in common is a DLL file called oraclient10.dll, oraclient11.dll, generally: oraclient*.dll. So let's traverse the hard disk to find them and extract their version info. PowerShell is amazing at this and can do it in one line, reminds me of home sweet Unix. So you could do this programatically or even remotely.

Here's the one-liner (sorry about the right scroll, but that's the nature of one-liners, eh?). Supposing you're already in a PowerShell:

gci C:\,D:\ -recurse -filter 'oraclient*.dll' -ErrorAction SilentlyContinue | %{ $_.VersionInfo } | ft -Property FileVersion, FileName -AutoSize

And if you're not in PowerShell, i.e. you're simply in a CMD shell, then no problem, just call powershell " ... ", as follows:

powershell "gci C:\,D:\ -recurse -filter 'oraclient*.dll' -ErrorAction SilentlyContinue | %{ $_.VersionInfo } | ft -Property FileVersion, FileName -AutoSize"


FileVersion            FileName
-----------            --------
11.2.0.3.0 Production  C:\NoSync\app\oracle\product\11.2\client_1\bin\oraclient...
11.2.0.3.0 Production  C:\oracle\product\11.2.0\client_1\bin\oraclient11.dll
11.2.0.3.0 Production  C:\oracle64\product\11.2.0\client_1\bin\oraclient11.dll


Caveats/Issues

    This obviously requires PowerShell, which is standard in Windows 7+ and Server 2008 R2+. If you have XP (which you shouldn't any more) you can easily install PowerShell.

    I haven't tried this on 8i/9i or 12c. If you are running 8i/9i, then there's a good chance you are on an old OS as well and don't have PowerShell and Heaven help you. It should work with 12c, since I see there is such a file oraclient12.dll that gets installed. I just don't have a Windows 12c client to play with yet.

In Unix

If you don’t know the location or version of installed Oracle product, you can find it from the inventory which is usually recorded in /etc/oraInst.loc

> cat /etc/oraInst.loc

inventory_loc=/export/oracle/oraInventory       **--> Inventory location**
inst_group=dba


> cd /export/oracle/oraInventory
> cd ContentsXML

Here look for a file inventory.xml

> cat inventory.xml
<?xml version="1.0" standalone="yes" ?>
<!-- Copyright (c) 1999, 2010, Oracle. All rights reserved. -->
<!-- Do not modify the contents of this file by hand. -->
<INVENTORY>
<VERSION_INFO>
   <SAVED_WITH>11.2.0.2.0</SAVED_WITH>
   <MINIMUM_VER>2.1.0.6.0</MINIMUM_VER>
</VERSION_INFO>
<HOME_LIST>
<HOME NAME="OraDB_11G" LOC="/export/oracle/product/11.2.0.2" TYPE="O" IDX="2">

Once you know the install location

export ORACLE_HOME=full path to install location
export ORACLE_HOME=/export/oracle/product/11.2.0.2
export PATH=$ORACLE_HOME/bin:$PATH

A simple "sqlplus" will give you the version of the client installed.

> sqlplus
SQL*Plus: Release 11.2.0.1.0 Production on Fri Mar 23 14:51:09 2012
Copyright (c) 1982, 2010, Oracle.  All rights reserved.

Enter user-name:


In Windows

Registry location variable in windows is INST_LOC

Start > Run > regedit > HKLM > Software > Oracle

Check the Inst_loc entry value which will be the software installed location.

You can use command prompt or you can navigate/explore to the oracle home location and then cd to bin directory to lauch sqlplus which will give you the client version information.


















