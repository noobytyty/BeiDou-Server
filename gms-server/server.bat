@echo off
title BeiDou Server Manager
cd /d "%~dp0"

set "PIDFILE=logs\server.pid"
set "LOGFILE=logs\server.log"
if not exist logs mkdir logs

set "JAVA="
if exist "%~dp0jdk-21.0.11+10-jre\bin\java.exe" set "JAVA=%~dp0jdk-21.0.11+10-jre\bin\java.exe"
if not defined JAVA set "JAVA=G:\jdk\jdk-21.0.12\bin\java.exe"
if not exist "%JAVA%" set "JAVA="
if not defined JAVA (
  where java > "%TEMP%\javapath.txt" 2>nul
  set /p JAVA=<"%TEMP%\javapath.txt"
)
if not defined JAVA (
  echo [ERROR] java not found.
  pause
  exit /b 1
)
echo Using Java: %JAVA%

set "ACTION=%1"
if "%ACTION%"=="start" goto start
if "%ACTION%"=="stop" goto stop
if "%ACTION%"=="restart" goto restart
if "%ACTION%"=="status" goto status
if "%ACTION%"=="log" goto log
goto help

:start
if exist "%PIDFILE%" (
  set /p OLDPID=<"%PIDFILE%"
  tasklist /fi "PID eq %OLDPID%" 2>nul | find "%OLDPID%" >nul
  if not errorlevel 1 (
    echo [INFO] Server already running, PID %OLDPID%
    goto end
  )
)
echo [INFO] Starting server...
set "JARFILE=%~dp0BeiDou.jar"
if not exist "%JARFILE%" set "JARFILE=%~dp0target\BeiDou.jar"
powershell -Command "Start-Process -FilePath '%JAVA%' -ArgumentList '-Dspring.config.location=application.yml','-jar','%JARFILE%' -WorkingDirectory '%~dp0' -RedirectStandardOutput '%LOGFILE%' -RedirectStandardError '%LOGFILE%' -WindowStyle Minimized"
timeout /t 6 /nobreak >nul
for /f "tokens=2 delims=," %%i in ('tasklist /fi "IMAGENAME eq java.exe" /fo csv /nh 2^>nul ^| findstr /i "java"') do (
  echo %%i> "%PIDFILE%"
  echo [INFO] Server started, PID %%i
  goto end
)
echo [WARN] Cannot confirm PID, check %LOGFILE%
goto end

:stop
if not exist "%PIDFILE%" (
  echo [INFO] No PID file, server may not be running
  goto end
)
set /p OLDPID=<"%PIDFILE%"
taskkill /f /pid %OLDPID% >nul 2>&1
echo [INFO] Stop signal sent to PID %OLDPID%
del "%PIDFILE%" 2>nul
goto end

:restart
call :stop
timeout /t 3 /nobreak >nul
goto start

:status
if exist "%PIDFILE%" (
  set /p OLDPID=<"%PIDFILE%"
  tasklist /fi "PID eq %OLDPID%" 2>nul | find "%OLDPID%" >nul
  if not errorlevel 1 (
    echo [INFO] Server is running, PID %OLDPID%
    goto end
  )
)
echo [INFO] Server is not running
goto end

:log
if not exist "%LOGFILE%" (
  echo [INFO] Log file not found
  goto end
)
echo [INFO] Live log - press Ctrl+C to exit (server keeps running)
powershell -Command "Get-Content -Path '%LOGFILE%' -Wait -Tail 50"
goto end

:help
echo.
echo  Usage: server.bat start ^| stop ^| restart ^| status ^| log
echo.
echo    start    Start server (background, log to logs\server.log)
echo    stop     Stop server
echo    restart  Restart server
echo    status   Show running status
echo    log      Tail live log (Ctrl+C to exit)
echo.

:end
pause
