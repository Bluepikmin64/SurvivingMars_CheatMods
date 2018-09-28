-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920001314--[[Toggle Render--]]],
		ActionId = ".Toggle Render",
		ActionIcon = "CommonAssets/UI/Menu/Shot.tga",
		RolloverText = S[302535920001315--[[Toggle rendering certain stuff.--]]],
		OnAction = ChoGGi.MenuFuncs.Render_Toggle,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920001310--[[DTM Slots Display--]]],
		ActionId = ".DTM Slots Display",
		ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
		RolloverText = S[302535920001311--[[Toggle DTM slots display--]]],
		OnAction = ChoGGi.MenuFuncs.DTMSlotsDlg_Toggle,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920001312--[[FPS Counter Location--]]],
		ActionId = ".FPS Counter Location",
		ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
		RolloverText = S[302535920001313--[[One of the four corners of your screen.--]]],
		OnAction = ChoGGi.MenuFuncs.FpsCounterLocation,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920001208--[[Export Colonist Data To CSV--]]],
		ActionId = ".Export Colonist Data To CSV",
		ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
		RolloverText = S[302535920001219--[[Exports data about colonists to %sColonists.csv--]]]:format(ConvertToOSPath("AppData/")),
		OnAction = ChoGGi.MenuFuncs.ExportColonistDataToCSV,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000449--[[Attach Spots Toggle--]]],
		ActionId = ".Attach Spots Toggle",
		ActionIcon = "CommonAssets/UI/Menu/ShowAll.tga",
		RolloverText = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
		OnAction = function()
			ChoGGi.CodeFuncs.AttachSpots_Toggle()
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000451--[[Measure Tool--]]],
		ActionId = ".Measure Tool",
		ActionIcon = "CommonAssets/UI/Menu/MeasureTool.tga",
		RolloverText = S[302535920000452--[[Measures stuff (Use Ctrl-Shift-M to remove the lines).--]]],
		OnAction = ChoGGi.MenuFuncs.MeasureTool_Toggle,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.MeasureTool_Toggle,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000453--[[Reload Lua--]]],
		ActionId = ".Reload Lua",
		ActionIcon = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
		RolloverText = S[302535920000454--[[Fires some commands to reload lua files (use OnMsg.ReloadLua() to listen for it).--]]],
		OnAction = ChoGGi.MenuFuncs.ReloadLua,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000455--[[Object Cloner--]]],
		ActionId = ".Object Cloner",
		ActionIcon = "CommonAssets/UI/Menu/EnrichTerrainEditor.tga",
		RolloverText = S[302535920000456--[[Clones selected/moused over object to current mouse position (should probably use the shortcut key rather than this menu item).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.ObjectCloner()
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ObjectCloner,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000457--[[Anim State Set--]]],
		ActionId = ".Anim State Set",
		ActionIcon = "CommonAssets/UI/Menu/UnlockCamera.tga",
		RolloverText = S[302535920000458--[[Make object dance on command.--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.SetAnimState()
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000459--[[Anim Debug Toggle--]]],
		ActionId = ".Anim Debug Toggle",
		ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
		RolloverText = S[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]],
		OnAction = function()
			ChoGGi.CodeFuncs.ShowAnimDebug_Toggle()
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000471--[[Object Manipulator--]]],
		ActionId = ".Object Manipulator",
		ActionIcon = "CommonAssets/UI/Menu/SaveMapEntityList.tga",
		RolloverText = S[302535920000472--[[Manipulate objects (selected or under mouse cursor)--]]],
		OnAction = function()
			ChoGGi.ComFuncs.OpenInObjectManipulatorDlg()
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.OpenInObjectManipulator,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000475--[[Object Spawner--]]],
		ActionId = ".Object Spawner",
		ActionIcon = "CommonAssets/UI/Menu/add_water.tga",
		RolloverText = S[302535920000476--[["Shows list of objects, and spawns at mouse cursor.

	Warning: Unable to mouse select items after spawn
	hover mouse over and use Delete Selected Object"--]]],
		OnAction = ChoGGi.MenuFuncs.ObjectSpawner,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ObjectSpawner,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000479--[[Toggle Editor--]]],
		ActionId = ".Toggle Editor",
		ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
		RolloverText = S[302535920000480--[["Select object(s) then hold ctrl/shift/alt and drag mouse.
	click+drag for multiple selection.

	It's not as if domes need to be where you placed them (people will just ignore if you move the domes all to one place for that airy mars look)."--]]],
		OnAction = ChoGGi.CodeFuncs.Editor_Toggle,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.Editor_Toggle,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000481--[[Open In Ged Object Editor--]]],
		ActionId = ".Open In Ged Object Editor",
		ActionIcon = "CommonAssets/UI/Menu/SelectionEditor.tga",
		RolloverText = S[302535920000482--[[It edits stuff?--]]],
		OnAction = function()
			OpenGedGameObjectEditor(ChoGGi.ComFuncs.SelObject())
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000491--[[Examine Object--]]],
		ActionId = ".Examine Object",
		ActionIcon = "CommonAssets/UI/Menu/PlayerInfo.tga",
		RolloverText = S[302535920000492--[[Opens the object examiner for the selected or moused-over obj.--]]],
		OnAction = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			if obj then
				ChoGGi.ComFuncs.OpenInExamineDlg(obj)
			end
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ObjExaminer,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000495--[[Particles Reload--]]],
		ActionId = ".Particles Reload",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = S[302535920000496--[[Reloads particles from "Data/Particles"...--]]],
		OnAction = ChoGGi.MenuFuncs.ParticlesReload,
	}

	local str_Debug_Grids = "Debug.Grids"
	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = string.format("%s ..",S[302535920000035--[[Grids--]]]),
		ActionId = ".Grids",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Grids",
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_Grids,
		ActionName = S[302535920000499--[[Toggle Grid Follow Mouse--]]],
		ActionId = ".Toggle Grid Follow Mouse",
		ActionIcon = "CommonAssets/UI/Menu/ToggleWalk.tga",
		RolloverText = S[302535920000500--[[Shows a hex grid with green for buildable/walkable.--]]],
		OnAction = ChoGGi.MenuFuncs.debug_build_grid,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.debug_grid_build,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_Grids,
		ActionName = S[302535920001297--[[Toggle Flight Grid--]]],
		ActionId = ".Toggle Flight Grid",
		ActionIcon = "CommonAssets/UI/Menu/ToggleCollisions.tga",
		RolloverText = S[302535920001298--[[Shows a square grid with terrain/objects shape.--]]],
		OnAction = function()
			ChoGGi.CodeFuncs.FlightGrid_Toggle()
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.debug_grid_squares,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_Grids,
		ActionName = S[302535920000497--[[Toggle Terrain Deposit Grid--]]],
		ActionId = ".Toggle Terrain Deposit Grid",
		ActionIcon = "CommonAssets/UI/Menu/ToggleBlockPass.tga",
		RolloverText = S[302535920000498--[[Shows a grid around concrete.--]]],
		OnAction = ToggleTerrainDepositGrid,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.ToggleTerrainDepositGrid,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_Grids,
		ActionName = S[302535920000724--[[Show Grid Square--]]],
		ActionId = ".Show Grid Square",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = S[302535920000725--[[Square (use Disable to hide).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.PostProcGrids("grid")
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_Grids,
		ActionName = S[302535920001192--[[Show Grid 45 Square--]]],
		ActionId = ".Show Grid 45 Square",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = S[302535920001325--[[Square 45 (use Disable to hide).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.PostProcGrids("grid45")
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_Grids,
		ActionName = S[302535920001326--[[Show Grid Hex--]]],
		ActionId = ".Show Grid Hex",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = S[302535920001327--[[Hex (use Disable to hide).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.PostProcGrids("hexgrid")
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_Grids,
		ActionName = S[302535920001328--[[Show Grid Disable--]]],
		ActionId = ".Show Grid Disable",
		ActionIcon = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
		RolloverText = S[302535920001329--[[Hide the white ground grids.--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.PostProcGrids()
		end,
		ActionSortKey = "0.Show Grid Disable",
	}

	local str_Debug_DebugFX = "Debug.Debug FX"
	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = string.format("%s ..",S[302535920001175--[[Debug FX--]]]),
		ActionId = ".Debug FX",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Debug FX",
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_DebugFX,
		ActionName = S[302535920001175--[[Debug FX--]]],
		ActionId = ".Debug FX",
		ActionIcon = "CommonAssets/UI/Menu/FXEditor.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFX,
				302535920001176--[[Toggle showing FX debug info in console.--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFX",302535920001175)
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_DebugFX,
		ActionName = S[302535920001184--[[Particles--]]],
		ActionId = ".Particles",
		ActionIcon = "CommonAssets/UI/Menu/place_particles.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFXParticles,
				302535920001176--[[Toggle showing FX debug info in console.--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFXParticles",302535920001184)
		end,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_DebugFX,
		ActionName = S[4107--[[Sound FX--]]],
		ActionId = ".Sound FX",
		ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				DebugFXSound,
				302535920001176--[[Toggle showing FX debug info in console.--]]
			)
		end,
		OnAction = function()
			ChoGGi.MenuFuncs.DebugFX_Toggle("DebugFXSound",4107)
		end,
	}

	local str_Debug_PathMarkers = "Debug.Path Markers"
	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = string.format("%s ..",S[302535920000467--[[Path Markers--]]]),
		ActionId = ".Path Markers",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Path Markers",
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_PathMarkers,
		ActionName = string.format("%s %s",S[302535920000467--[[Path Markers--]]],S[4099--[[Game Time--]]]),
		ActionId = ".Game Time",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = string.format("%s %s",S[302535920000462--[[Maps paths in real time--]]],S[302535920000874--[[(see "Path Markers" to mark more than one at a time).--]]]),
		OnAction = function()
			ChoGGi.MenuFuncs.SetPathMarkersGameTime(nil,true)
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.SetPathMarkersGameTime,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_PathMarkers,
		ActionName = S[302535920000467--[[Path Markers--]]],
		ActionId = ".Path Markers",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = S[302535920000468--[[Shows the selected unit path or show a list to add/remove paths for rovers, drones, colonists, or shuttles.--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.SetPathMarkersVisible()
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.SetPathMarkersVisible,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000146--[[Delete Saved Games--]]],
		ActionId = ".Delete Saved Games",
		ActionIcon = "CommonAssets/UI/Menu/DeleteArea.tga",
		RolloverText = string.format("%s\n\n%s",S[302535920001273--[["Shows a list of saved games, and allows you to delete more than one at a time."--]]],S[302535920001274--[[This is permanent!--]]]),
		OnAction = ChoGGi.MenuFuncs.DeleteSavedGames,
		ActionSortKey = "98.Delete Saved Games",
	}

	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = S[302535920000487--[[Delete All Of Selected Object--]]],
		ActionId = ".Delete All Of Selected Object",
		ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
		RolloverText = S[302535920000488--[[Will ask for confirmation beforehand (will not delete domes).--]]],
		OnAction = function()
			ChoGGi.MenuFuncs.DeleteAllSelectedObjects()
		end,
		ActionSortKey = "99.Delete All Of Selected Object",
	}

	local str_Debug_DeleteObjects = "Debug.Delete Object(s)"
	c = c + 1
	Actions[c] = {
		ActionMenubar = "Debug",
		ActionName = string.format("%s ..",S[302535920000489--[[Delete Object(s)--]]]),
		ActionId = ".Delete Object(s)",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "99.Delete Object(s)",
	}
	c = c + 1
	Actions[c] = {
		ActionMenubar = str_Debug_DeleteObjects,
		ActionName = S[302535920000489--[[Delete Object(s)--]]],
		ActionId = ".Delete Object(s)",
		ActionIcon = "CommonAssets/UI/Menu/delete_objects.tga",
		RolloverText = S[302535920000490--[["Deletes selected object or object under mouse cursor (most objs, not all).

Use Editor Mode and mouse drag to select multiple objects for deletion."--]]],
		OnAction = function()
			ChoGGi.CodeFuncs.DeleteObject()
		end,
		ActionShortcut = ChoGGi.Defaults.KeyBindings.DeleteObject,
		ActionBindable = true,
		ActionSortKey = "99.Delete Object(s)",
	}

end
