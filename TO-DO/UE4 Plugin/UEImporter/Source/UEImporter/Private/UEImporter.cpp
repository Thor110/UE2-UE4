// Copyright Epic Games, Inc. All Rights Reserved.

#include "UEImporter.h"
#include "UEImporterStyle.h"
#include "UEImporterCommands.h"
#include "LevelEditor.h"
#include "Widgets/Docking/SDockTab.h"
#include "Widgets/Layout/SBox.h"
#include "Widgets/Text/STextBlock.h"
#include "ToolMenus.h"

static const FName UEImporterTabName("UEImporter");

#define LOCTEXT_NAMESPACE "FUEImporterModule"

void FUEImporterModule::StartupModule()
{
	// This code will execute after your module is loaded into memory; the exact timing is specified in the .uplugin file per-module
	
	FUEImporterStyle::Initialize();
	FUEImporterStyle::ReloadTextures();

	FUEImporterCommands::Register();
	
	PluginCommands = MakeShareable(new FUICommandList);

	PluginCommands->MapAction(
		FUEImporterCommands::Get().OpenPluginWindow,
		FExecuteAction::CreateRaw(this, &FUEImporterModule::PluginButtonClicked),
		FCanExecuteAction());

	UToolMenus::RegisterStartupCallback(FSimpleMulticastDelegate::FDelegate::CreateRaw(this, &FUEImporterModule::RegisterMenus));
	
	FGlobalTabmanager::Get()->RegisterNomadTabSpawner(UEImporterTabName, FOnSpawnTab::CreateRaw(this, &FUEImporterModule::OnSpawnPluginTab))
		.SetDisplayName(LOCTEXT("FUEImporterTabTitle", "UEImporter"))
		.SetMenuType(ETabSpawnerMenuType::Hidden);
}

void FUEImporterModule::ShutdownModule()
{
	// This function may be called during shutdown to clean up your module.  For modules that support dynamic reloading,
	// we call this function before unloading the module.

	UToolMenus::UnRegisterStartupCallback(this);

	UToolMenus::UnregisterOwner(this);

	FUEImporterStyle::Shutdown();

	FUEImporterCommands::Unregister();

	FGlobalTabmanager::Get()->UnregisterNomadTabSpawner(UEImporterTabName);
}

TSharedRef<SDockTab> FUEImporterModule::OnSpawnPluginTab(const FSpawnTabArgs& SpawnTabArgs)
{
	FText WidgetText = FText::Format(
		//LOCTEXT("WindowWidgetText", "Add code to {0} in {1} to override this window's contents"),
		LOCTEXT("WindowWidgetText", "Locate the directory of the UE2 project that you wish to convert."),
		FText::FromString(TEXT("FUEImporterModule::OnSpawnPluginTab")),
		FText::FromString(TEXT("UEImporter.cpp"))
		);

	return SNew(SDockTab)
		.TabRole(ETabRole::NomadTab)
		[
			// Put your tab content here!
			SNew(SBox)
			.HAlign(HAlign_Center)
			.VAlign(VAlign_Top)
			[
				SNew(STextBlock)
				.Text(WidgetText)
			]
		];
}

void FUEImporterModule::PluginButtonClicked()
{
	FGlobalTabmanager::Get()->TryInvokeTab(UEImporterTabName);
}

void FUEImporterModule::RegisterMenus()
{
	// Owner will be used for cleanup in call to UToolMenus::UnregisterOwner
	FToolMenuOwnerScoped OwnerScoped(this);

	{
		UToolMenu* Menu = UToolMenus::Get()->ExtendMenu("LevelEditor.MainMenu.Window");
		{
			FToolMenuSection& Section = Menu->FindOrAddSection("WindowLayout");
			Section.AddMenuEntryWithCommandList(FUEImporterCommands::Get().OpenPluginWindow, PluginCommands);
		}
	}

	{
		UToolMenu* ToolbarMenu = UToolMenus::Get()->ExtendMenu("LevelEditor.LevelEditorToolBar");
		{
			FToolMenuSection& Section = ToolbarMenu->FindOrAddSection("Settings");
			{
				FToolMenuEntry& Entry = Section.AddEntry(FToolMenuEntry::InitToolBarButton(FUEImporterCommands::Get().OpenPluginWindow));
				Entry.SetCommandList(PluginCommands);
			}
		}
	}
}

#undef LOCTEXT_NAMESPACE
	
IMPLEMENT_MODULE(FUEImporterModule, UEImporter)