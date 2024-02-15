setlocal EnableDelayedExpansion

for /F "tokens=*" %%A in (B.txt) do (
for %%A in (A.txt) do (
echo %%A > C.txt
) > D.txt
) > E.txt

pause