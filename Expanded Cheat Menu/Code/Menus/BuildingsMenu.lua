-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	local Translate = ChoGGi.ComFuncs.Translate
	local RetTemplateOrClass = ChoGGi.ComFuncs.RetTemplateOrClass
	local Strings = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions
	local icon = "CommonAssets/UI/Menu/Cube.tga"

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Translate(3980--[[Buildings--]]),
		ActionMenubar = "ECM.ECM",
		ActionId = ".Buildings",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Buildings",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000164--[[Storage Amount Of Diner & Grocery--]]],
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Storage Amount Of Diner & Grocery",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.ServiceWorkplaceFoodStorage,
				Strings[302535920000167--[[Change how much food is stored in them (less chance of starving colonists when busy).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetStorageAmountOfDinerGrocery,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000168--[[Triboelectric Scrubber Radius--]]],
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Triboelectric Scrubber Radius",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.TriboelectricScrubberRadius,
				Strings[302535920000170--[[Extend the range of the scrubber.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetUIRangeBuildingRadius,
		bld_id = "TriboelectricScrubber",
		bld_msg = Strings[302535920000169--[["Ladies and gentlemen, this is your captain speaking. We have a small problem.
All four engines have stopped. We are doing our damnedest to get them going again.
I trust you are not in too much distress."--]]],
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000171--[[SubsurfaceHeater Radius--]]],
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".SubsurfaceHeater Radius",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SubsurfaceHeaterRadius,
				Strings[302535920000173--[[Extend the range of the heater.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetUIRangeBuildingRadius,
		bld_id = "SubsurfaceHeater",
		bld_msg = Strings[302535920000172--[[Some smart quip about heating?--]]],
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000176--[[Empty Mech Depot--]]],
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Empty Mech Depot",
		ActionIcon = icon,
		RolloverText = Strings[302535920000177--[[Empties out selected/moused over mech depot into a small depot in front of it.--]]],
		OnAction = ChoGGi.ComFuncs.EmptyMechDepot,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000210--[[Moisture Vaporator Penalty--]]],
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Moisture Vaporator Penalty",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.MoistureVaporatorRange,
				Strings[302535920000211--[[Disable penalty when Moisture Vaporators are close to each other.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.MoistureVaporatorPenalty_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000180--[[Unlock Locked Buildings--]]],
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Unlock Locked Buildings",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = Strings[302535920000181--[["Shows a list of buildings you can unlock.
This doesn't apply to sponsor limited ones; see Toggles\%s."--]]]:format(Strings[302535920001398--[[Remove Sponsor Limits--]]]),
		OnAction = ChoGGi.MenuFuncs.UnlockLockedBuildings,
	}

	-- menu
	local SandS = Translate(5245--[[Sanatoriums--]]) .. " & " .. Translate(5248--[[Schools--]])
	c = c + 1
	Actions[c] = {ActionName = SandS,
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Sanatoriums & Schools",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Sanatoriums & Schools",
	}

	c = c + 1
	Actions[c] = {ActionName = Translate(5245--[[Sanatoriums--]]) .. " " .. Strings[302535920000198--[[Cure All--]]],
		ActionMenubar = "ECM.ECM.Buildings.Sanatoriums & Schools",
		ActionId = ".Sanatoriums Cure All",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SanatoriumCureAll,
				Strings[302535920000199--[[Toggle curing all traits (use "Show All Traits" & "Show Full List" to manually set).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SanatoriumCureAll_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Translate(5248--[[Schools--]]) .. " " .. Strings[302535920000200--[[Train All--]]],
		ActionMenubar = "ECM.ECM.Buildings.Sanatoriums & Schools",
		ActionId = ".Schools Train All",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SchoolTrainAll,
				Strings[302535920000199--[[Toggle curing all traits (use "Show All Traits" & "Show Full List" to manually set).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SchoolTrainAll_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = SandS .. ": " .. Strings[302535920000202--[[Show All Traits--]]],
		ActionMenubar = "ECM.ECM.Buildings.Sanatoriums & Schools",
		ActionId = ".Sanatoriums & Schools: Show All Traits",
		ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SanatoriumSchoolShowAllTraits,
				Strings[302535920000203--[[Shows all appropriate traits in Sanatoriums/Schools side panel popup menu.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ShowAllTraits_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = SandS .. ": " .. Strings[302535920000204--[[Show Full List--]]],
		ActionMenubar = "ECM.ECM.Buildings.Sanatoriums & Schools",
		ActionId = ".Sanatoriums & Schools: Show Full List",
		ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SanatoriumSchoolShowAll,
				Strings[302535920000205--[[Toggle showing full list of trait selectors in side pane.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SanatoriumSchoolShowAll,
	}

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Translate(5068--[[Farms--]]),
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Farms",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Farms",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000192--[[Farm Shifts All On--]]],
		ActionMenubar = "ECM.ECM.Buildings.Farms",
		ActionId = ".Farm Shifts All On",
		ActionIcon = icon,
		RolloverText = Strings[302535920000193--[[Turns on all the farm shifts.--]]],
		OnAction = ChoGGi.MenuFuncs.FarmShiftsAllOn,
	}

	c = c + 1
	Actions[c] = {ActionName = Translate(4711--[[Crop Fail Threshold--]]),
		ActionMenubar = "ECM.ECM.Buildings.Farms",
		ActionId = ".Crop Fail Threshold",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.CropFailThreshold,
				Strings[302535920000213--[[Remove Threshold for failing crops (crops won't fail).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CropFailThreshold_Toggle,
	}

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000157--[[Cables & Pipes--]]],
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Cables & Pipes",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Cables & Pipes",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000218--[[No Chance Of Break--]]],
		ActionMenubar = "ECM.ECM.Buildings.Cables & Pipes",
		ActionId = ".Cables & Pipes: No Chance Of Break",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.BreakChanceCablePipe,
				Strings[302535920000157--[[Cables & Pipes--]]] .. " " .. Strings[302535920000219--[[will never break.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Translate(134--[[Instant Build--]]),
		ActionMenubar = "ECM.ECM.Buildings.Cables & Pipes",
		ActionId = ".Cables & Pipes: Instant Build",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.InstantCables,
				Strings[302535920000157--[[Cables & Pipes--]]] .. " " .. Strings[302535920000221--[[are built instantly.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle,
	}

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Translate(3980--[[Buildings--]]),
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Buildings",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Buildings",
		RolloverText = Strings[302535920000063--[[You need to select a building before using these.--]]],
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000194--[[Production Amount Set--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Production Amount Set",
		ActionIcon = icon,
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".production",
				Strings[302535920000195--[["Set production of buildings of selected type, also applies to newly placed ones.
	Works on any building that produces."--]]]
			) or Strings[302535920000195]
		end,
		OnAction = ChoGGi.MenuFuncs.SetProductionAmount,
		ActionShortcut = "Ctrl-Shift-P",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000186--[[Power-free Building--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Power-free Building",
		ActionIcon = icon,
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".nopower",
				Strings[302535920000187--[[Toggle electricity use for selected building type.--]]]
			) or Strings[302535920000187]
		end,
		OnAction = ChoGGi.MenuFuncs.BuildingPower_Toggle,
		ActionSortKey = "2Power-free Building",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001251--[[Water-free Building--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Water-free Building",
		ActionIcon = icon,
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".nowater",
				Strings[302535920001252--[[Toggle water use for selected building type.--]]]
			) or Strings[302535920001252]
		end,
		OnAction = ChoGGi.MenuFuncs.BuildingWater_Toggle,
		ActionSortKey = "2Water-free Building",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001253--[[Oxygen-free Building--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Oxygen-free Building",
		ActionIcon = icon,
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".noair",
				Strings[302535920001254--[[Toggle oxygen use for selected building type.--]]]
			) or Strings[302535920001254]
		end,
		OnAction = ChoGGi.MenuFuncs.BuildingAir_Toggle,
		ActionSortKey = "2Oxygen-free Building",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000188--[[Set Charge & Discharge Rates--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Set Charge & Discharge Rates",
		ActionIcon = icon,
		RolloverText = Strings[302535920000189--[[Change how fast Air/Water/Battery storage capacity changes.--]]],
		OnAction = ChoGGi.MenuFuncs.SetMaxChangeOrDischarge,
		ActionShortcut = "Ctrl-Shift-R",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000178--[[Protection Radius--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Protection Radius",
		ActionIcon = icon,
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".protect_range",
				Strings[302535920000179--[[Change threat protection coverage distance.--]]]
			) or Strings[302535920000179]
		end,
		OnAction = ChoGGi.MenuFuncs.SetProtectionRadius,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000196--[[Fully Automated Building--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Fully Automated Building",
		ActionIcon = icon,
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".auto_performance",
				Strings[302535920000197--[[Work without workers (select a building and this will apply to all of type or selected).--]]]
			) or Strings[302535920000197]
		end,
		OnAction = ChoGGi.MenuFuncs.SetFullyAutomatedBuildings,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001114--[[Service Building Stats--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Service Building Stats",
		ActionIcon = icon,
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".service_stats",
				Strings[302535920001115--[["Tweak settings for parks and such.
Health change, Sanity change, Service Comfort, Comfort increase."--]]]
			) or Strings[302535920001115]
		end,
		OnAction = ChoGGi.MenuFuncs.SetServiceBuildingStats,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001344--[[Points To Train--]]],
		ActionMenubar = "ECM.ECM.Buildings.Buildings",
		ActionId = ".Points To Train",
		ActionIcon = "CommonAssets/UI/Menu/ramp.tga",
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".evaluation_points",
				Strings[302535920001345--[[How many points are needed to finish training.--]]]
			) or Strings[302535920001345]
		end,
		OnAction = ChoGGi.MenuFuncs.SetTrainingPoints,
	}

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001367--[[Toggles--]]],
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Toggles",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Toggle",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000159--[[Unlimited Wonders--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Unlimited Wonders",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.Building_wonder,
				Strings[302535920000223--[["Unlimited wonder build limit (blocks the ""build a wonder"" achievement)."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.Building_wonder_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000224--[[Show Hidden Buildings--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Show Hidden Buildings",
		ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.Building_hide_from_build_menu,
				Strings[302535920000225--[[Show hidden buildings in build menu.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001241--[[Instant Build--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Instant Build",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.Building_instant_build,
				Strings[302535920000229--[[Buildings are built instantly.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.Building_instant_build_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000226--[[Remove Spire Point Limit--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Remove Spire Point Limit",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.Building_dome_spot,
				Strings[302535920000227--[["Build spires anywhere in domes.
	Use with %s to fill up a dome with spires."--]]]:format(Strings[302535920000230--[[Remove Building Limits--]]])
			)
		end,
		OnAction = ChoGGi.MenuFuncs.Building_dome_spot_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000230--[[Remove Building Limits--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Remove Building Limits",
		ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RemoveBuildingLimits,
				Strings[302535920000231--[["Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes).
	See also %s."--]]]:format(Strings[302535920000226--[[Remove Spire Point Limit--]]])
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RemoveBuildingLimits_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000214--[[Cheap Construction--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Cheap Construction",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.rebuild_cost_modifier,
				Strings[302535920000215--[[Build with minimal resources.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.CheapConstruction_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000216--[[Building Damage Crime--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Building Damage Crime",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.CrimeEventSabotageBuildingsCount,
				Strings[302535920000217--[[Disable damage from renegedes to buildings.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.BuildingDamageCrime_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000206--[[Maintenance Free Inside--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Maintenance Free Inside",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.InsideBuildingsNoMaintenance,
				Strings[302535920000207--[[Buildings inside domes don't build maintenance points (takes away instead of adding).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.MaintenanceFreeBuildingsInside_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000208--[[Maintenance Free--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Maintenance Free",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RemoveMaintenanceBuildUp,
				Strings[302535920000209--[[Building maintenance points reverse (takes away instead of adding).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.MaintenanceFreeBuildings_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000174--[[Always Dusty--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Always Dusty",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.AlwaysDustyBuildings,
				Strings[302535920000175--[[Buildings will never lose their dust (unless you turn this off, then it'll reset the dust amount).
Will be overridden by %s.--]]]:format(Strings[302535920000037--[[Always Clean--]]])
			)
		end,
		OnAction = ChoGGi.MenuFuncs.AlwaysDustyBuildings_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000037--[[Always Clean--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Always Clean",
		ActionIcon = icon,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.AlwaysCleanBuildings,
				Strings[302535920000316--[[Buildings will never get dusty.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.AlwaysCleanBuildings_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000182--[[Pipes Pillars Spacing--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Pipes Pillars Spacing",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.PipesPillarSpacing,
				Strings[302535920000183--[[Only place Pillars at start and end.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.PipesPillarsSpacing_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000184--[[Unlimited Connection Length--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Unlimited Connection Length",
		ActionIcon = "CommonAssets/UI/Menu/road_type.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.UnlimitedConnectionLength,
				Strings[302535920000185--[[No more length limits to pipes, cables, and passages.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.UnlimitedConnectionLength_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000064--[[Build On Geysers--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Build On Geysers",
		ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
		OnAction = ChoGGi.MenuFuncs.BuildOnGeysers_Toggle,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.BuildOnGeysers,
				Strings[302535920000065--[[Allows you to build on geysers. Use Shift-F4 around the area to delete the geyser objects (about 10-20 depending on size).--]]]
			)
		end,
	}

  if g_AvailableDlc.gagarin then
		c = c + 1
		Actions[c] = {ActionName = Strings[302535920001398--[[Remove Sponsor Limits--]]],
			ActionMenubar = "ECM.ECM.Buildings.Toggles",
			ActionId = ".Remove Sponsor Limits",
			ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
			RolloverText = function()
				return ChoGGi.ComFuncs.SettingState(
					ChoGGi.UserSettings.SponsorBuildingLimits,
					Strings[302535920001399--[[Allow you to build all buildings no matter your sponsor.--]]]
				)
			end,
			OnAction = ChoGGi.MenuFuncs.SponsorBuildingLimits_Toggle,
		}
  end

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001407--[[Rotate During Placement--]]],
		ActionMenubar = "ECM.ECM.Buildings.Toggles",
		ActionId = ".Rotate During Placement",
		ActionIcon = "CommonAssets/UI/Menu/RotateObjectsTool.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RotateDuringPlacement,
				Strings[302535920001408--[[Allow you to rotate all buildings.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RotateDuringPlacement_Toggle,
	}

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Translate(1120--[[Space Elevator--]]),
		ActionMenubar = "ECM.ECM.Buildings",
		ActionId = ".Space Elevator",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Space Elevator",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001330--[[Instant Export On Toggle--]]],
		ActionMenubar = "ECM.ECM.Buildings.Space Elevator",
		ActionId = ".Instant Export On Toggle",
		ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SpaceElevatorToggleInstantExport,
				Strings[302535920001331--[[Toggle Forbid Exports to have it instantly export current stock.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SpaceElevatorExport_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001336--[[Export When This Amount--]]],
		ActionMenubar = "ECM.ECM.Buildings.Space Elevator",
		ActionId = ".Export When This Amount",
		ActionIcon = "CommonAssets/UI/Menu/scale_gizmo.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.export_when_this_amount",
				Strings[302535920001337--[[When you have this many rares in storage launch right away.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetExportWhenThisAmount,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001332--[[Export Amount Per Trip--]]],
		ActionMenubar = "ECM.ECM.Buildings.Space Elevator",
		ActionId = ".Export Amount Per Trip",
		ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.max_export_storage",
				Strings[302535920001333--[[How many rare metals you can export per trip.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetSpaceElevatorTransferAmount,
		setting_name = "max_export_storage",
		setting_msg = Strings[302535920001332],
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001334--[[Import Amount Per Trip--]]],
		ActionMenubar = "ECM.ECM.Buildings.Space Elevator",
		ActionId = ".Import Amount Per Trip",
		ActionIcon = "CommonAssets/UI/Menu/change_height_down.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings.SpaceElevator.cargo_capacity",
				Strings[302535920001335--[[How much storage for import you can use.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetSpaceElevatorTransferAmount,
		setting_name = "cargo_capacity",
		setting_msg = Strings[302535920001334],
	}

end
