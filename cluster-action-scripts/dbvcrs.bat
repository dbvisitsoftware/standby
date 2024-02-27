@echo off
setlocal

rem Dbvisit Multiplatform Action Script Used to start & stop Dbvisit in Oracle SEHA Windows Environment
rem 
rem Version 1.0.0 February 2024

set action=%~1
set service_name=%~2
set SRVM_PROPERTY_DEFS="-Duser.language=en"
if "%action%"=="" goto :show_usage
if %service_name%=="" goto :show_usage
shift
shift

:main
if /i "%action%"=="start" (
    call :start_dbvisit
) else if /i "%action%"=="stop" (
    call :stop_dbvisit
) else if /i "%action%"=="check" (
    call :check_dbvisit
) else if /i "%action%"=="clean" (
    call :clean_dbvisit
) else (
    echo Invalid action: %action%
    goto :show_usage
)

goto :eof

:start_dbvisit
echo Starting service %service_name%
sc start "%service_name%"
goto :cleanexit

:stop_dbvisit
echo Stopping service %service_name%
sc stop "%service_name%"
goto :cleanexit

:check_dbvisit
echo Running status check on %service_name% resource
for /F "tokens=3 delims=: " %%H in ('sc query %service_name% ^| findstr "        STATE"') do (
  if /I "%%H" NEQ "RUNNING" (
	echo Submitted check for %service_name% with result not running correctly, return 1
    goto :errorexit
  )
  if /I "%%H" == "RUNNING" (
	echo Submitted check for %service_name% with result running correctly, return 0
    goto :cleanexit
  ) 
)

:clean_dbvisit
echo Cleaning...
taskkill /f /im dbvagentmanager.exe
goto :cleanexit

:show_usage
echo Usage: %0 [start^|stop^|check^|clean] [service_name]
goto :cleanexit

:cleanexit
exit /b 0
rem exit 0
  
:errorexit
rem exit /b 1
exit 1
  
:exit
endlocal
goto :EOF