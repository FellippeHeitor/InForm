@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

rem Builds InForm-PE. Any make targets or variables given are passed on to make.
rem   --rebuild, /rebuild   delete the built programs first, then build everything again
set "MAKE_ARGS=%*"
if defined MAKE_ARGS (
    set "MAKE_ARGS=!MAKE_ARGS:--rebuild=rebuild!"
    set "MAKE_ARGS=!MAKE_ARGS:/rebuild=rebuild!"
)

set "USER_QB64PE_PATH="
for %%a in (%*) do (
    echo %%a | findstr /B /I "QB64PE_PATH=" >nul
    if !errorlevel! equ 0 (
        for /f "tokens=1,* delims==" %%i in ("%%a") do (
            set "USER_QB64PE_PATH=%%j"
        )
    )
)

set "MAKE_CMD="

if defined USER_QB64PE_PATH (
    if exist "!USER_QB64PE_PATH!\internal\c\c_compiler\bin\mingw32-make.exe" (
        set "MAKE_CMD=!USER_QB64PE_PATH!\internal\c\c_compiler\bin\mingw32-make.exe"
    )
)

if not defined MAKE_CMD (
    if exist ".\internal\c\c_compiler\bin\mingw32-make.exe" (
        set "MAKE_CMD=.\internal\c\c_compiler\bin\mingw32-make.exe"
    ) else if exist "..\QB64pe\internal\c\c_compiler\bin\mingw32-make.exe" (
        set "MAKE_CMD=..\QB64pe\internal\c\c_compiler\bin\mingw32-make.exe"
    )
)

if not defined MAKE_CMD (
    set "MAKE_CMD=mingw32-make.exe"
)

if not exist "%MAKE_CMD%" (
    where "%MAKE_CMD%" >nul 2>&1
    if errorlevel 1 (
        echo Error: %MAKE_CMD% not found. Please ensure QB64-PE and LLVM-MinGW are installed correctly, or provide the path using QB64PE_PATH.
        exit /b 1
    )
)

echo Using make from: %MAKE_CMD%
"%MAKE_CMD%" -f inform.mk !MAKE_ARGS!
