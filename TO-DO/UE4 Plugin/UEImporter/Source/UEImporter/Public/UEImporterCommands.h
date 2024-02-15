// Copyright Epic Games, Inc. All Rights Reserved.

#pragma once

#include "CoreMinimal.h"
#include "Framework/Commands/Commands.h"
#include "UEImporterStyle.h"

class FUEImporterCommands : public TCommands<FUEImporterCommands>
{
public:

	FUEImporterCommands()
		: TCommands<FUEImporterCommands>(TEXT("UEImporter"), NSLOCTEXT("Contexts", "UEImporter", "UEImporter Plugin"), NAME_None, FUEImporterStyle::GetStyleSetName())
	{
	}

	// TCommands<> interface
	virtual void RegisterCommands() override;

public:
	TSharedPtr< FUICommandInfo > OpenPluginWindow;
};