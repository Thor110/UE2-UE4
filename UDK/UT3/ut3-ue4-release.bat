title Unreal Tournament 3 UE4 Porting Script

REM set first to current directory ( where the script starts executing from )
set first=%cd%

@echo off

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

REM :BLENDER
REM SET /P blend="Enter your Blender Directory:"
REM if exist "%blend%\blender.exe" (
REM   echo Blender Found.
REM ) else (
REM   echo Blender Not Found!
REM   goto :BLENDER
REM )

:EXPORT
SET /P start="Enter the directory of the UE4/5 Content Folder:"
if exist "%start%" (
  echo Content Folder Found.
  pause
) else (
  echo Content Folder Not Found!
  goto :EXPORT
)

cls
echo this script isn't finished yet . . .
pause
exit
echo currently the script only exports all packages to a matching heirarchy of directories in the specified content folder . . .
pause

REM make required directories in the UE4 folder
mkdir "%start%\Characters"
REM "%start%\CTF_Flags" "%start%\Effects" "%start%\Effects\testeffects" "%start%\Environments" "%start%\Environments\test" "%start%\Gameplay" "%start%\Maps" "%start%\Music" "%start%\Packages" "%start%\Pickups" "%start%\Private" "%start%\Private\Maps" "%start%\Private\Vehicles" "%start%\Sounds" "%start%\Sounds\DEU" "%start%\Sounds\ESN" "%start%\Sounds\FRA" "%start%\Sounds\INT" "%start%\Sounds\ITA" "%start%\Textures" "%start%\UI" "%start%\UT3G\Animations" "%start%\UT3G\Characters" "%start%\UT3G\Effects" "%start%\UT3G\Environments" "%start%\UT3G\Gameplay" "%start%\UT3G\Maps" "%start%\UT3G\Packages" "%start%\UT3G\Pickups" "%start%\UT3G\Sounds" "%start%\UT3G\UI" "%start%\Vehicles" "%start%\Weapons"

cd /d "%model%"

REM export all packages with umodel
umodel -path="%level%" -export *.upk

REM for all files in the games Characters folder move folders of the same name from umodelexport folder to UE4 Characters folder
REM for /f "delims=|" %%f in ('dir /b "%level%\Characters"') do (
REM 	umodel -path="%level%" -export %%~nf.upk
REM 
REM 	REM for all files in the games Characters folder move folders of the same name from umodelexport folder to UE4 Characters folder
REM 	for /f "delims=|" %%x in ('dir /b "%model%\UmodelExport"') do (
REM 		mkdir "%start%\Characters\%%~nx"
REM 		move "%model%\UmodelExport\%%~nx" "%start%\Characters\%%~nx"
REM 	)
REM )



REM for every folder in the umodelexport folder
for /D %%D in ("%model%\UmodelExport\*") do (

	REM for all the following filetypes ( .psk, .tga, .mat, .txt ) in the stated subdirectories ( Mesh, Materials )
    for %%F in ("%%~D\Mesh\*.psk*","%%~D\Materials\*.tga*","%%~D\Materials\*.mat*","%%~D\Materials\*.txt*","%%~D\Mesh\*.txt*") do (

		REM move to the parent directory
        move /Y "%%~F" "%%~D"
    )
	
	REM for all the following filetypes ( .psk, .tga, .mat .txt ) in the stated subdirectories ( SM\Mesh, SM\Materials )
    for %%F in ("%%~D\SM\Mesh\*.psk*","%%~D\SM\Materials\*.tga*","%%~D\SM\Materials\*.mat*","%%~D\SM\Materials\*.txt*","%%~D\SM\Mesh\*.txt*") do (
		REM move to the parent directory
        move /Y "%%~F" "%%~D"
    )
)



pause
echo this script isn't finished yet . . .
pause

REM for all files in the games CTF_Flags folder move folders of the same name from umodelexport folder to UE4 CTF_Flags folder
for /f "delims=|" %%f in ('dir /b "%level%\CTF_Flags"') do move "%model%\UmodelExport\%%~nf" "%start%\CTF_Flags\%%~nf"

REM for all files in the games Effects\testeffects folder move folders of the same name from umodelexport folder to UE4 Effects\testeffects folder
for /f "delims=|" %%f in ('dir /b "%level%\Effects\testeffects"') do move "%model%\UmodelExport\%%~nf" "%start%\Effects\testeffects\%%~nf"

REM for all files in the games Effects folder move folders of the same name from umodelexport folder to UE4 Effects folder
for /f "delims=|" %%f in ('dir /b "%level%\Effects"') do move "%model%\UmodelExport\%%~nf" "%start%\Effects\%%~nf"

REM for all files in the games Environments\test folder move folders of the same name from umodelexport folder to UE4 Environments\test folder
for /f "delims=|" %%f in ('dir /b "%level%\Environments\test"') do move "%model%\UmodelExport\%%~nf" "%start%\Environments\test\%%~nf"

REM for all files in the games Effects folder move folders of the same name from umodelexport folder to UE4 Effects folder
for /f "delims=|" %%f in ('dir /b "%level%\Environments"') do move "%model%\UmodelExport\%%~nf" "%start%\Environments\%%~nf"

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

