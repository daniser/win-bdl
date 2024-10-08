@echo off
setlocal

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
if not "%~3" == "" (%CURL% -sfkLo %3 %1) else (%CURL% -sfkLO %1)
if not "%~2" == "" popd

:: Log download errors into STDERR
if errorlevel 1 echo %DATE% %TIME:~0,-3% [%ERRORLEVEL%] %1 >&2
