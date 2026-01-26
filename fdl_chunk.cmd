@echo off
setlocal enabledelayedexpansion

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::    F I L E   D O W N L O A D   U T I L I T Y    ::::
::::                                                 ::::
::::  Author:  Sergey Danilchenko <daniser@mail.ru>  ::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Show usage info and fail if called without arguments
if "%~1" == "" (
  echo FDL URL [DIR [FN]]
  echo URL	URL address of the file to download
  echo DIR	Destination directory ^(must exist^)
  echo FN	Destination file name
  exit /b -1
)

:: Resolve curl binary location
set CURL=curl
if exist "%~dp0curl.exe" set CURL="%~dp0curl"

:: Initiate file download
:: 1 arg: download into cwd, auto-detect file name
:: 2 args: download into chosen dir, auto-detect file name
:: 3 args: download into chosen dir, use given file name

if not "%~2" == "" pushd %2

set CHUNKSIZE=16384
for /f "delims=" %%S in ('%CURL% -sfkLI -o nul -w %%header{content-length} %1') do set FILESIZE=%%S
set FILENAME=%~3
if "%FILENAME%" == "" for /f "delims=" %%N in ('%CURL% -sfkLO -w %%{filename_effective} -r 0-99 %1') do set FILENAME=%%N
:START
del %FILENAME% 2> nul

for /l %%O in (0, %CHUNKSIZE%, %FILESIZE%) do (
  set /a END=%%O+CHUNKSIZE-1
  if !END! geq %FILESIZE% set /a END=FILESIZE-1
  set RANGE=%%O-!END!
  %CURL% -sfkL -r !RANGE! --connect-timeout 10 -Y 100 -y 5 %1 >> %FILENAME%
  if errorlevel 1 (
    :: Log download errors into STDERR
    echo %DATE% %TIME:~0,-3% [!ERRORLEVEL!] %1 >&2
    :: Remove malformed file
    :: del %FILENAME% 2> nul
    if defined RETRIED goto END
    set RETRIED=1
    goto START
  )
)

:END
if not "%~2" == "" popd