REM for all files in the games Private\Maps folder move folders of the same name from umodelexport folder to UE4 Private\Maps folder
for /f "delims=|" %%f in ('dir /b "%level%\Private\Maps"') do move "%model%\UmodelExport\%%~nf" "%start%\Private\Maps\%%~nf"

REM for all files in the games Private\Vehicles folder move folders of the same name from umodelexport folder to UE4 Private\Vehicles folder
for /f "delims=|" %%f in ('dir /b "%level%\Private\Vehicles"') do move "%model%\UmodelExport\%%~nf" "%start%\Private\Vehicles\%%~nf"

REM for all files in the games Sounds\DEU folder move folders of the same name from umodelexport folder to UE4 Sounds\DEU folder
for /f "delims=|" %%f in ('dir /b "%level%\Sounds\DEU"') do move "%model%\UmodelExport\%%~nf" "%start%\Sounds\DEU\%%~nf"

REM for all files in the games Sounds\ESN folder move folders of the same name from umodelexport folder to UE4 Sounds\ESN folder
for /f "delims=|" %%f in ('dir /b "%level%\Sounds\ESN"') do move "%model%\UmodelExport\%%~nf" "%start%\Sounds\ESN\%%~nf"

REM for all files in the games Sounds\FRA folder move folders of the same name from umodelexport folder to UE4 Sounds\FRA folder
for /f "delims=|" %%f in ('dir /b "%level%\Sounds\FRA"') do move "%model%\UmodelExport\%%~nf" "%start%\Sounds\FRA\%%~nf"

REM for all files in the games Sounds\INT folder move folders of the same name from umodelexport folder to UE4 Sounds\INT folder
for /f "delims=|" %%f in ('dir /b "%level%\Sounds\INT"') do move "%model%\UmodelExport\%%~nf" "%start%\Sounds\INT\%%~nf"

REM for all files in the games Sounds\ITA folder move folders of the same name from umodelexport folder to UE4 Sounds\ITA folder
for /f "delims=|" %%f in ('dir /b "%level%\Sounds\ITA"') do move "%model%\UmodelExport\%%~nf" "%start%\Sounds\ITA\%%~nf"

REM for all files in the games Sounds folder move folders of the same name from umodelexport folder to UE4 Sounds folder
for /f "delims=|" %%f in ('dir /b "%level%\Sounds"') do move "%model%\UmodelExport\%%~nf" "%start%\Sounds\%%~nf"

REM for all files in the games Textures folder move folders of the same name from umodelexport folder to UE4 Textures folder
for /f "delims=|" %%f in ('dir /b "%level%\Textures"') do move "%model%\UmodelExport\%%~nf" "%start%\Textures\%%~nf"

REM for all files in the games UI folder move folders of the same name from umodelexport folder to UE4 UI folder
for /f "delims=|" %%f in ('dir /b "%level%\UI"') do move "%model%\UmodelExport\%%~nf" "%start%\UI\%%~nf"

REM for all files in the games UT3G\Animations folder move folders of the same name from umodelexport folder to UE4 UT3G\Animations folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Animations"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Animations\%%~nf"

REM for all files in the games UT3G\Characters folder move folders of the same name from umodelexport folder to UE4 UT3G\Characters folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Characters"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Characters\%%~nf"

REM for all files in the games UT3G\Effects folder move folders of the same name from umodelexport folder to UE4 UT3G\Effects folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Effects"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Effects\%%~nf"

REM for all files in the games UT3G\Environments folder move folders of the same name from umodelexport folder to UE4 UT3G\Environments folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Environments"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Environments\%%~nf"

REM for all files in the games UT3G\Gameplay folder move folders of the same name from umodelexport folder to UE4 UT3G\Gameplay folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Gameplay"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Gameplay\%%~nf"

REM for all files in the games UT3G\Maps folder move folders of the same name from umodelexport folder to UE4 UT3G\Maps folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Maps"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Maps\%%~nf"

REM for all files in the games UT3G\Packages folder move folders of the same name from umodelexport folder to UE4 UT3G\Packages folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Packages"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Packages\%%~nf"

REM for all files in the games UT3G\Pickups folder move folders of the same name from umodelexport folder to UE4 UT3G\Pickups folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Pickups"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Pickups\%%~nf"

REM for all files in the games UT3G\Sounds folder move folders of the same name from umodelexport folder to UE4 UT3G\Sounds folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\Sounds"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\Sounds\%%~nf"

REM for all files in the games UT3G\UI folder move folders of the same name from umodelexport folder to UE4 UT3G\UI folder
for /f "delims=|" %%f in ('dir /b "%level%\UT3G\UI"') do move "%model%\UmodelExport\%%~nf" "%start%\UT3G\UI\%%~nf"

REM for all files in the games Vehicles folder move folders of the same name from umodelexport folder to UE4 Vehicles folder
for /f "delims=|" %%f in ('dir /b "%level%\Vehicles"') do move "%model%\UmodelExport\%%~nf" "%start%\Vehicles\%%~nf"

REM for all files in the games Weapons folder move folders of the same name from umodelexport folder to UE4 Weapons folder
for /f "delims=|" %%f in ('dir /b "%level%\Weapons"') do move "%model%\UmodelExport\%%~nf" "%start%\Weapons\%%~nf"

echo currently the script only exports all packages to a matching heirarchy of directories in the specified content folder . . .
pause
exit
