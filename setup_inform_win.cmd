@rem InForm for QB64-PE Setup script
@echo off

%~d0
cd %~dp0

rem Adjust the path below to point to mingw32-make.exe in your QB64 installation
echo Compiling InForm...
..\QB64pe\internal\c\c_compiler\bin\mingw32-make.exe -f makefile.inform clean OS=win QB64PE_PATH=../QB64pe/
..\QB64pe\internal\c\c_compiler\bin\mingw32-make.exe -f makefile.inform OS=win QB64PE_PATH=../QB64pe/
