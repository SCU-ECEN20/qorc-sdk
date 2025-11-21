@echo off
REM Launch PowerShell script while bypassing execution policy for this session
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\check_deps.ps1"
pause
