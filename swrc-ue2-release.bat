mkdir "C:\GOG Games\Unreal Tournament 2004\Speech\"

umodel -path=C:\SWRC\Animations -export *.ukx

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move C:\umodel_win32\UmodelExport\%%f "C:\GOG Games\Unreal Tournament 2004\Animations\%%f"

for /f %%f in ('dir /b C:\SWRC\Music\') do move C:\SWRC\Music\%%f "C:\GOG Games\Unreal Tournament 2004\Music\%%f"

for /f %%f in ('dir /b C:\SWRC\Speech\') do move C:\SWRC\Speech\%%f "C:\GOG Games\Unreal Tournament 2004\Speech\%%f"

umodel -path=C:\SWRC\StaticMeshes -export *.usx

for /D %%D in ("C:\umodel_win32\UmodelExport\*") do (
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move "C:\umodel_win32\UmodelExport\%%f" "C:\GOG Games\Unreal Tournament 2004\StaticMeshes\%%f"

umodel -path=C:\SWRC\Textures -export *.utx
for /D %%D in ("C:\umodel_win32\UmodelExport\*") do (
    for %%F in ("%%~D\Texture\*.tga*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

cd "C:\GOG Games\Unreal Tournament 2004\System"

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do ucc pkg import texture %%f C:\umodel_win32\UmodelExport\%%f
for /r "C:\GOG Games\Unreal Tournament 2004\System" %%x in (*.utx) do move "%%x" "C:\GOG Games\Unreal Tournament 2004\Textures"
rmdir /q /s C:\umodel_win32\UmodelExport\
mkdir C:\umodel_win32\UmodelExport\

cd "C:\SWRC\System"

for /f "usebackq delims=|" %%f in (`dir /b "C:\SWRC\Sounds\"`) do ucc batchexport C:\SWRC\Sounds\%%f sound wav C:\umodel_win32\UmodelExport\%%~nf

cd "C:\GOG Games\Unreal Tournament 2004\System"

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do ucc pkg import sound %%f C:\umodel_win32\UmodelExport\%%f
for /r "C:\GOG Games\Unreal Tournament 2004\System" %%x in (*.uax) do move "%%x" "C:\GOG Games\Unreal Tournament 2004\Sounds"
rmdir /q /s C:\umodel_win32\UmodelExport\
mkdir C:\umodel_win32\UmodelExport\

rmdir /q /s C:\SWRC

pause