echo off
cls
SET /P level="Enter your UT2004 Directory:"

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

SET /P files="Enter the duplicate GameData directory for Star Wars Republic Commando:"

if exist "%files%\System\UCC.exe" (
  echo UCC Found.
) else (
  echo UCC Not Found!
  pause
  exit
)

echo Reminder : The GameData folder will be modified and deleted during the process, so make sure you only copied it here!

pause

del %files%\Sounds\banter_voice.uax %files%\Sounds\params_mus.uax %files%\Sounds\params_rumble.uax %files%\Sounds\params_sfx.uax %files%\Sounds\params_vox.uax

umodel -path=%files%\Animations -export *.ukx

for /f %%f in ('dir /b %model%\UmodelExport\') do move %model%\UmodelExport\%%f "%level%\Animations\%%f"

for /f %%f in ('dir /b %files%\Music\') do move %files%\Music\%%f "%level%\Music\%%f"

umodel -path=%files%\StaticMeshes -export *.usx

for /D %%D in ("%model%\UmodelExport\*") do (
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%level%\StaticMeshes\%%f"

umodel -path=%files%\Textures -export *.utx
for /D %%D in ("%model%\UmodelExport\*") do (
    for %%F in ("%%~D\Texture\*.tga*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

cd "%level%\System"

for /f %%f in ('dir /b %model%\UmodelExport\') do ucc pkg import texture %%f %model%\UmodelExport\%%f
for /r "%level%\System" %%x in (*.utx) do move "%%x" "%level%\Textures"
rmdir /q /s %model%\UmodelExport\
mkdir %model%\UmodelExport\

cd "%files%\System"

for /f "usebackq delims=|" %%f in (`dir /b "%files%\Sounds\"`) do ucc batchexport %files%\Sounds\%%f sound wav %model%\UmodelExport\%%~nf

cd "%level%\System"

for /f %%f in ('dir /b %model%\UmodelExport\') do ucc pkg import sound %%f %model%\UmodelExport\%%f
for /r "%level%\System" %%x in (*.uax) do move "%%x" "%level%\Sounds"
rmdir /q /s %model%\UmodelExport\
mkdir %model%\UmodelExport\

rmdir /q /s %files%

pause