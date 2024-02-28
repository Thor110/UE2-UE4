title Star Wars Republic Commando UE4 Porting Script

REM set first to current directory ( where the script starts executing from )
set first=%cd%

@echo off

cls
REM enter directories of required programs
:UNREAL
SET /P level="Enter the duplicated Red Orchestra Ostfront 41-45 GameData Directory:"
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
mkdir "%start%\Materials" "%start%\StaticMeshes" "%start%\Sounds" "%start%\Animations" "%start%\TEST"

REM rename map files from .rom to .ut2 for extraction
for /r "%level%\Maps\" %%x in (*.rom) do ren "%%x" "%%~nx.ut2"

REM change directory to umodel
cd /d "%model%"

REM export animations packages with umodel
umodel -path="%level%" -export *.ukx

REM for all files in the games Animations folder move folders of the same name from umodelexport folder to UE4 Animations folder
for /f "delims=|" %%f in ('dir /b "%level%\Animations"') do move "%model%\UmodelExport\%%~nf" "%start%\Animations\%%~nf"

REM export texture packages with umodel
umodel -path="%level%" -export *.utx

REM export staticmesh packages with umodel
umodel -path="%level%" -export *.usx

REM export map packages with umodel
umodel -path="%level%" -export *.ut2

REM rename map files back from .ut2 to .rom after extraction
for /r "%level%\Maps\" %%x in (*.ut2) do ren "%%x" "%%~nx.rom"

if exist "%first%\time-log.txt" (
	del "%first%\time-log.txt"
)
echo Started:%DATE% %TIME%>> "%first%\time-log.txt"

