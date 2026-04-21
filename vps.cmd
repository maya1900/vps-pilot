@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "BASH_EXE="

where bash >nul 2>nul
if %errorlevel%==0 (
  set "BASH_EXE=bash"
)

if not defined BASH_EXE if exist "%ProgramFiles%\Git\bin\bash.exe" (
  set "BASH_EXE=%ProgramFiles%\Git\bin\bash.exe"
)

if not defined BASH_EXE if exist "%ProgramFiles(x86)%\Git\bin\bash.exe" (
  set "BASH_EXE=%ProgramFiles(x86)%\Git\bin\bash.exe"
)

if not defined BASH_EXE (
  echo [VPS Pilot] 未找到 bash。
  echo 请先安装 Git for Windows 或启用 WSL。
  exit /b 1
)

"%BASH_EXE%" "%SCRIPT_DIR%vps" %*
