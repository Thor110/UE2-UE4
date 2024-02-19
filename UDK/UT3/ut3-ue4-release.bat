title Star Wars Republic Commando UE4 Porting Script

REM set first to current directory ( where the script starts executing from )
set first=%cd%

@echo off

cls
echo this script isn't finished yet, exiting . . .
pause
exit

cls
REM enter directories of required programs
:UNREAL
SET /P level="Enter your Unreal Tournament 3 Directory:"
if exist "%level%\Binaries\UT3.exe" (
  echo UT3 Found.
) else (
  echo UT3 Not Found!
  goto :UNREAL
)

:UMODEL
SET /P model="Enter your UModel Directory:"
if exist "%model%\umodel.exe" (
  echo UModel Found.
) else (
  echo UModel Not Found!
  goto :UMODEL
)

:BLENDER
SET /P blend="Enter your Blender Directory:"
if exist "%blend%\blender.exe" (
  echo Blender Found.
) else (
  echo Blender Not Found!
  goto :BLENDER
)

:EXPORT
SET /P start="Enter the directory of the UE4/5 Content Folder:"
if exist "%start%" (
  echo Content Folder Found.
  pause
) else (
  echo Content Folder Not Found!
  goto :EXPORT
)

REM make required directories in the UE4 folder
mkdir "%start%\Characters" "%start%\CTF_Flags" "%start%\Gameplay" "%start%\Maps" "%start%\Music" "%start%\Packages" "%start%\Pickups" "%start%\Textures" "%start%\UI" "%start%\Vehicles" "%start%\Weapons"

REM sort these folders accordingly
REM Effects has one sub folder - testeffects
REM Environments also has one sub folder - test
REM Private two sub folders
REM Sounds folder has language sub-folders
REM UT3G has sub-folders

REM export all packages with umodel
umodel -path="%level%" -export *.upk

REM for all files in the games Characters folder move folders of the same name from umodelexport folder to UE4 Characters folder
for /f "delims=|" %%f in ('dir /b "%level%\Characters"') do move "%model%\UmodelExport\%%~nf" "%start%\Characters\%%~nf"

REM for all files in the games CTF_Flags folder move folders of the same name from umodelexport folder to UE4 CTF_Flags folder
for /f "delims=|" %%f in ('dir /b "%level%\CTF_Flags"') do move "%model%\UmodelExport\%%~nf" "%start%\CTF_Flags\%%~nf"

REM for all files in the games Gameplay folder move folders of the same name from umodelexport folder to UE4 Gameplay folder
for /f "delims=|" %%f in ('dir /b "%level%\Gameplay"') do move "%model%\UmodelExport\%%~nf" "%start%\Gameplay\%%~nf"

REM for all files in the games Maps folder move folders of the same name from umodelexport folder to UE4 Maps folder
for /f "delims=|" %%f in ('dir /b "%level%\Maps"') do move "%model%\UmodelExport\%%~nf" "%start%\Maps\%%~nf"

REM for all files in the games Music folder move folders of the same name from umodelexport folder to UE4 Music folder
for /f "delims=|" %%f in ('dir /b "%level%\Music"') do move "%model%\UmodelExport\%%~nf" "%start%\Music\%%~nf"

REM for all files in the games Packages folder move folders of the same name from umodelexport folder to UE4 Packages folder
for /f "delims=|" %%f in ('dir /b "%level%\Packages"') do move "%model%\UmodelExport\%%~nf" "%start%\Packages\%%~nf"

REM for all files in the games Pickups folder move folders of the same name from umodelexport folder to UE4 Pickups folder
for /f "delims=|" %%f in ('dir /b "%level%\Pickups"') do move "%model%\UmodelExport\%%~nf" "%start%\Pickups\%%~nf"

REM for all files in the games Textures folder move folders of the same name from umodelexport folder to UE4 Textures folder
for /f "delims=|" %%f in ('dir /b "%level%\Textures"') do move "%model%\UmodelExport\%%~nf" "%start%\Textures\%%~nf"

REM for all files in the games Vehicles folder move folders of the same name from umodelexport folder to UE4 Vehicles folder
for /f "delims=|" %%f in ('dir /b "%level%\Vehicles"') do move "%model%\UmodelExport\%%~nf" "%start%\Vehicles\%%~nf"

REM for all files in the games Weapons folder move folders of the same name from umodelexport folder to UE4 Weapons folder
for /f "delims=|" %%f in ('dir /b "%level%\Weapons"') do move "%model%\UmodelExport\%%~nf" "%start%\Weapons\%%~nf"
