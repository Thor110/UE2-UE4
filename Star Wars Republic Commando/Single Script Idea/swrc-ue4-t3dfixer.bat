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
mkdir "%start%\Materials" "%start%\StaticMeshes" "%start%\Sounds" "%start%\Animations" "%start%\Music" "%start%\Movies" "%start%\Maps" "%start%\TEST" "%start%\TEST2" "%start%\TEST3"

REM make temporary directory and move the packages that do not contain any sounds
mkdir "%level%\Temporary"
move /Y "%level%\Sounds\banter_voice.uax" "%level%\Temporary"
move /Y "%level%\Sounds\params_mus.uax" "%level%\Temporary"
move /Y "%level%\Sounds\params_rumble.uax" "%level%\Temporary"
move /Y "%level%\Sounds\params_sfx.uax" "%level%\Temporary"
move /Y "%level%\Sounds\params_vox.uax" "%level%\Temporary"

move /Y "%level%\StaticMeshes\arena_lm.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\assaultship_02_gm.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\assaultship_04_gm.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\assaultship_lm.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\charactertests.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\coreship_lm.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\eventtemplate.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\lowerkashyyyk_hr.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\lowerkashyyyk_lm.usx" "%level%\Temporary"
move /Y "%level%\StaticMeshes\upperkashyyyk_lm.usx" "%level%\Temporary"

move /Y "%level%\Textures\coreship_textures_props.utx" "%level%\Temporary"
move /Y "%level%\Textures\ld_signs.utx" "%level%\Temporary"
move /Y "%level%\Textures\shadow.utx" "%level%\Temporary"

REM rename levels that contain meshes for extraction
REM rename map files from .ctm to .ut2 for extraction
for /r "%level%\Maps\" %%x in (*.ctm) do ren "%%x" "%%~nx.ut2"

REM change directory to umodel
cd /d "%model%"

REM export map packages with umodel
umodel -path="%level%" -export *.ut2

REM move or delete a single package that isn't required
rd /s /q "%model%\UmodelExport\engine"
REM delete texture packages extracted early so that they aren't moved into the Maps folder
rd /s /q "%model%\UmodelExport\assaultship_textures"
rd /s /q "%model%\UmodelExport\assaultship_textures_props"

REM move meshes contained within levels that are referenced in T3D files
move "%model%\UmodelExport\ras_03b" "%start%\StaticMeshes\"
move "%model%\UmodelExport\ras_04a" "%start%\StaticMeshes\"
REM for all files in the games umodelexport folder move folders to UE4 Maps folder
for /f "delims=|" %%f in ('dir /b "%model%\UmodelExport"') do move "%model%\UmodelExport\%%~nf" "%start%\Maps\%%~nf"

REM rename levels back that contain meshes
REM rename map files from .ctm to .ut2 for extraction
for /r "%level%\Maps\" %%x in (*.ut2) do ren "%%x" "%%~nx.ctm"

REM export animations packages with umodel
umodel -path="%level%" -export *.ukx

REM for all files in the games Animations folder move folders of the same name from umodelexport folder to UE4 Animations folder
for /f "delims=|" %%f in ('dir /b "%level%\Animations"') do move "%model%\UmodelExport\%%~nf" "%start%\Animations\%%~nf"

REM for all .ogg files in the games Music folder copy to the UE4 Music folder
for /r "%level%\Music" %%x in (*.ogg) do copy "%%x" "%start%\Music\"

REM for all files in the games Movies folder of the game move to the UE4 Movies folder
for /f %%f in ('dir /b "%level%\Movies"') do copy "%level%\Movies\%%f" "%start%\Movies\%%f"

REM export texture packages with umodel
umodel -path="%level%" -export *.utx

if exist "%first%\time-log.txt" (
	del "%first%\time-log.txt"
)
echo Started:%DATE% %TIME%>> "%first%\time-log.txt"

REM comment all this later
for /f %%t in ('dir /b "%first%\UE4T3D\"') do (
	if exist "%first%\TEST\%%~nt.t3d" (
		del "%first%\TEST\%%~nt.t3d"
	)
	for /f "delims=" %%i in (%first%\UE4T3D\%%~nt.t3d) do (
		echo.%%i | findstr /C:"Texture=" 1>nul
		if errorlevel 1 (
			REM echo. got one - pattern not found
			echo %%i>> %first%\TEST\%%~nt.t3d
		) ELSE (
			REM echo. got zero - found pattern
			setlocal enabledelayedexpansion
			SET "string=%%i"
			SET "modified=!string:/RestrictedAssets/Maps/WIP/%%~nt-UT2004/=/Materials/!"
			for /f "delims=|" %%f in ('dir /b /o-n "%level%\Textures"') do (
				for /f %%m in ('dir /b /o-n "%model%\UmodelExport\%%~nf"') do (
					set YourString=%%i
					If NOT "!YourString!"=="!YourString:%%~nf_%%~nm=!" (
						SET "modified2=!modified:/%%~nf_%%~nm_=/%%~nf/%%~nm/!"
						SET "modified3=!modified2:.%%~nf_%%~nm_=.!"
						echo !modified3!>> %first%\TEST\%%~nt.t3d
					)
				)
			)
			endlocal
		)
	)
)

