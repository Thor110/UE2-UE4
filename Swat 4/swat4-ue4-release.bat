title Swat 4 UE4 Porting Script

REM set first to current directory ( where the script starts executing from )
set first=%cd%

@echo off

cls
REM enter directories of required programs
:UNREAL
SET /P level="Enter the Swat 4 Content Directory:"
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
mkdir "%start%\Materials" "%start%\StaticMeshes" "%start%\Sounds" "%start%\Movies"
REM  "%start%\Animations"

REM change directory to umodel
cd /d "%model%"

REM export animations packages with umodel
REM umodel -path="%level%" -export *.ukx

REM for all files in the games Animations folder move folders of the same name from umodelexport folder to UE4 Animations folder
REM for /f "delims=|" %%f in ('dir /b "%level%\Animations"') do move "%model%\UmodelExport\%%~nf" "%start%\Animations\%%~nf"

REM for all directories in the games Sounds folder of the game
for /D %%D in ("%level%\Sounds\*") do (
	
	REM make a directory of the same name in the UE4 Sounds folder
	mkdir "%start%\Sounds\%%~nD"
	
	REM for all .wav files in all folders within the games Sounds folder
	for %%T in ("%%~D\*.ogg*") do (
		REM copy those files from the games Sounds folder to the UE4 Sounds folder
		copy "%%~D\%%~nT%%~xT" "%start%\Sounds\%%~nD\%%~nT%%~xT"
	)
)

REM for all files in the games Movies folder of the game move to the UE4 Movies folder
for /f %%f in ('dir /b "%level%\Movies"') do copy "%level%\Movies\%%f" "%start%\Movies\%%f"

REM export staticmesh packages with umodel
umodel -path="%level%" -export *.usx

REM for every folder in the umodelexport folder
for /f %%D in ("%model%\UmodelExport\*") do (

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

REM change directory to original directory
cd /d "%first%"

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

Rem these meshes fail to convert to fbx as they are truncated so they are deleted
del "%start%\StaticMeshes\Con_sm\con_freightcar.pskx" "%start%\StaticMeshes\Doors_sm\door_phys_doubleref.pskx" "%start%\StaticMeshes\Jewel_sm\jewel_frontdoor.pskx" "%start%\StaticMeshes\pier_sm\pier_ship.pskx" "%start%\StaticMeshes\Redlibrary_sm\red_brickwindow_blinds_long.pskx"

REM batch convert psk/pskx/psa to FBX with blender
blender -b -P "%first%\batch-convert-fbx.py"

REM delete the following filetypes from the StaticMeshes & Animations folders in the UE4 directory ( .pskx, .psk, .psa, .config )
del /S "%start%\StaticMeshes\*.pskx" "%start%\Materials\*.mat"

REM Animations broken for now
REM for every folder in the UE4 Animations directory
REM for /D %%D in ("%start%\Animations\*") do (

	REM for all .fbx files in the following folders ( SkeletalMesh & MeshAnimation )
REM     for %%F in ("%%~D\SkeletalMesh\*.fbx*","%%~D\MeshAnimation\*.fbx*") do (
		
		REM move file to the parent directory
REM         move /Y "%%~F" "%%~dpF.."
REM     )
REM )
REM 

REM delete leftover files in umodel folder
rd /s /q "%model%\UModelExport\"
mkdir "%model%\UModelExport"

pause
REM pause and exit for now
exit