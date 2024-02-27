@echo off

set v_type=%1
set v_code=%2


if %v_type%=="post" (
  echo Start post Processing
  echo:
  if %v_code%=="6" (goto :post_6)  
)
goto :EXIT

:post_6
  call :writelog Starting service after Standby Database Read-Only
  echo exec dbms_service.start_service('reporting'); | sqlplus / as sysdba
  echo alter system register; | sqlplus / as sysdba
  call :writelog Service reporting started and registered
goto :EXIT

:writelog
echo %DATE% %TIME% %* >> C:\Temp\dbv_prepost.log
EXIT /B 0

:EXIT
goto :EOF