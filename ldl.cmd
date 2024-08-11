@echo off
setlocal

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::    L I S T   D O W N L O A D   U T I L I T Y    ::::
::::                                                 ::::
::::  Author:  Sergey Danilchenko <daniser@mail.ru>  ::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Prepare variables for substitution
for /f "skip=1 tokens=1-3" %%X in ('wmic path Win32_UTCTime get day^,month^,year') do (
  set DAY=0%%X
  set MONTH=0%%Y
  set YEAR=%%Z
  goto START
)

:START

:: Trim variables
set DAY=%DAY:~-2%
set MONTH=%MONTH:~-2%

:: Retrieve arguments
set LIST=%*

:: Save current code page, then switch to UTF-8
if /i "%~1" == "/u" (
  set LIST=%LIST:~3%
  for /f "skip=3 tokens=1,2 delims=:" %%M in ('mode con cp') do set CP=%%N
  chcp 65001 > nul
)

:: Parse and process download queue(s)
echo Downloading files...
for %%A in (%LIST%) do if exist "%%~A" (
  md "%%~nA" 2> nul
  echo Processing %%~nxA...
  for /f "usebackq tokens=1*" %%B in ("%%~A") do start /b cmd /c call "%~dp0fdl" %%B "%%~nA" %%C > nul
) else echo Queue file %%~A not found.

:: Restore initial code page
if /i "%~1" == "/u" chcp %CP% > nul
