function ChoGGi.MsgFuncs.MiscMenu_LoadingScreenPreClose()
  --ChoGGi.Funcs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Auto Unpin Objects",
    ChoGGi.MenuFuncs.ShowAutoUnpinObjectList,
    nil,
    "Will automagically stop any of these objects from being added to the pinned list.",
    "CutSceneArea.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Clean All Objects",
    ChoGGi.MenuFuncs.CleanAllObjects,
    nil,
    "Removes all dust from all objects.",
    "DisableAOMaps.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Fix All Objects",
    ChoGGi.MenuFuncs.FixAllObjects,
    nil,
    "Fixes all broken objects.",
    "DisableAOMaps.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Change Colour",
    ChoGGi.MenuFuncs.CreateObjectListAndAttaches,
    "F6",
    "Select/mouse over an object to change the colours.",
    "toggle_dtm_slots.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Set Opacity",
    ChoGGi.MenuFuncs.SetObjectOpacity,
    "F3",
    "Change the opacity of objects.",
    "set_last_texture.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Set UI Transparency",
    ChoGGi.MenuFuncs.SetTransparencyUI,
    "Shift-F3",
    "Change the transparency of UI items.",
    "set_last_texture.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Set UI Transparency Mouseover",
    ChoGGi.MenuFuncs.TransparencyUI_Toggle,
    nil,
    "Toggle removing transparency on mouseover.",
    "set_last_texture.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Shadow Map",
    ChoGGi.MenuFuncs.SetShadowmapSize,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.ShadowmapSize)
      return des .. "\nSets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096."
    end,
    "DisableEyeSpec.tga"
  )

  --------------------
  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Disable Texture Compression",
    ChoGGi.MenuFuncs.DisableTextureCompression_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableTextureCompression and "(Enabled)" or "(Disabled)"
      return des .. " Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram)."
    end,
    "ExportImageSequence.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Higher Render Distance",
    ChoGGi.MenuFuncs.HigherRenderDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherRenderDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders model from further away.\nNot noticeable unless using higher zoom."
    end,
    "CameraEditor.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[2]Render/Higher Shadow Distance",
    ChoGGi.MenuFuncs.HigherShadowDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherShadowDist and "(Enabled)" or "(Disabled)"
      return des .. " Renders shadows from further away.\nNot noticeable unless using higher zoom."
    end,
    "toggle_post.tga"
  )


  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Free Camera",
    ChoGGi.MenuFuncs.CameraFree_Toggle,
    "Shift-C",
    "I believe I can fly.",
    "NewCamera.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Follow Camera",
    ChoGGi.MenuFuncs.CameraFollow_Toggle,
    "Ctrl-Shift-F",
    "Select (or mouse over) an object to follow.",
    "Shot.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Toggle Cursor",
    ChoGGi.MenuFuncs.CursorVisible_Toggle,
    "Ctrl-Alt-F",
    "Toggle between moving camera and selecting objects.",
    "select_objects.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Border Scrolling",
    ChoGGi.MenuFuncs.SetBorderScrolling,
    nil,
    function()
      local des = ChoGGi.UserSettings.BorderScrollingToggle and "(Enabled)" or "(Disabled)"
      return des .. " Set size of activation for mouse border scrolling."
    end,
    "CameraToggle.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[1]Camera/Zoom Distance",
    ChoGGi.MenuFuncs.CameraZoom_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CameraZoomToggle and "(Enabled)" or "(Disabled)"
      return des .. " Further zoom distance."
    end,
    "MoveUpCamera.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[-1]Infopanel Cheats",
    ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
    nil,
    function()
      local des = config.BuildingInfopanelCheats and "(Enabled)" or "(Disabled)"
      return des .. " Show the cheat pane in the info panel."
    end,
    "toggle_dtm_slots.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/[-1]Infopanel Cheats Cleanup",
    ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CleanupCheatsInfoPane and "(Enabled)" or "(Disabled)"
      return des .. " Remove some entries from the cheat pane (restart to re-enable).\n\nAddMaintenancePnts,MakeSphereTarget,Malfunction,SpawnWorker,SpawnVisitor"
    end,
    "toggle_dtm_slots.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Scanner Queue Larger",
    ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle,
    nil,
    function()
      local des = ""
      if const.ExplorationQueueMaxSize == 100 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Queue up to 100 squares (default " .. ChoGGi.Consts.ExplorationQueueMaxSize .. ")."
    end,
    "ViewArea.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/[999]Misc/Game Speed",
    ChoGGi.MenuFuncs.SetGameSpeed,
    nil,
    "Change the game speed (only for medium/fast, normal is normal).",
    "SelectionToTemplates.tga"
  )

end
