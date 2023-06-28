# UE2-UE4
A batch script or set of batch scripts I am working on that prepares all of the files for a port I am working on.

Stargate SG-1 : The Alliance

UE2			: Stargate SG-1 : The Alliance

FILENAME	: sga-ue2-release.bat

REQUIRED	: GAME(SGA) + UMODEL + UT2004 + FFMPEG

UE4			: Stargate SG-1 : The Alliance

FILENAME	: sga-ue4-release.bat

REQUIRED	: GAME(SGA) + UMODEL + UT2004 + FFMPEG

Star Wars Republic Commando

UE2			: Star Wars Republic Commando

FILENAME	: swrc-ue2-release.bat

REQUIRED	: GAME(SWRC) + FIX(LEONS) + UMODEL + UT2004

UE4			: Star Wars Republic Commando

FILENAME	: swrc-ue4-release.bat

REQUIRED	: GAME(SWRC) + FIX(LEONS) + UMODEL

UE4 ( for UE4 version only ) - Not actually required yet!

UT2004 ( required to export the sound packages )

UModel from https://www.gildor.org/en/projects/umodel

A copy of "Stargate_SG-1_-_The_Alliance-2005-12-15" which can be obtained from https://archive.org/details/StargateSG1TheAlliance20051215

FFMPEG from https://ffmpeg.org/

Install UT2004

or

Install Star Wars Republic Commando and Leon's latest fix available from : https://github.com/SWRC-Modding/CT/releases

Install FFMPEG

Install UModel

Extract the game files to C:\SGA or copy Star Wars Republic Commando's GameData folder to C:\SWRC

NOTE : This folder will be deleted, so make sure to keep the original .7zip file for SGA and to copy the GameData folder for SWRC.

( so "C:\SGA\Textures" will now exist ) or ( "C:\SWRC\Textures" )

The scripts can now be run from anywhere and will request that you enter the directories for the required files, the script will then check the required programs exist before going on to use them.

Example directories to enter for SGA.

C:\GOG Games\Unreal Tournament 2004

C:\umodel_win32

C:\ffmpeg

C:\SGA

Example directories to enter for SWRC.

C:\SWRC

C:\umodel_win32

This will setup all of the files appropriately. ( Animations / StaticMeshes still remain to be converted to .fbx!!! )

It will also delete the C:\SGA directory upon completion, so you can just keep or delete the original .7z file ( same goes for Republic Commando, which is why I chose to copy the GameData folder for now )