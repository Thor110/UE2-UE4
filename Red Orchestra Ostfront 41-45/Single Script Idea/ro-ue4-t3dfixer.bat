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
mkdir "%start%\Materials" "%start%\StaticMeshes" "%start%\Sounds" "%start%\Animations"

REM change directory to umodel
cd /d "%model%"

REM export animations packages with umodel
umodel -path="%level%" -export *.ukx

REM for all files in the games Animations folder move folders of the same name from umodelexport folder to UE4 Animations folder
for /f "delims=|" %%f in ('dir /b "%level%\Animations"') do move "%model%\UmodelExport\%%~nf" "%start%\Animations\%%~nf"

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
			SET "modified=!string:/Converted/%%~nt-UT2004/=/Materials/!"
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

REM for all files in the games Textures folder move folders of the same name from umodelexport folder to UE4 Materials folder
for /f "delims=|" %%f in ('dir /b "%level%\Textures"') do move "%model%\UmodelExport\%%~nf" "%start%\Materials\%%~nf"

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
			SET "modified=!string:/Converted/%%~nt-UT2004/=/StaticMeshes/!"
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

REM delete the following filetypes from the StaticMeshes & Animations folders in the UE4 directory ( .pskx, .psk, .psa, .config )
del /S "%start%\StaticMeshes\*.pskx" "%start%\StaticMeshes\*.psk" "%start%\StaticMeshes\*.psa" "%start%\StaticMeshes\*.config" "%start%\Animations\*.psk" "%start%\Animations\*.psa" "%start%\Animations\*.config"

REM delete leftover files in umodel folder
rd /s /q "%model%\UModelExport\"
mkdir "%model%\UModelExport"

pause
REM pause and exit for now
exit