@echo off

title Whale Watchdog

echo This script will kill and restart walog.exe 
echo if Whale.mail did not change for more than one hour
echo.

C:
cd C:\WALLOG

set idle=0
set norun=0
set old=INIT

echo %date% %time:~0,5% Watchdog Start
echo %date% %time:~0,5% Watchdog Start>> waldog.log

:loop
sleep 1
set/a norun=norun+1
tasklist | find "walog.exe" > nul
if not errorlevel 1 set norun=0
if %norun%==60 call :action1

call :getsize "Whale.mail"
rem echo %date% %time:~0,5% wallog.mail: %ftime% %size% bytes
if not "%old%"=="%ftime%" set idle=0
set old=%ftime%
title Whale Watchdog - idle for %idle% seconds - %norun%
set/a idle=idle+1
if %idle%==3700 call :action
goto :loop


:getsize
set ftime=%~t1
set size=%~z1
goto :eof


:action
set idle=0
taskkill /im walog.exe
sleep 10
taskkill /f /im walog.exe
sleep 10
:action1
start walog.exe
echo %date% %time:~0,5% Watchdog Action
echo %date% %time:~0,5% Watchdog Action>> waldog.log
goto :eof
