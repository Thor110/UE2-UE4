SETLOCAL EnableDelayedExpansion

for /F "tokens=* delims=." %%b in (B.txt) do (
    echo "x: " %~1
    echo "y: " %%b
    if "%~1"=="%%b" (
        echo next
    )
)
echo "Log " %~1
echo %~1 >> C.txt

pause