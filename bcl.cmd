@echo off
setlocal

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::   B A T C H   C L E A N   U P   U T I L I T Y   ::::
::::                                                 ::::
::::  Author:  Sergey Danilchenko <daniser@mail.ru>  ::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo Cleaning up...
for %%A in (%*) do rd /s /q "%%~nA" 2> nul
