@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=* delims=." %%a in (A.txt) do (
    call :myInnerLoop "%%a"
)

goto :eof

:myInnerLoop
for /F "tokens=* delims=." %%b in (B.txt) do (
    echo %~1
    echo %%b
    if "%~1"=="%%b" (
        goto :next
    )
)
echo %~1 >> C.txt

:next
goto :eof