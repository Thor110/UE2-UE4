echo off
cls
SET /P level="Enter the duplicate GameData directory for Star Wars Republic Commando:"

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

echo Reminder : The GameData folder will be modified and deleted during the process, so make sure you only copied it here!

pause

mkdir "C:\SWRCUE4\Textures" "C:\SWRCUE4\StaticMeshes" C:\SWRCUE4\Sounds C:\SWRCUE4\Animations C:\SWRCUE4\Music\

del %level%\Sounds\banter_voice.uax %level%\Sounds\params_mus.uax %level%\Sounds\params_rumble.uax %level%\Sounds\params_sfx.uax %level%\Sounds\params_vox.uax

cd %model%

umodel -path=%level%\Animations -export *.ukx

for /f %%f in ('dir /b %model%\UmodelExport\') do move %model%\UmodelExport\%%f C:\SWRCUE4\Animations\%%f

for /f %%f in ('dir /b %level%\Music\') do move %level%\Music\%%f C:\SWRCUE4\Music\%%f

umodel -path=%level%\Textures -export *.utx
for /D %%D in ("%model%\UmodelExport\*") do (
    for %%F in ("%%~D\Texture\*.tga*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "C:\SWRCUE4\Textures\%%f"

umodel -path=%level%\StaticMeshes -export *.usx

for /D %%D in ("%model%\UmodelExport\*") do (
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "C:\SWRCUE4\StaticMeshes\%%f"

cd %level%\System

for /f "usebackq delims=|" %%f in (`dir /b "%level%\Sounds\"`) do ucc batchexport %level%\Sounds\%%f sound wav %model%\UmodelExport\%%~nf

for /f %%f in ('dir /b %model%\UmodelExport\') do move %model%\UmodelExport\%%f C:\SWRCUE4\Sounds\%%f

rmdir /q /s %level%

pause