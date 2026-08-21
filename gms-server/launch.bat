@echo off
@title BeiDou
chcp 65001
cd /d "%~dp0"

set "JAVA="
if exist "%~dp0jdk-21.0.11+10-jre\bin\java.exe" set "JAVA=%~dp0jdk-21.0.11+10-jre\bin\java.exe"
if not defined JAVA set "JAVA=G:\jdk\jdk-21.0.12\bin\java.exe"
if not exist "%JAVA%" set "JAVA="
if not defined JAVA (
  echo [ERROR] java not found.
  pause
  exit /b 1
)

set "JARFILE=%~dp0BeiDou.jar"
if not exist "%JARFILE%" set "JARFILE=%~dp0target\BeiDou.jar"

"%JAVA%" -Dspring.config.location=application.yml -jar "%JARFILE%"
pause