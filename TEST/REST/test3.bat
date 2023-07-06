setlocal disableDelayedExpansion

set "fileA=A.txt"
set "fileB=B.txt"

for /f "usebackq delims=" %%A in ("%fileB%") do (
    set "found=%%A"
    Rem for /f "usebackq delims=" %found% in ("%fileA%") do (
        if "%%A"=="%fileB" (
            Rem set found=%%A
			echo %found% > C.txt
            goto :break
        )
    Rem )
    :break
    if not defined found (
        echo %%A
    )
)
pause