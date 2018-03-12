@echo off
echo Deleting old InForm folder...
del /S /Q ..\qb64\InForm\*.* > nul
del /S /Q ..\qb64\UiEditor.exe > nul

rd ..\qb64\InForm\resources\ > nul
rd ..\qb64\InForm > nul

xcopy InForm\*.* ..\qb64\InForm\*.* /Q

..\qb64\qb64 -x "C:\Documents and Settings\Administrator\Desktop\InForm\InForm\UiEditor.bas" -o "C:\Documents and Settings\Administrator\Desktop\qb64\UiEditor.exe"
..\qb64\qb64 -x "C:\Documents and Settings\Administrator\Desktop\InForm\InForm\UiEditorPreview.bas" -o "C:\Documents and Settings\Administrator\Desktop\qb64\InForm\UiEditorPreview.exe"

pause