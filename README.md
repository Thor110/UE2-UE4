# UE2-UE4
A batch script I am working on that prepares all of the files for a port I am working on.

UE4 ( for UE4 version only ) - Not actually required yet!

UT2004 ( required to export the sound packages )

UModel from https://www.gildor.org/en/projects/umodel

A copy of "Stargate_SG-1_-_The_Alliance-2005-12-15" which can be obtained from https://archive.org/details/StargateSG1TheAlliance20051215

FFMPEG from https://ffmpeg.org/

Install UE4 ( if required ) - not required yet.

Install UT2004 to C:\GOG Games\Unreal Tournament 2004 or edit the scripts accordingly.

( so "C:\GOG Games\Unreal Tournament 2004\System" will now exist )

Install FFMPEG to C:\ffmpeg

( so "C:\ffmpeg\bin" will now exist )

Extract umodel and copy it to C:\umodel_win32

( so "C:\umodel_win32\UmodelExport" will now exist )

Extract the game files to C:\SGA or copy Star Wars Republic Commando's GameData folder to C:\SWRC

( so "C:\SGA\Textures" will now exist ) or ( "C:\SWRC\Textures" )

Copy the script you wish to use to "C:\umodel_win32" and run it from here.

This will setup all of the files appropriately. ( Animations / StaticMeshes still remain to be converted!!! )

It will also delete the C:\SGA directory upon completion, so you can just keep or delete the original .7z file ( same goes for Republic Commando, which is why I chose to copy the GameData folder for now )