// Copyright Epic Games, Inc. All Rights Reserved.

#include "UEImporterCommands.h"

#define LOCTEXT_NAMESPACE "FUEImporterModule"

void FUEImporterCommands::RegisterCommands()
{
	UI_COMMAND(OpenPluginWindow, "UEImporter", "Bring up UEImporter window", EUserInterfaceActionType::Button, FInputGesture());
}

#undef LOCTEXT_NAMESPACE
