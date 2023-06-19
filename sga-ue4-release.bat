del C:\SGA\Textures\M01Tex.utx C:\SGA\Textures\M05ATex.utx C:\SGA\Textures\M05BTex.utx C:\SGA\Textures\M05CTex.utx C:\SGA\Textures\M05dTex.utx C:\SGA\Textures\M08Tex.utx C:\SGA\Textures\M10Atex.utx C:\SGA\Textures\M10Btex.utx C:\SGA\Textures\M12Tex_test.utx C:\SGA\Textures\M15Tex22.utx C:\SGA\Textures\M15Tex_tomerge.utx C:\SGA\Textures\m16.utx C:\SGA\Textures\M16ATex.utx C:\SGA\Textures\M16BTex.utx C:\SGA\Textures\StargateEffectsTex.utx C:\SGA\Textures\M10_train_anim.ukx C:\SGA\Textures\SGAllianceUIX.uix C:\SGA\Textures\UE2Runtime.ini C:\SGA\Textures\XBoxLiveFont.xpr C:\SGA\Textures\m17tex.utx C:\SGA\Textures\x_delete_m17tex.utx C:\SGA\Textures\xx_old_m17tex.utx C:\SGA\Textures\M07_fresco_tex.utx C:\SGA\Textures\M10_train_tex.utx C:\SGA\Textures\StargateGameFontsTex.utx C:\SGA\Textures\Tutorial_Tex.utx

mkdir "C:\SGAUE4\Textures" "C:\SGAUE4\StaticMeshes" C:\SGAUE4\Sounds C:\SGAUE4\Animations C:\SGAUE4\Music\ C:\SGAUE4\Speech\

umodel -path=C:\SGA\Animations -export *.ukx

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move C:\umodel_win32\UmodelExport\%%f C:\SGAUE4\Animations\%%f

for /f %%f in ('dir /b C:\SGA\Music\') do move C:\SGA\Music\%%f C:\SGAUE4\Music\%%f

for /f %%f in ('dir /b C:\SGA\Speech\') do move C:\SGA\Speech\%%f C:\SGAUE4\Speech\%%f

umodel -path=C:\SGA\Textures -export *.utx
for /D %%D in ("C:\umodel_win32\UmodelExport\*") do (
    for %%F in ("%%~D\Texture\*.tga*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move "C:\umodel_win32\UmodelExport\%%f" "C:\SGAUE4\Textures\%%f"

umodel -path=C:\SGA\StaticMeshes -export *.usx

for /D %%D in ("C:\umodel_win32\UmodelExport\*") do (
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move "C:\umodel_win32\UmodelExport\%%f" "C:\SGAUE4\StaticMeshes\%%f"

cd C:\GOG Games\Unreal Tournament 2004\System

for /f "usebackq delims=|" %%f in (`dir /b "C:\SGA\Sounds\"`) do ucc batchexport C:\SGA\Sounds\%%f sound wav C:\umodel_win32\UmodelExport\%%~nf

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move C:\umodel_win32\UmodelExport\%%f C:\SGAUE4\Sounds\%%f

for /f "usebackq delims=|" %%f in (`dir /b "C:\SGAUE4\Sounds\"`) do "C:\ffmpeg\bin\ffmpeg" "%%f" "%%f"

rmdir /q /s C:\SGA

pause