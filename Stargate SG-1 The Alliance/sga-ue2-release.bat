title Stargate SG-1 : The Alliance UE2 Porting Script

@echo off

cls
REM enter directories of required programs
:UT2004
SET /P level="Enter your UT2004 Directory:"
if exist "%level%\System\UCC.exe" (
  echo UCC Found.
) else (
  echo UCC Not Found!
  goto :UT2004
  pause
  exit
)

:UMODEL
SET /P model="Enter your UModel Directory:"
if exist "%model%\umodel.exe" (
  echo UModel Found.
) else (
  echo UModel Not Found!
  goto :UMODEL
  pause
  exit
)

:FFMPEG
SET /P sound="Enter your FFMPEG Directory:"
if exist "%sound%\bin\ffmpeg.exe" (
  echo FFMPEG Found.
) else (
  echo FFMPEG Not Found!
  goto :FFMPEG
  pause
  exit
)

:XBOX
SET /P files="Enter the directory containing Stargate SG-1: The Alliance files:"

if exist "%files%\xbox.bin" (
  echo "xbox.bin" Found.
) else (
  echo "xbox.bin" Not Found!
  goto :XBOX
  pause
  exit
)

echo Reminder : The directory for Stargate SG-1: The Alliance will be modified and deleted during the process, so make sure you still have the original 7z file somewhere!

pause

del %files%\Textures\M01Tex.utx %files%\Textures\M05ATex.utx %files%\Textures\M05BTex.utx %files%\Textures\M05CTex.utx %files%\Textures\M05dTex.utx %files%\Textures\M08Tex.utx %files%\Textures\M10Atex.utx %files%\Textures\M10Btex.utx %files%\Textures\M12Tex_test.utx %files%\Textures\M15Tex22.utx %files%\Textures\M15Tex_tomerge.utx %files%\Textures\m16.utx %files%\Textures\M16ATex.utx %files%\Textures\M16BTex.utx %files%\Textures\StargateEffectsTex.utx %files%\Textures\M10_train_anim.ukx %files%\Textures\SGAllianceUIX.uix %files%\Textures\UE2Runtime.ini %files%\Textures\XBoxLiveFont.xpr %files%\Textures\m17tex.utx %files%\Textures\x_delete_m17tex.utx %files%\Textures\xx_old_m17tex.utx %files%\Textures\M07_fresco_tex.utx %files%\Textures\M10_train_tex.utx %files%\Textures\StargateGameFontsTex.utx %files%\Textures\Tutorial_Tex.utx

del %files%\Animations\sg1_anim_comp.ukx %files%\Animations\sg1_anim2.ukx %files%\Animations\Goauld_Turret_anim.ukx %files%\Animations\Goa_Vehicles.ukx %files%\Animations\Haaken_anim.ukx %files%\Animations\Haaken_leader_anim.ukx %files%\Animations\Haaken_Shield_anim.ukx %files%\Animations\Haaken_warrior_anim.ukx %files%\Animations\jaffa_anim.ukx %files%\Animations\M07_fresco_anim.ukx %files%\Animations\M21_Crystal_anim.ukx %files%\Animations\sg1_anim.ukx %files%\Animations\sg1_turret_M60_Humvee.ukx %files%\Animations\SG1_weapons_1st.ukx %files%\Animations\SG1_Wep_Anim2.ukx.tmp %files%\Animations\super_soldier_anim.ukx %files%\Animations\tokra_anim.ukx %files%\Animations\veh_jeep.ukx

del %files%\StaticMeshes\M16Prefabs.upx %files%\StaticMeshes\UW.ini

mkdir "%level%\Speech\"

for /r "%files%\Maps" %%G in (*.unr) do ren "%%~G" *.ut2

cd /d %model%

umodel -path=%files%\Maps -export *.ut2

for /f %%f in ('dir /b %model%\UmodelExport\') do move %model%\UmodelExport\%%f "%level%\Maps\%%f"

umodel -path=%files%\Animations -export *.ukx

for /f %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%level%\Animations\%%f"

for /f %%f in ('dir /b %files%\Music\') do move %files%\Music\%%f "%level%\Music\%%f"

for /f %%f in ('dir /b %files%\Speech\') do move %files%\Speech\%%f "%level%\Speech\%%f"

umodel -path=%files%\StaticMeshes -export *.usx

for /D %%D in ("%model%\UmodelExport\*") do (
    for %%F in ("%%~D\StaticMesh\*.pskx*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

Rem FOR /d /r . %%d IN (StaticMesh,Shader,Texture,TexEnvMap) DO @IF EXIST "%%d" rd /s /q "%%d"

for /f "delims=|" %%f in ('dir /b %model%\UmodelExport\') do move "%model%\UmodelExport\%%f" "%level%\StaticMeshes\%%f"

umodel -path=%files%\Textures -export *.utx
for /D %%D in ("%model%\UmodelExport\*") do (
    for %%F in ("%%~D\Texture\*.tga*") do (
        move /Y "%%~F" "%%~dpF.."
    )
)

Rem FOR /d /r . %%d IN (Texture,Shader,TexEnvMap,TexPanner,Combiner,FinalBlend,TexOscillator,TexRotator,TexScaler,StaticMesh,VertMesh) DO @IF EXIST "%%d" rd /s /q "%%d"

cd /d "%level%\System"

for /f %%f in ('dir /b %model%\UmodelExport\') do ucc pkg import texture %%f %model%\UmodelExport\%%f
for /r "%level%\System" %%x in (*.utx) do move "%%x" "%level%\Textures"
rmdir /q /s %model%\UmodelExport\
mkdir %model%\UmodelExport\

for /f "usebackq delims=|" %%f in (`dir /b "%files%\Sounds\"`) do ucc batchexport %files%\Sounds\%%f sound wav %model%\UmodelExport\%%~nf

for /f "usebackq delims=|" %%f in (`dir /b "%model%\UmodelExport\"`) do "%sound%\bin\ffmpeg" "%%f" "%%f"

for /f %%f in ('dir /b %model%\UmodelExport\') do ucc pkg import sound %%f %model%\UmodelExport\%%f
for /r "%level%\System" %%x in (*.uax) do move "%%x" "%level%\Sounds"
rmdir /q /s %model%\UmodelExport\
mkdir %model%\UmodelExport\

REM rmdir /q /s %files%

pause