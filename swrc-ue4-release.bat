mkdir "C:\SWRCUE4\Textures" "C:\SWRCUE4\StaticMeshes" C:\SWRCUE4\Sounds C:\SWRCUE4\Animations C:\SWRCUE4\Music\

del C:\SWRC\Sounds\banter_voice.uax C:\SWRC\Sounds\params_mus.uax C:\SWRC\Sounds\params_rumble.uax C:\SWRC\Sounds\params_sfx.uax C:\SWRC\Sounds\params_vox.uax

umodel -path=C:\SWRC\Animations -export *.ukx

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move C:\umodel_win32\UmodelExport\%%f C:\SWRCUE4\Animations\%%f

for /f %%f in ('dir /b C:\SWRC\Music\') do move C:\SWRC\Music\%%f C:\SWRCUE4\Music\%%f

for /f %%f in ('dir /b C:\SWRC\Speech\') do move C:\SWRC\Speech\%%f C:\SWRCUE4\Speech\%%f

umodel -path=C:\SWRC\Textures -export *.utx
for /D %%D in ("C:\umodel_win32\UmodelExport\*") do (
    for %%F in ("%%~D\Texture\*.tga*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move "C:\umodel_win32\UmodelExport\%%f" "C:\SWRCUE4\Textures\%%f"

umodel -path=C:\SWRC\StaticMeshes -export *.usx

for /D %%D in ("C:\umodel_win32\UmodelExport\*") do (
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move "C:\umodel_win32\UmodelExport\%%f" "C:\SWRCUE4\StaticMeshes\%%f"

cd C:\SWRC\System

for /f "usebackq delims=|" %%f in (`dir /b "C:\SWRC\Sounds\"`) do ucc batchexport C:\SWRC\Sounds\%%f sound wav C:\umodel_win32\UmodelExport\%%~nf

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move C:\umodel_win32\UmodelExport\%%f C:\SWRCUE4\Sounds\%%f

rmdir /q /s C:\SWRC

pause