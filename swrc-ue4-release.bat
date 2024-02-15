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
  pause
  exit
)

:UMODEL
SET /P model="Enter your UModel Directory:"
if exist "%model%\umodel.exe" (
  echo UModel Found.
) else (
  echo UModel Not Found!
  goto :UMODEL
  pause
  exit
)

:BLENDER
SET /P blend="Enter your Blender Directory:"
if exist "%blend%\blender.exe" (
  echo Blender Found.
) else (
  echo Blender Not Found!
  goto :BLENDER
  pause
  exit
)

:EXPORT
SET /P start="Enter the directory of the UE4/5 Content Folder:"
if exist "%start%" (
  echo Content Folder Found.
  pause
) else (
  echo Content Folder Not Found!
  goto :EXPORT
  pause
  exit
)

REM make directories
mkdir "%start%\Materials" "%start%\StaticMeshes" %start%\Sounds %start%\Animations %start%\Music\ %start%\Splash\ %start%\Game\ %start%\Movies\

Rem these packages do not contain any sounds
del %files%\Sounds\banter_voice.uax %files%\Sounds\params_mus.uax %files%\Sounds\params_rumble.uax %files%\Sounds\params_sfx.uax %files%\Sounds\params_vox.uax

REM change directory to umodel
cd /d %model%

REM export animations packages with umodel
umodel -path="%level%\Animations" -export *.ukx

REM for all directories in the umodelexport folder move to the UE4 animations folder
for /f %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\Animations\%%f"

REM for all directories in the music folder of the game move to the UE4 music folder
for /f %%f in ('dir /b "%level%\Music\"') do move "%level%\Music\%%f" %start%\Music\%%f

REM export texture packages with umodel
umodel -path="%level%\Textures" -export *.utx

REM for every folder in the umodelexport folder
for /D %%D in ("%model%\UmodelExport\*") do (

	REM for every .tga file in the texture folder
    for %%F in ("%%~D\Texture\*.tga*") do (
	
		REM move the file to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

REM removed for now
Rem FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

REM for every directory in the umodelexport folder move to the UE4 materials folder
for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\Materials\%%f"

REM export staticmesh packages with umodel
umodel -path="%level%\StaticMeshes" -export *.usx

REM for every folder in the umodelexport folder
for /D %%D in ("%model%\UmodelExport\*") do (

REM for all the following filetypes ( .pskx, .psa, .psk ) in the stated subdirectories ( StaticMesh, MeshAnimation, SkeletalMesh )
    for %%F in ("%%~D\StaticMesh\*.pskx*","%%~D\MeshAnimation\*.psa*","%%~D\SkeletalMesh\*.psk*") do (

		REM move to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

REM removed for now
Rem FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap,MeshAnimation,SkeletalMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

REM for every directory in the umodelexport folder move to the UE4 StaticMeshes folder
for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\StaticMeshes\%%f"

REM change directory to the SWRC System folder
cd /d "%level%\System"

REM for every file in the Sounds folder do batchexport with ucc 
for /f "usebackq delims=|" %%f in (`dir /b "%level%\Sounds\"`) do ucc batchexport "%level%\Sounds\%%f" sound wav %start%\Sounds\%%~nf

REM line no longer used
REM for /f %%f in ('dir /b %model%\UmodelExport\') do move %model%\UmodelExport\%%f %start%\Sounds\%%f

REM change directory to original directory
cd %first%

REM delete the duplicate game folder removed for now
REM rmdir /q /s %level%

Rem this mesh fails to convert to fbx so it is deleted
del %start%\StaticMeshes\markericons\TrapXSpotIcon.pskx

REM disable delayed expansion
setlocal disableDelayedExpansion

REM set Input/Output/Find/Insert strings
set InputFile=%first%\batch-convert-fbx.txt
set OutputFile=%blend%\batch-convert-fbx.py
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
cd /d %blend%

REM batch convert psk/pskx/psa to FBX with blender
blender -b -P batch-convert-fbx.py

REM delete the following filetypes from the StaticMeshes & Animations folders in the UE4 directory ( .pskx, .psk, .psa, .config )
del /S %start%\StaticMeshes\*.pskx %start%\StaticMeshes\*.psk %start%\StaticMeshes\*.psa %start%\StaticMeshes\*.config %start%\Animations\*.psk %start%\Animations\*.psa %start%\Animations\*.config

REM for every folder in the UE4 Animations directory
for /D %%D in ("%start%\Animations\*") do (

	REM for all .fbx files in the following folders ( SkeletalMesh & MeshAnimation )
    for %%F in ("%%~D\SkeletalMesh\*.fbx*","%%~D\MeshAnimation\*.fbx*") do (
		
		REM move file to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

REM line no longer needed
REM cd /d %start%\Animations\

REM delete directory that contains files that exist in the Materials folder already
rd /s /q %start%\Animations\bactadispensers\BactaDispenserGEO

REM line no longer used
Rem FOR /d /r . %%d IN (SkeletalMesh,Texture,MeshAnimation,VertMesh,Shader) DO @IF EXIST "%%d" rd /s /q "%%d"

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