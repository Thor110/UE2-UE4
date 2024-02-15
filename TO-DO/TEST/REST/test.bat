for /F "tokens=*" %%A in (B.txt) do (
for %%A in (A.txt) do (
echo %%A
echo off
echo %%A > C.txt
echo %%A >> D.txt
)
)


(
echo microsoft
echo microsoft
echo microsoft
) > bs.txt

pause