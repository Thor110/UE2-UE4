title Star Wars Republic Commando UE4 Porting Script

REM set first to current directory ( where the script starts executing from )
set first=%cd%

@echo off

cls
REM enter directories of required programs
:UNREAL
SET /P level="Enter the duplicated Star Wars Republic Commando GameData Directory:"
if exist "%level%\System\UCC.exe" (
  echo UCC Found.
) else (
  echo UCC Not Found!
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
mkdir "%start%\Materials" "%start%\StaticMeshes" "%start%\Sounds" "%start%\Animations" "%start%\Music" "%start%\Movies"

REM make temporary directory and move the packages that do not contain any sounds
mkdir "%level%\Temporary"
move /Y "%level%\Sounds\banter_voice.uax" "%level%\Temporary"
move /Y "%level%\Sounds\params_mus.uax" "%level%\Temporary"
move /Y "%level%\Sounds\params_rumble.uax" "%level%\Temporary"
move /Y "%level%\Sounds\params_sfx.uax" "%level%\Temporary"
move /Y "%level%\Sounds\params_vox.uax" "%level%\Temporary"

REM change directory to umodel
cd /d "%model%"

REM export animations packages with umodel
umodel -path="%level%" -export *.ukx

REM for all files in the games Animations folder move folders of the same name from umodelexport folder to UE4 Animations folder
for /f "delims=|" %%f in ('dir /b "%level%\Animations"') do move "%model%\UmodelExport\%%~nf" "%start%\Animations\%%~nf"

REM for all files in the games Music folder of the game move to the UE4 Music folder
for /f %%f in ('dir /b "%level%\Music"') do copy "%level%\Music\%%f" "%start%\Music\%%f"

REM for all files in the games Movies folder of the game move to the UE4 Movies folder
for /f %%f in ('dir /b "%level%\Movies"') do copy "%level%\Movies\%%f" "%start%\Movies\%%f"

REM export texture packages with umodel
umodel -path="%level%" -export *.utx

REM for every folder in the umodelexport folder
for /D %%D in ("%model%\UmodelExport\*") do (

	REM for every .tga file in the texture folder
    for %%F in ("%%~D\Texture\*.tga*") do (
	
		REM move the file to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

REM for all files in the games Textures folder move folders of the same name from umodelexport folder to UE4 Materials folder
for /f "delims=|" %%f in ('dir /b "%level%\Textures"') do move "%model%\UmodelExport\%%~nf" "%start%\Materials\%%~nf"

REM export staticmesh packages with umodel
umodel -path="%level%" -export *.usx

REM for every folder in the umodelexport folder
for /D %%D in ("%model%\UmodelExport\*") do (

	REM for all the following filetypes ( .pskx, .psa, .psk ) in the stated subdirectories ( StaticMesh, MeshAnimation, SkeletalMesh )
    for %%F in ("%%~D\StaticMesh\*.pskx*","%%~D\MeshAnimation\*.psa*","%%~D\SkeletalMesh\*.psk*") do (

		REM move to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

REM for all files in the games StaticMeshes folder move folders of the same name from umodelexport folder to UE4 StaticMeshes folder
for /f "delims=|" %%f in ('dir /b "%level%\StaticMeshes"') do move "%model%\UmodelExport\%%~nf" "%start%\StaticMeshes\%%~nf"
REM NOTE : 10 of the packages in the StaticMeshes folder are empty, so when moving the files using this logic there are some failures.
REM Consider moving them to temporary folders just like the sounds packages, to reduce errors in the command window.

REM change directory to the SWRC System folder
cd /d "%level%\System"

REM for every file in the Sounds folder do batchexport with ucc 
for /f "delims=|" %%f in ('dir /b "%level%\Sounds"') do ucc batchexport "%level%\Sounds\%%f" sound wav "%start%\Sounds\%%~nf"

REM change directory to original directory
cd /d "%first%"

Rem this mesh fails to convert to fbx so it is deleted
del "%start%\StaticMeshes\markericons\SetTrap\TrapXSpotIcon.pskx"

REM disable delayed expansion
setlocal disableDelayedExpansion

REM set Input/Output/Find/Insert strings
set "InputFile=%first%\batch-convert-fbx.txt"
set "OutputFile=%first%\batch-convert-fbx.py"
set "_strFind=path = 'C:\'"
set "_strInsert=path = '%start%'"

REM write to output file
>"%OutputFile%" (

REM for every line in the InputFile
for /f "usebackq delims=" %%A in ("%InputFile%") do (

	REM if line equals _strFind echo _strInsert else echo line
    if "%%A" equ "%_strFind%" (echo %_strInsert%) else (echo %%A)
  )
)

REM change directory to the blender directory
cd /d "%blend%"

REM batch convert psk/pskx/psa to FBX with blender
blender -b -P "%first%\batch-convert-fbx.py"

REM delete the following filetypes from the StaticMeshes & Animations folders in the UE4 directory ( .pskx, .psk, .psa, .config )
del /S "%start%\StaticMeshes\*.pskx" "%start%\StaticMeshes\*.psk" "%start%\StaticMeshes\*.psa" "%start%\Animations\*.psk" "%start%\Animations\*.psa" "%start%\Animations\*.config" "%start%\Materials\*.config" "%start%\Materials\*.psa" "%start%\Materials\*.fbx"

REM for every folder in the UE4 Animations directory
for /D %%D in ("%start%\Animations\*") do (

	REM for all .fbx files in the following folders ( SkeletalMesh & MeshAnimation )
    for %%F in ("%%~D\SkeletalMesh\*.fbx*","%%~D\MeshAnimation\*.fbx*") do (
		
		REM move file to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

REM delete directory that contains files that exist in the Materials folder already
rd /s /q "%start%\Animations\bactadispensers\BactaDispenserGEO"

REM move sound packages back and delete temporary directory
move /Y "%level%\Temporary\banter_voice.uax" "%level%\Sounds"
move /Y "%level%\Temporary\params_mus.uax" "%level%\Sounds"
move /Y "%level%\Temporary\params_rumble.uax" "%level%\Sounds"
move /Y "%level%\Temporary\params_sfx.uax" "%level%\Sounds"
move /Y "%level%\Temporary\params_vox.uax" "%level%\Sounds"
rd /s /q "%level%\Temporary"

REM delete leftover files in umodel folder
rd /s /q "%model%\UModelExport\"
mkdir "%model%\UModelExport"

pause
REM pause and exit for now
exit

findstr /L /S /N /M  "Material" *.props.txt* > %first%\A.txt
findstr /L /S /N /M  "Diffuse" *.props.txt* > %first%\B.txt

pause

Rem clear cluttered files

del %first%\C.txt

@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=* delims=." %%a in (%first%\A.txt) do (
    call :myInnerLoop "%%a"
)

goto :eof

:myInnerLoop
for /F "tokens=* delims=." %%b in (%first%\B.txt) do (
    if "%~1"=="%%b" (
        goto :next
    )
)
echo %~1 >> %first%\C.txt

:next
goto :eof

pause