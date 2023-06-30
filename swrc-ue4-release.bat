title Star Wars Republic Commando UE4 Porting Script
set first=%cd%

echo off
cls
SET /P level="Enter the duplicated Star Wars Republic Commando GameData Directory:"

if exist "%level%\System\UCC.exe" (
  echo UCC Found.
) else (
  echo UCC Not Found!
  pause
  exit
)

SET /P model="Enter your UModel Directory:"

if exist "%model%\umodel.exe" (
  echo UModel Found.
) else (
  echo UModel Not Found!
  pause
  exit
)

SET /P blend="Enter your Blender Directory:"

if exist "%blend%\blender.exe" (
  echo Blender Found.
) else (
  echo Blender Not Found!
  pause
  exit
)

SET /P start="Enter the directory of the UE4/5 Content Folder:"

if exist "%start%" (
  echo Content Folder Found.
  pause
) else (
  echo Content Folder Not Found!
  pause
  exit
)

mkdir "%start%\Textures" "%start%\StaticMeshes" %start%\Sounds %start%\Animations %start%\Music\

del %files%\Sounds\banter_voice.uax %files%\Sounds\params_mus.uax %files%\Sounds\params_rumble.uax %files%\Sounds\params_sfx.uax %files%\Sounds\params_vox.uax

cd /d %model%

umodel -path="%level%\Animations" -export *.ukx

for /f %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\Animations\%%f"

for /f %%f in ('dir /b "%level%\Music\"') do move "%level%\Music\%%f" %start%\Music\%%f

umodel -path="%level%\Textures" -export *.utx
for /D %%D in ("%model%\UmodelExport\*") do (
    for %%F in ("%%~D\Texture\*.tga*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\Textures\%%f"

umodel -path="%level%\StaticMeshes" -export *.usx

for /D %%D in ("%model%\UmodelExport\*") do (
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%start%\StaticMeshes\%%f"

cd /d "%level%\System"

for /f "usebackq delims=|" %%f in (`dir /b "%level%\Sounds\"`) do ucc batchexport "%level%\Sounds\%%f" sound wav %model%\UmodelExport\%%~nf

for /f %%f in ('dir /b %model%\UmodelExport\') do move %model%\UmodelExport\%%f %start%\Sounds\%%f

cd /d C:\

rmdir /q /s %level%

@echo off
setlocal disableDelayedExpansion

:Variables
set InputFile=%first%\batch-convert-fbx.txt
set OutputFile=%blend%\batch-convert-fbx.py
set "_strFind=path = 'C:\'"
set "_strInsert=path = '%start%'"

:Replace
>"%OutputFile%" (
for /f "usebackq delims=" %%A in ("%InputFile%") do (
    if "%%A" equ "%_strFind%" (echo %_strInsert%) else (echo %%A)
  )
)

cd %blend%

blender -b -P batch-convert-fbx.py

Rem delete all the .pskx folders after figuring out the truncated model issue

pause