REM for every file in the UE4T3D folder
for /f %%t in ('dir /b "%first%\UE4T3D\"') do (
	REM user error to prevent the file existing or the script being run multiple times and appending to the same file.
	if exist "%first%\TEST\%%~nt.t3d" (
		del "%first%\TEST\%%~nt.t3d"
	)
	REM for the current T3D file.
	for /f "delims=" %%i in (%first%\UE4T3D\%%~nt.t3d) do (
		SET "string=%%i"
		REM echo current line to findstr and check it for "Texture="
		echo.%%i | findstr /C:"Texture=" 1>nul
		REM error level
		if errorlevel 1 (
			REM echo. got one - pattern not found
			REM echo current line to findstr and check it for "StaticMesh="
			echo.%%i | findstr /C:"StaticMesh=" 1>nul
			REM error level
			if errorlevel 1 (
				REM echo. got one - pattern not found
				echo %%i>> %first%\TEST\%%~nt.t3d
			) ELSE (
				REM echo. got zero - found pattern StaticMesh
				REM set local enable delayed expansion
				setlocal enabledelayedexpansion
				REM correct the first part of the string from "/Converted/LevelName/" to "/StaticMeshes/"
				SET "modified1=!string:/Converted/%%~nt-UT2004/=/StaticMeshes/!"
				REM if this string replacement is possible.
				If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nt_=!" (
					REM for every folder with the same name as the package checked in the games StaticMeshes folder during this for loop
					for /f %%m in ('dir /b /o-n "%model%\UmodelExport\%%~nt"') do (
						REM if this string replacement is possible.
						If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nt_%%~nm_=!" (
							REM correct the second part of the string from "/LevelName_CategoryName_" to "/LevelName/CategoryName/"
							SET "modified2=!modified1:/%%~nt_%%~nm_=/%%~nt/%%~nm/!"
							REM correct the third part of the string from ".LevelName_" to "."
							SET "modified3=!modified2:.%%~nt_%%~nm_=.!"
							REM echo the updated line to the new T3D file
							echo !modified3!>> %first%\TEST\%%~nt.t3d
						)
					)
					for /f %%o in ('dir /b /o-n "%model%\UmodelExport\%%~nt\*.pskx"') do (
						REM for instances where there is no category within the level.
						If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nt_%%~no=!" (
							REM correct the second part of the string from "/LevelName_" to "/LevelName/"
							SET "modified2=!modified1:/%%~nt_=/%%~nt/!"
							REM correct the third part of the string from ".LevelName_" to "."
							SET "modified3=!modified2:.%%~nt_=.!"
							REM echo the updated line to the new T3D file
							echo !modified3!>> %first%\TEST\%%~nt.t3d
						)
					)
				REM if that string replacement is not possible.
				) else (
					REM for every package in the games StaticMeshes folder
					for /f "delims=|" %%f in ('dir /b /o-n "%level%\StaticMeshes"') do (
						REM for every folder with the same name as the package checked in the games StaticMeshes folder during this for loop
						for /f %%m in ('dir /b /o-n "%model%\UmodelExport\%%~nf"') do (
							REM if this string replacement is possible.
							If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nf_%%~nm_=!" (
								REM correct the second part of the string from "/PackageName_CategoryName_" to "/PackageName/CategoryName/"
								SET "modified4=!modified1:/%%~nf_%%~nm_=/%%~nf/%%~nm/!"
								REM correct the third part of the string from ".PackageName_CategoryName_" to "."
								SET "modified5=!modified4:.%%~nf_%%~nm_=.!"
								REM echo the updated line to the new T3D file
								echo !modified5!>> %first%\TEST\%%~nt.t3d
							)
						)
						for /f %%o in ('dir /b /o-n "%model%\UmodelExport\%%~nf\*.pskx"') do (
							REM for instances where there is no category within the package.
							If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nf_%%~no=!" (
								REM correct the second part of the string from "/PackageName_" to "/PackageName/"
								SET "modified4=!modified1:/%%~nf_=/%%~nf/!"
								REM correct the third part of the string from ".PackageName_" to "."
								SET "modified5=!modified4:.%%~nf_=.!"
								REM echo the updated line to the new T3D file
								echo !modified5!>> %first%\TEST\%%~nt.t3d
							)
						)
					)
				)
				REM end local
				endlocal
			)
		) ELSE (
			REM echo. got zero - found pattern Texture
			REM set local enable delayed expansion
			setlocal enabledelayedexpansion
			REM correct the first part of the string from "/Converted/LevelName/" to "/Materials/"
			SET "modified6=!string:/Converted/%%~nt-UT2004/=/Materials/!"
			REM if this string replacement is possible.
			If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nt_=!" (
				REM for every folder with the same name as the package checked in the games StaticMeshes folder during this for loop
				for /f %%m in ('dir /b /o-n "%model%\UmodelExport\%%~nt"') do (
					REM if this string replacement is possible.
					If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nt_%%~nm_=!" (
						REM correct the second part of the string from "/LevelName_CategoryName_" to "/LevelName/CategoryName/"
						SET "modified7=!modified6:/%%~nt_%%~nm_=/%%~nt/%%~nm/!"
						REM correct the third part of the string from ".LevelName_CategoryName_" to "."
						SET "modified8=!modified7:.%%~nt_%%~nm_=.!"
						REM echo the updated line to the new T3D file
						echo !modified8!>> %first%\TEST\%%~nt.t3d
					)
				)
				for /f %%o in ('dir /b /o-n "%model%\UmodelExport\%%~nt\*.pskx"') do (
					REM for instances where there is no category within the level. LevelName_FileName
					If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nt_%%~no=!" (
						REM correct the second part of the string from "/LevelName_" to "/LevelName/"
						SET "modified7=!modified6:/%%~nt_=/%%~nt/!"
						REM correct the third part of the string from ".LevelName_" to "."
						SET "modified8=!modified7:.%%~nt_=.!"
						REM echo the updated line to the new T3D file
						echo !modified8!>> %first%\TEST\%%~nt.t3d
					)
				)
			REM if that string replacement is not possible.
			) else (
				REM for every package in the games Textures folder
				for /f "delims=|" %%f in ('dir /b /o-n "%level%\Textures"') do (
					REM for every folder with the same name as the package checked in the games Textures folder during this for loop
					for /f %%m in ('dir /b /o-n "%model%\UmodelExport\%%~nf"') do (
						REM if this string replacement is possible.
						If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nf_%%~nm_=!" (
							REM correct the second part of the string from "/PackageName_CategoryName_" to "/PackageName/CategoryName/"
							SET "modified9=!modified6:/%%~nf_%%~nm_=/%%~nf/%%~nm/!"
							REM correct the third part of the string from ".PackageName_CategoryName_" to "."
							SET "modified10=!modified9:.%%~nf_%%~nm_=.!"
							REM echo the updated line to the new T3D file
							echo !modified10!>> %first%\TEST\%%~nt.t3d
						)
					)
					for /f %%o in ('dir /b /o-n "%model%\UmodelExport\%%~nf\*.pskx"') do (
						REM for instances where there is no category within the package. LevelName_FileName
						If NOT "!string!"=="!string:/Converted/%%~nt-UT2004/%%~nf_%%~no=!" (
							REM correct the second part of the string from "/PackageName_" to "/PackageName/"
							SET "modified9=!modified6:/%%~nf_=/%%~nf/!"
							REM correct the third part of the string from ".PackageName_" to "."
							SET "modified10=!modified9:.%%~nf_=.!"
							REM echo the updated line to the new T3D file
							echo !modified10!>> %first%\TEST\%%~nt.t3d
						)
					)
				)
			)
			REM end local
			endlocal
		)
	)
)

