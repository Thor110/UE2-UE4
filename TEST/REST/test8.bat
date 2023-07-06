@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=* delims=." %%a in (A.txt) do (
	for /F "tokens=* delims=." %%b in (B.txt) do (
    echo %%a
    if "%%a"=="%%b" (
echo %~1 >> C.txt
    )
)

)
pause