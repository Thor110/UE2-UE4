# UE2-UE4
A batch script or set of batch scripts I am working on that prepares all of the files for a port I am working on.

Stargate SG-1 : The Alliance

UE2			: Stargate SG-1 : The Alliance

FILENAME	: sga-ue2-release.bat

REQUIRED	: GAME(SGA) + UMODEL + UT2004 + FFMPEG

UE4			: Stargate SG-1 : The Alliance

FILENAME	: sga-ue4-release.bat

REQUIRED	: GAME(SGA) + UMODEL + UT2004 + FFMPEG + BLENDER(2.93)

Star Wars Republic Commando

UE2			: Star Wars Republic Commando

FILENAME	: swrc-ue2-release.bat

REQUIRED	: GAME(SWRC) + FIX(LEONS) + UMODEL + UT2004

UE4			: Star Wars Republic Commando

FILENAME	: swrc-ue4-release.bat

REQUIRED	: GAME(SWRC) + FIX(LEONS) + UMODEL + BLENDER(2.93)

Required Programs

Blender from https://www.blender.org/ v2.93 to be specific.

Blender3D Import psk psa addon from the releases section at https://github.com/Befzz/blender3d_import_psk_psa

UT2004 ( required to export the sound packages for SGA and the UE2 version of the SWRC script, not required for SWRC UE4. )

UModel from https://www.gildor.org/en/projects/umodel

A copy of "Stargate_SG-1_-_The_Alliance-2005-12-15" which can be obtained from https://archive.org/details/StargateSG1TheAlliance20051215

FFMPEG from https://ffmpeg.org/

Note : Everything should be installed to the C:\ drive.

Install UT2004 ( Required for UE2 script variants and Stargate SG-1 : The Alliance UE4! ) ( Not required for SWRC UE4 )

Install Blender and the PSKX/PSK/PSA Import Plugin.

or

Install Star Wars Republic Commando and Leon's latest fix available from : https://github.com/SWRC-Modding/CT/releases

once installed and the fix is also installed, copy the GameData folder to the C:\ drive and rename it to SWRC, this is so that the script can modify files and then delete the duplicate in the process.
as well as so that the modified UCC that comes with Leon's fixes doesn't short out on directories with spaces in them.

Install FFMPEG ( Required for Stargate SG-1 : The Alliance! )

Install UModel

Extract the game files to C:\SGA or copy Star Wars Republic Commando's GameData folder to C:\SWRC

NOTE : This folder will be deleted, so make sure to keep the original .7zip file for SGA and to copy the GameData folder for SWRC.

( so "C:\SGA\Textures" will now exist ) or ( "C:\SWRC\Textures" )

The scripts can now be run from anywhere and will request that you enter the directories for the required files, the script will then check the required programs exist before going on to use them.

Do not right click / run as administrator! Just double click or hit enter when ready.

But it should be noted once more that everything should be located on the C:\ drive to prevent issues moving files between drives.

When prompted by the script you should enter something along the lines of the following for each script.

Example directories you might enter when prompted by the SGA-UE2 script. - "sga-ue2-release.bat"

C:\GOG Games\Unreal Tournament 2004

C:\umodel_win32

C:\ffmpeg

C:\SGA

Example directories you might enter when prompted by theSGA-UE4 script. - "sga-ue4-release.bat"

C:\GOG Games\Unreal Tournament 2004

C:\umodel_win32

C:\ffmpeg

C:\SGA

C:\Program Files\Blender Foundation\Blender 2.93

C:\SGAUE4

Example directories you might enter when prompted by theSWRC-UE2 script. - "swrc-ue2-release.bat"

C:\SWRC

C:\GOG Games\Unreal Tournament 2004

C:\umodel_win32

Example directories you might enter when prompted by theSWRC-UE4 script. - "swrc-ue4-release.bat"

C:\SWRC

C:\umodel_win32

C:\Program Files\Blender Foundation\Blender 2.93

C:\SWRCUE4

This will setup all of the files appropriately. ( Animations / StaticMeshes still remain to be converted to .fbx!!! and or imported into UT2004!!! )

It will also delete the C:\SGA directory upon completion, so you can just keep or delete the original .7z file ( same goes for Republic Commando, which is why I chose to copy the GameData folder for now )