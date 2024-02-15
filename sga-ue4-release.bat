title Stargate SG-1 : The Alliance UE4 Porting Script

REM set first to current directory ( where the script starts executing from )
set first=%cd%

@echo off

cls
REM enter directories of required programs
:UNREAL
SET /P level="Enter your UT2004 Directory:"
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

:FFMPEG
SET /P sound="Enter your FFMPEG Directory:"
if exist "%sound%\bin\ffmpeg.exe" (
  echo FFMPEG Found.
) else (
  echo FFMPEG Not Found!
  goto :FFMPEG
)

:XBOX
SET /P files="Enter the directory containing Stargate SG-1: The Alliance files:"
if exist "%files%\xbox.bin" (
  echo "xbox.bin" Found.
) else (
  echo "xbox.bin" Not Found!
  goto :XBOX
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
) else (
  echo Content Folder Not Found!
  goto :EXPORT
)

REM pointless reminder and pause
echo Reminder : The directory for Stargate SG-1: The Alliance will be modified and deleted during the process, so make sure you still have the original 7z file backed up somewhere!
pause

REM the following files are empty or cannot be exported with umodel
del %files%\Textures\M01Tex.utx %files%\Textures\M05ATex.utx %files%\Textures\M05BTex.utx %files%\Textures\M05CTex.utx %files%\Textures\M05dTex.utx %files%\Textures\M08Tex.utx %files%\Textures\M10Atex.utx %files%\Textures\M10Btex.utx %files%\Textures\M12Tex_test.utx %files%\Textures\M15Tex22.utx %files%\Textures\M15Tex_tomerge.utx %files%\Textures\m16.utx %files%\Textures\M16ATex.utx %files%\Textures\M16BTex.utx %files%\Textures\StargateEffectsTex.utx %files%\Textures\M10_train_anim.ukx %files%\Textures\SGAllianceUIX.uix %files%\Textures\UE2Runtime.ini %files%\Textures\XBoxLiveFont.xpr %files%\Textures\m17tex.utx %files%\Textures\x_delete_m17tex.utx %files%\Textures\xx_old_m17tex.utx %files%\Textures\M07_fresco_tex.utx %files%\Textures\M10_train_tex.utx %files%\Textures\StargateGameFontsTex.utx %files%\Textures\Tutorial_Tex.utx %files%\Animations\sg1_anim_comp.ukx %files%\Animations\sg1_anim2.ukx %files%\Animations\Goauld_Turret_anim.ukx %files%\Animations\Goa_Vehicles.ukx %files%\Animations\Haaken_anim.ukx %files%\Animations\Haaken_leader_anim.ukx %files%\Animations\Haaken_Shield_anim.ukx %files%\Animations\Haaken_warrior_anim.ukx %files%\Animations\jaffa_anim.ukx %files%\Animations\M07_fresco_anim.ukx %files%\Animations\M21_Crystal_anim.ukx %files%\Animations\sg1_anim.ukx %files%\Animations\sg1_turret_M60_Humvee.ukx %files%\Animations\SG1_weapons_1st.ukx %files%\Animations\SG1_Wep_Anim2.ukx.tmp %files%\Animations\super_soldier_anim.ukx %files%\Animations\tokra_anim.ukx %files%\Animations\veh_jeep.ukx %files%\StaticMeshes\M16Prefabs.upx %files%\StaticMeshes\UW.ini

REM make directories
mkdir %start%\StaticMeshes\ %start%\Sounds\ %start%\Animations\ %start%\Music\ %start%\Speech\ %start%\Maps\ %start%\Splash\ %start%\Editor\ %start%\Game\ %start%\Materials\
REM removed directories
REM %start%\Textures\ %start%\StaticMesh\

REM change directory to umodel
cd /d %model%

REM export animations packages with umodel
umodel -path=%files%\Animations -export *.ukx

REM for all directories in the umodelexport folder move to the UE4 animations folder
for /f %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\Animations\%%f"

