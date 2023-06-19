# UE2-UE4
A batch script I am working on that prepares all of the files for a port I am working on.
UE4 ( for UE4 version only ) - Not actually required yet!
UT2004 ( required to export the sound packages )
UModel from https://www.gildor.org/en/projects/umodel
A copy of "Stargate_SG-1_-_The_Alliance-2005-12-15" which can be obtained from https://archive.org/details/StargateSG1TheAlliance20051215
FFMPEG from https://ffmpeg.org/

Install UE4 ( if required )

Install UT2004

Install FFMPEG to C:\ffmpeg
( so "C:\ffmpeg\bin" will now exist )

Extract umodel and copy it to C:\umodel_win32
( so "C:\umodel_win32\UmodelExport" will now exist )

Extract the game files to C:\SGA
( so "C:\SGA\Textures" will now exist )

Copy the script to "C:\umodel_win32" and run it from here.

This will setup all of the files appropriately. ( Animations / StaticMeshes still remain!!! )

It will also delete the C:\SGA directory upon completion, so you can just keep or delete the original .7z file