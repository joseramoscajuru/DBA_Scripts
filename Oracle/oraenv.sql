C:\Windows>type oraenv.bat
: oraenv.bat
::
:: An attempt to mimic the 'oraenv' Unix utility for changing your environment
:: for a specific database
:: The script accepts one optional parameter, the SID of the relevant database
::
@echo off
set RC=0
set NEW_ORACLE_HOME_BIN=
set NEW_ORACLE_HOME=
set EXEC_DIR=%~dp0
set NEW_ORACLE_SID=%1

IF [%NEW_ORACLE_SID%]==[] CALL :USE_ORACLE_SID
IF [%NEW_ORACLE_SID%]==[] GOTO FAIL_NO_SID
call :FIND_ORACLE_HOME
IF [%NEW_ORACLE_HOME_BIN%]==[] GOTO :ERROR_UNKNOWN_OHB

set ORACLE_SID=%NEW_ORACLE_SID%
set ORACLE_HOME=%NEW_ORACLE_HOME_BIN:\BIN\=%
set PATH=%ORACLE_HOME%\bin;%PATH%
echo ORACLE_HOME=%ORACLE_HOME%
echo ORACLE_SID=%ORACLE_SID%
echo PATH=%PATH%

GOTO EXIT

:USE_ORACLE_SID
set NEW_ORACLE_SID=%ORACLE_SID%
GOTO EO_SUBROUTINE

:FAIL_NO_SID
set RC=1
echo ERROR: Please either specify a database SID or set ORACLE_SID before calling
GOTO EXIT

:ERROR_UNKNOWN_OHB
set RC=2
echo ERROR: Unable to find service for %NEW_ORACLE_SID%
GOTO EXIT

:FIND_ORACLE_HOME
for /f "tokens=3,4" %%b in ('sc qc OracleService%NEW_ORACLE_SID% ^| findstr "BINARY_PATH_NAME"') do set NEW_ORACLE_HOME_BIN=%%~dpb

GOTO EO_SUBROUTINE

:EXIT
exit /b !RC!

:EO_SUBROUTINE