REM for all directories in the music folder of the game move to the UE4 music folder
for /f %%f in ('dir /b %files%\Music\') do move %files%\Music\%%f %start%\Music\%%f

REM for all directories in the speech folder of the game move to the UE4 speech folder
for /f %%f in ('dir /b %files%\Speech\') do move %files%\Speech\%%f %start%\Speech\%%f

REM export texture packages with umodel
umodel -path=%files%\Textures -export *.utx

REM for every folder in the umodelexport folder
for /D %%D in ("%model%\UmodelExport\*") do (

	REM for every .tga file in the texture folder
    for %%F in ("%%~D\Texture\*.tga*") do (
	
		REM move the file to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

Rem FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

REM for every directory in the umodelexport folder move to the UE4 materials folder
for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\Materials\%%f"

REM export staticmesh packages with umodel
umodel -path=%files%\StaticMeshes -export *.usx

REM for every folder in the umodelexport folder
for /D %%D in ("%model%\UmodelExport\*") do (

	REM for every file in the StaticMesh folder
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
	
		REM move file to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

REM removed for now
Rem FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

REM for every directory in the umodelexport folder move to the UE4 StaticMeshes folder
for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\StaticMeshes\%%f"

REM rename map extensions from .unr to .ut2 so that umodel can extract files from them
for /r "%files%\Maps" %%G in (*.unr) do ren "%%~G" *.ut2

REM export files from the map files with umodel
umodel -path=%files%\Maps -export *.ut2

REM for every directory in the umodelexport folder move to the UE4 Maps folder
for /f %%f in ('dir /b %model%\UmodelExport\') do move %model%\UmodelExport\%%f %start%\Maps\%%f

REM change directory to the UT2004 System folder
cd /d %level%\System

REM for every file in the Sounds folder do batchexport with ucc 
for /f "usebackq delims=|" %%f in (`dir /b "%files%\Sounds\"`) do ucc batchexport %files%\Sounds\%%f sound wav %start%\Sounds\%%~nf

REM line no longer used
REM for /f %%f in ('dir /b %model%\UmodelExport\') do move %model%\UmodelExport\%%f %start%\Sounds\%%f

REM for every file in the sounds directory convert through ffmpeg
for /f "usebackq delims=|" %%f in (`dir /b "%start%\Sounds\"`) do "%sound%\bin\ffmpeg" "%%f" "%%f"

REM delete the duplicate game folder removed for now
REM rmdir /q /s %files%

Rem deleting truncated meshes that fail to convert to fbx
del %start%\StaticMeshes\M04Meshes\M04_room_arch_1024_2.pskx %start%\StaticMeshes\veh_Alkesh\veh_alkesh_bodycollision.pskx %start%\StaticMeshes\veh_Alkesh\veh_alkesh_thruster01.pskx %start%\StaticMeshes\veh_Alkesh\veh_alkesh_thruster02.pskx %start%\StaticMeshes\veh_Alkesh\veh_alkesh_thruster03.pskx %start%\StaticMeshes\veh_Alkesh\veh_alkesh_thruster04.pskx

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

REM delete the following filetypes from the StaticMeshes, Animations & Maps folders in the UE4 directory ( .pskx, .psk, .psa, .config )
del /S %start%\StaticMeshes\*.pskx %start%\StaticMeshes\*.psk %start%\StaticMeshes\*.psa %start%\StaticMeshes\*.config %start%\Animations\*.psk %start%\Animations\*.psa %start%\Animations\*.config %start%\Maps\*.pskx

REM Moving Map Textures to Maps\MapName\TextureFile
REM Moving Map Static Meshes to StaticMesh\MapName\StaticMesh

REM syntax is incorrect? strange
REM Ren %start%\Maps\*.txt %start%\Maps\*.mat


for /D %%D in ("%start%\Maps\*") do (
	for %%T in ("%%~D\*.tga*") do (
		mkdir %start%\Materials\%%~nD
		move /Y "%%~T" "%start%\Materials\%%~nD\%%~nT%%~xT"
	)
	for %%F in ("%%~D\*.fbx*") do (
		mkdir %start%\StaticMeshes\%%~nD
		move /Y "%%~F" "%start%\StaticMeshes\%%~nD\%%~nF%%~xF"
	)
)

cd %start%

REM no longer deleting maps folder, due to the above issues.
REM rmdir /Q /S %start%\Maps\

cd %start%\Animations\

REM for every folder in the UE4 Animations folder
for /D %%D in ("%start%\Animations\*") do (

	REM for every .fbx file in the following folders ( SkeletalMesh and MeshAnimation )
    for %%F in ("%%~D\SkeletalMesh\*.fbx*","%%~D\MeshAnimation\*.fbx*") do (
	
		REM move file to the parent directory
        move /Y "%%~F" "%%~dpF.."
    )
)

REM removed for now
Rem FOR /d /r . %%d IN (SkeletalMesh,Texture,MeshAnimation,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

pause
exit

REM findstr /L /S /N /M  "Material" *.props.txt* > %first%\A.txt
REM findstr /L /S /N /M  "Diffuse" *.props.txt* > %first%\B.txt

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