del C:\SGA\Textures\M01Tex.utx C:\SGA\Textures\M05ATex.utx C:\SGA\Textures\M05BTex.utx C:\SGA\Textures\M05CTex.utx C:\SGA\Textures\M05dTex.utx C:\SGA\Textures\M08Tex.utx C:\SGA\Textures\M10Atex.utx C:\SGA\Textures\M10Btex.utx C:\SGA\Textures\M12Tex_test.utx C:\SGA\Textures\M15Tex22.utx C:\SGA\Textures\M15Tex_tomerge.utx C:\SGA\Textures\m16.utx C:\SGA\Textures\M16ATex.utx C:\SGA\Textures\M16BTex.utx C:\SGA\Textures\StargateEffectsTex.utx C:\SGA\Textures\M10_train_anim.ukx C:\SGA\Textures\SGAllianceUIX.uix C:\SGA\Textures\UE2Runtime.ini C:\SGA\Textures\XBoxLiveFont.xpr C:\SGA\Textures\m17tex.utx C:\SGA\Textures\x_delete_m17tex.utx C:\SGA\Textures\xx_old_m17tex.utx C:\SGA\Textures\M07_fresco_tex.utx C:\SGA\Textures\M10_train_tex.utx C:\SGA\Textures\StargateGameFontsTex.utx C:\SGA\Textures\Tutorial_Tex.utx

del C:\SGA\Animations\Goauld_Turret_anim.ukx C:\SGA\Animations\Goa_Vehicles.ukx C:\SGA\Animations\Haaken_anim.ukx C:\SGA\Animations\Haaken_leader_anim.ukx C:\SGA\Animations\Haaken_Shield_anim.ukx C:\SGA\Animations\Haaken_warrior_anim.ukx C:\SGA\Animations\jaffa_anim.ukx C:\SGA\Animations\M07_fresco_anim.ukx C:\SGA\Animations\M21_Crystal_anim.ukx C:\SGA\Animations\sg1_anim.ukx C:\SGA\Animations\sg1_turret_M60_Humvee.ukx C:\SGA\Animations\SG1_weapons_1st.ukx C:\SGA\Animations\SG1_Wep_Anim2.ukx.tmp C:\SGA\Animations\super_soldier_anim.ukx C:\SGA\Animations\tokra_anim.ukx C:\SGA\Animations\veh_jeep.ukx

del C:\SGA\StaticMeshes\M16Prefabs.upx C:\SGA\StaticMeshes\UW.ini

mkdir "C:\GOG Games\Unreal Tournament 2004\Speech\"

umodel -path=C:\SGA\Animations -export *.ukx

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move C:\umodel_win32\UmodelExport\%%f "C:\GOG Games\Unreal Tournament 2004\Animations\%%f"

for /f %%f in ('dir /b C:\SGA\Music\') do move C:\SGA\Music\%%f "C:\GOG Games\Unreal Tournament 2004\Music\%%f"

for /f %%f in ('dir /b C:\SGA\Speech\') do move C:\SGA\Speech\%%f "C:\GOG Games\Unreal Tournament 2004\Speech\%%f"

umodel -path=C:\SGA\StaticMeshes -export *.usx

for /D %%D in ("C:\umodel_win32\UmodelExport\*") do (
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move "C:\umodel_win32\UmodelExport\%%f" "C:\GOG Games\Unreal Tournament 2004\StaticMeshes\%%f"

umodel -path=C:\SGA\Textures -export *.utx
for /D %%D in ("C:\umodel_win32\UmodelExport\*") do (
    for %%F in ("%%~D\Texture\*.tga*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

for /r "C:\SGA\Maps" %%G in (*.unr) do ren "%%~G" *.ut2

umodel -path=C:\SGA\Maps -export *.ut2

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do move C:\umodel_win32\UmodelExport\%%f "C:\GOG Games\Unreal Tournament 2004\Maps\%%f"

cd "C:\GOG Games\Unreal Tournament 2004\System"

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do ucc pkg import texture %%f C:\umodel_win32\UmodelExport\%%f
for /r "C:\GOG Games\Unreal Tournament 2004\System" %%x in (*.utx) do move "%%x" "C:\GOG Games\Unreal Tournament 2004\Textures"
rmdir /q /s C:\umodel_win32\UmodelExport\
mkdir C:\umodel_win32\UmodelExport\

for /f "usebackq delims=|" %%f in (`dir /b "C:\SGA\Sounds\"`) do ucc batchexport C:\SGA\Sounds\%%f sound wav C:\umodel_win32\UmodelExport\%%~nf

for /f "usebackq delims=|" %%f in (`dir /b "C:\umodel_win32\UmodelExport\"`) do "C:\ffmpeg\bin\ffmpeg" "%%f" "%%f"

for /f %%f in ('dir /b C:\umodel_win32\UmodelExport\') do ucc pkg import sound %%f C:\umodel_win32\UmodelExport\%%f
for /r "C:\GOG Games\Unreal Tournament 2004\System" %%x in (*.uax) do move "%%x" "C:\GOG Games\Unreal Tournament 2004\Sounds"
rmdir /q /s C:\umodel_win32\UmodelExport\
mkdir C:\umodel_win32\UmodelExport\

rmdir /q /s C:\SGA

pause