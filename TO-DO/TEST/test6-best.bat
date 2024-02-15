@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=* delims=." %%a in (A.txt) do (
    Rem echo %%a
    call :myInnerLoop "%%a"
)

Rem echo out of inner loop
goto :eof

:myInnerLoop
for /F "tokens=* delims=." %%b in (B.txt) do (
    Rem echo %~1
    Rem echo "y: " %%b
    if "%~1"=="%%b" (
        Rem echo next
        goto :next
    )
)
Rem echo "Log " %~1
echo %~1 >> C.txt

:next
goto :eof

pause