echo Finished:%DATE% %TIME%>> "%first%\time-log.txt"

for /f "delims=|" %%f in ('dir /b /o "%level%\Textures"') do (
	move "%model%\UmodelExport\%%~nf" "%start%\Materials\%%~nf"
)

REM export staticmesh packages with umodel
umodel -path="%level%" -export *.usx

if exist "%first%\time-log-sm.txt" (
	del "%first%\time-log-sm.txt"
)
echo Started:%DATE% %TIME%>> "%first%\time-log-sm.txt"

for /f %%t in ('dir /b "%first%\TEST\"') do (
	REM DONT FORGET YOU CANNOT DELETE THIS TIME AROUND - SAVING - COMING BACK LATER
	if exist "%first%\TEST2\%%~nt.t3d" (
		del "%first%\TEST2\%%~nt.t3d"
	)
	for /f "delims=" %%i in (%first%\TEST\%%~nt.t3d) do (
		echo.%%i | findstr /C:"StaticMesh=" 1>nul
		if errorlevel 1 (
			REM echo. got one - pattern not found
			echo %%i>> %first%\TEST2\%%~nt.t3d
		) ELSE (
			REM echo. got zero - found pattern
			setlocal enabledelayedexpansion
			SET "string=%%i"
			REM echo. got zero - found pattern StaticMeshes
			REM FIND AND REPLACE "StaticMesh=StaticMesh'/Game/Materials/" with "StaticMesh=StaticMesh'/Game/StaticMeshes/"
			SET "modified=!string:/RestrictedAssets/Maps/WIP/%%~nt-UT2004/=/StaticMeshes/!"
			REM echo. got zero - found pattern StaticMeshes -> Fixed
			for /f "delims=|" %%f in ('dir /b /o-n "%level%\StaticMeshes"') do (
				for /f %%m in ('dir /b /o-n "%model%\UmodelExport\%%~nf"') do (
					set YourString=%%i
					If NOT "!YourString!"=="!YourString:%%~nf_%%~nm=!" (
						SET "modified2=!modified:/%%~nf_%%~nm_=/%%~nf/%%~nm/!"
						SET "modified3=!modified2:.%%~nf_%%~nm_=.!"
						echo !modified3!>> %first%\TEST2\%%~nt.t3d
					)
				)
			)
			endlocal
		)
	)
)
echo Finished:%DATE% %TIME%>> "%first%\time-log-sm.txt"

if exist "%first%\time-log-lm.txt" (
	del "%first%\time-log-lm.txt"
)
echo Started:%DATE% %TIME%>> "%first%\time-log-lm.txt"

for /f %%t in ('dir /b "%first%\TEST2\"') do (
	REM DONT FORGET YOU CANNOT DELETE THIS TIME AROUND - SAVING - COMING BACK LATER
	if exist "%first%\TEST3\%%~nt.t3d" (
		del "%first%\TEST3\%%~nt.t3d"
	)
	for /f "delims=" %%i in (%first%\TEST2\%%~nt.t3d) do (
		echo.%%i | findstr /C:"Lift Mesh=" 1>nul
		if errorlevel 1 (
			REM echo. got one - pattern not found
			echo %%i>> %first%\TEST3\%%~nt.t3d
		) ELSE (
			REM echo. got zero - found pattern
			setlocal enabledelayedexpansion
			SET "string=%%i"
			REM echo. got zero - found pattern StaticMeshes
			REM FIND AND REPLACE "StaticMesh=StaticMesh'/Game/Materials/" with "StaticMesh=StaticMesh'/Game/StaticMeshes/"
			SET "modified=!string:/RestrictedAssets/Maps/WIP/%%~nt-UT2004/=/StaticMeshes/!"
			REM echo. got zero - found pattern StaticMeshes -> Fixed
			for /f "delims=|" %%f in ('dir /b /o-n "%level%\StaticMeshes"') do (
				for /f %%m in ('dir /b /o-n "%model%\UmodelExport\%%~nf"') do (
					set YourString=%%i
					If NOT "!YourString!"=="!YourString:%%~nf_%%~nm=!" (
						SET "modified2=!modified:/%%~nf_%%~nm_=/%%~nf/%%~nm/!"
						SET "modified3=!modified2:.%%~nf_%%~nm_=.!"
						echo !modified3!>> %first%\TEST3\%%~nt.t3d
					)
				)
			)
			endlocal
		)
	)
)
echo Finished:%DATE% %TIME%>> "%first%\time-log-lm.txt"

