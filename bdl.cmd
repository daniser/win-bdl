@echo off
setlocal

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::   B A T C H   D O W N L O A D   U T I L I T Y   ::::
::::                                                 ::::
::::  Author:  Sergey Danilchenko <daniser@mail.ru>  ::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Clean up
set LIST=%*
if /i "%~1" == "/u" set LIST=%LIST:~3%
call "%~dp0bcl" %LIST%

:: Download files
:TRY
(call "%~dp0ldl" %* 2>> error.log) 2> nul || (
  timeout 1 /nobreak > nul
  goto TRY
)