echo Finished:%DATE% %TIME%>> "%first%\time-log.txt"

REM for all files in the games Maps folder move folders of the same name from umodelexport folder to UE4 StaticMeshes folder
for /f "delims=|" %%f in ('dir /b "%level%\Maps"') do move "%model%\UmodelExport\%%~nf" "%start%\StaticMeshes\%%~nf"

REM for all files in the games Textures folder move folders of the same name from umodelexport folder to UE4 Materials folder
for /f "delims=|" %%f in ('dir /b "%level%\Textures"') do move "%model%\UmodelExport\%%~nf" "%start%\Materials\%%~nf"

REM for all files in the games StaticMeshes folder move folders of the same name from umodelexport folder to UE4 StaticMeshes folder
for /f "delims=|" %%f in ('dir /b "%level%\StaticMeshes"') do move "%model%\UmodelExport\%%~nf" "%start%\StaticMeshes\%%~nf"

REM change directory to the SWRC System folder
cd /d "%level%\System"

REM for every file in the Sounds folder do batchexport with ucc 
for /f "delims=|" %%f in ('dir /b "%level%\Sounds"') do ucc batchexport "%level%\Sounds\%%f" sound wav "%start%\Sounds\%%~nf"

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

REM batch convert psk/pskx/psa to FBX with blender
blender -b -P "%first%\batch-convert-fbx.py"

REM change directory to the RO System folder
cd /d "%level%\System"

REM these are the only sound packages that contain any files, the rest appear to be empty.
REM for every file in the Sounds folder do batchexport with ucc 
for /f "delims=|" %%f in ('dir /b "%level%\Sounds"') do ucc batchexport "%level%\Sounds\Ahz_Sounds.uax" sound wav "%start%\Sounds\%%~nf"

REM for every file in the Sounds folder do batchexport with ucc 
for /f "delims=|" %%f in ('dir /b "%level%\Sounds"') do ucc batchexport "%level%\Sounds\Artillery.uax" sound wav "%start%\Sounds\%%~nf"

REM for every file in the Sounds folder do batchexport with ucc 
for /f "delims=|" %%f in ('dir /b "%level%\Sounds"') do ucc batchexport "%level%\Sounds\Vehicle_reloads.uax" sound wav "%start%\Sounds\%%~nf"

REM delete the following filetypes from the StaticMeshes & Animations folders in the UE4 directory ( .pskx, .psk, .psa, .config )
del /S "%start%\StaticMeshes\*.pskx" "%start%\StaticMeshes\*.psk" "%start%\StaticMeshes\*.psa" "%start%\StaticMeshes\*.config" "%start%\Animations\*.psk" "%start%\Animations\*.psa" "%start%\Animations\*.config"

REM delete leftover files in umodel folder
rd /s /q "%model%\UModelExport\"
mkdir "%model%\UModelExport"

pause
REM pause and exit for now
exit