for /f "delims=|" %%f in ('dir /b /o "%level%\StaticMeshes"') do (
	move "%model%\UmodelExport\%%~nf" "%start%\StaticMeshes\%%~nf"
)

REM for all files in the games StaticMeshes folder move folders of the same name from umodelexport folder to UE4 StaticMeshes folder
for /f "delims=|" %%f in ('dir /b "%level%\StaticMeshes"') do move "%model%\UmodelExport\%%~nf" "%start%\StaticMeshes\%%~nf"
REM NOTE : 10 of the packages in the StaticMeshes folder are empty, so when moving the files using this logic there are some failures.
REM Consider moving them to temporary folders just like the sounds packages, to reduce errors in the command window.

REM delete random TGA files that exist within StaticMeshes folder and in the Materials folder
del /q "%start%\StaticMeshes\globalprops\Geonosian\GeonosianTank.tga"
rd /s /q "%start%\StaticMeshes\globalprops\Default"

REM change directory to the SWRC System folder
cd /d "%level%\System"

REM for every file in the Sounds folder do batchexport with ucc 
for /f "delims=|" %%f in ('dir /b "%level%\Sounds"') do ucc batchexport "%level%\Sounds\%%f" sound wav "%start%\Sounds\%%~nf"
if exist "%first%\time-log-sc.txt" (
	del "%first%\time-log-sc.txt"
)
echo Started:%DATE% %TIME%>> "%first%\time-log-sc.txt"

REM comment all this later
for /f %%t in ('dir /b "%first%\UE4T3D\"') do (
	if exist "%first%\TEST\%%~nt.t3d" (
		del "%first%\TEST\%%~nt.t3d"
	)
	for /f "delims=" %%i in (%first%\UE4T3D\%%~nt.t3d) do (
		echo.%%i | findstr /C:"=SoundCue" 1>nul
		if errorlevel 1 (
			REM echo. got one - pattern not found
			echo %%i>> %first%\TEST\%%~nt.t3d
		) ELSE (
			REM echo. got zero - found pattern
			setlocal enabledelayedexpansion
			SET "string=%%i"
			SET "modified=!string:/RestrictedAssets/Maps/WIP/%%~nt-UT2004/=/Sounds/!"
			for /f "delims=|" %%f in ('dir /b /o-n "%start%\Sounds"') do (
				REM for /f %%m in ('dir /b /o-n "%start%\Sounds\%%~nf"') do (
					set YourString=%%i
					If NOT "!YourString!"=="!YourString:%%~nf_=!" (
						SET "modified2=!modified:/%%~nf_=/%%~nf/!"
						SET "modified3=!modified2:.%%~nf_=.!"
						echo !modified3!>> %first%\TEST\%%~nt.t3d
					)
				REM )
			)
			endlocal
		)
	)
)

echo Finished:%DATE% %TIME%>> "%first%\time-log-sc.txt"

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

REM delete directory that contains files that exist in the Materials folder already
rd /s /q "%start%\Animations\bactadispensers\BactaDispenserGEO"

REM move sound packages back and delete temporary directory
move /Y "%level%\Temporary\banter_voice.uax" "%level%\Sounds"
move /Y "%level%\Temporary\params_mus.uax" "%level%\Sounds"
move /Y "%level%\Temporary\params_rumble.uax" "%level%\Sounds"
move /Y "%level%\Temporary\params_sfx.uax" "%level%\Sounds"
move /Y "%level%\Temporary\params_vox.uax" "%level%\Sounds"

move /Y "%level%\Temporary\arena_lm.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\assaultship_02_gm.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\assaultship_04_gm.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\assaultship_lm.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\charactertests.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\coreship_lm.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\eventtemplate.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\lowerkashyyyk_hr.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\lowerkashyyyk_lm.usx" "%level%\StaticMeshes"
move /Y "%level%\Temporary\upperkashyyyk_lm.usx" "%level%\StaticMeshes"

move /Y "%level%\Temporary\coreship_textures_props.utx" "%level%\Textures"
move /Y "%level%\Temporary\ld_signs.utx" "%level%\Textures"
move /Y "%level%\Temporary\shadow.utx" "%level%\Textures"

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