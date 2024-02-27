@echo off

set v_type=%1
set v_code=%2

if %v_type%=="pre" (
  echo Start Pre Processing
  echo:
  if %v_code%=="1" (goto :pre_1)
  if %v_code%=="2" (goto :pre_2)
  if %v_code%=="3" (goto :pre_3)
  if %v_code%=="4" (goto :pre_4)
  if %v_code%=="5" (goto :pre_5)
  if %v_code%=="6" (goto :pre_6)      
 ) 
 
if %v_type%=="post" (
  echo Start post Processing
  echo:
  if %v_code%=="1" (goto :post_1)  
  if %v_code%=="2" (goto :post_2) 
  if %v_code%=="3" (goto :post_3)
  if %v_code%=="4" (goto :post_4)
  if %v_code%=="5" (goto :post_5)
  if %v_code%=="6" (goto :post_6)  
)
goto :EXIT

:pre_1
  echo Primary Database Send
  REM add custom code here  
goto :EXIT

:pre_2
  echo Standby Database Apply
  REM add custom code here  
goto :EXIT

:pre_3
  echo Primary Server Graceful Switchover
  REM add custom code here  
goto :EXIT

:pre_4
  echo Standby Server Graceful Switchover
  REM add custom code here  
goto :EXIT

:pre_5
  echo Standby Database Activate
  REM add custom code here  
goto :EXIT

:pre_6
  echo Standby Database Read-Only
  REM add custom code here  
goto :EXIT

:post_1
  echo Primary Database Send
  REM add custom code here  
goto :EXIT

:post_2
  echo Standby Database Apply
  REM add custom code here  
goto :EXIT

:post_3
  echo Primary Server Graceful Switchover
  REM add custom code here  
goto :EXIT

:post_4
  echo Standby Server Graceful Switchover
  REM add custom code here  
goto :EXIT

:post_5
  echo Standby Database Activate
  REM add custom code here  
goto :EXIT

:post_6
  echo Standby Database Read-Only
  REM add custom code here  
goto :EXIT

:EXIT
goto :EOF