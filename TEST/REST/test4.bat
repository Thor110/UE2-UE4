Setlocal disableDelayedExpansion 
for /f "delims=" %%a in (B.txt) do ( 
for /f "delims=" %%c in (A.txt) do (                                      
if /i  "%%a"=="%%c" (
echo match
echo %%c > C.txt
pause
)

)
)