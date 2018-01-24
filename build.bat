@echo off
echo Deleting old InForm folder...
del /S /Q ..\qb64\InForm\*.* > nul
del /S /Q ..\qb64\UiEditor.exe > nul

rd ..\qb64\InForm\resources\ > nul
rd ..\qb64\InForm > nul

..\qb64\qb64 -s:exewithsource=false
..\qb64\qb64 -x "C:\Documents and Settings\Administrator\Desktop\InForm\InForm\UiEditor.bas"

xcopy InForm\*.* ..\qb64\InForm\*.* /Q

pause