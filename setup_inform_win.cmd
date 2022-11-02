@rem InForm for QB64-PE Setup script
@echo off

%~d0
cd %~dp0

rem Clean old .exe files from InForm
del /Q InForm\UiEditor.exe InForm\UiEditorPreview.exe

rem Check for which compiler for use in your QB64/QB64pe installation
echo Compiling InForm...

if exist qb64.exe (
    qb64 -x -p -o InForm/UiEditor.exe InForm/UiEditor.bas  
    qb64 -x -p  -s:exewithsource=true -o InForm/UiEditorPreview.exe InForm/UiEditorPreview.bas  
    cd InForm
    UiEditor
    goto end)

if exist qb64pe.exe (
    qb64pe -x -p -o InForm/UiEditor.exe InForm/UiEditor.bas  
    qb64pe -x -p  -s:exewithsource=true -o InForm/UiEditorPreview.exe InForm/UiEditorPreview.bas  
    cd InForm
    UiEditor
    goto end)

echo qb64 or qb64pe not found. Setup Terminated.

:end
endlocal
