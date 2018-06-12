--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local local_T = T
local T = ChoGGi.ComFuncs.Trans
local SaveOrigFunc = ChoGGi.ComFuncs.SaveOrigFunc

local type,next,tostring,rawset,rawget,assert = type,next,tostring,rawset,rawget,assert
local setmetatable,table = setmetatable,table

--probably should be careful about localizing stuff i replace below...
local AddConsoleLog = AddConsoleLog
local ApplyToObjAndAttaches = ApplyToObjAndAttaches
local AsyncRand = AsyncRand
local box = box
local ConsoleExec = ConsoleExec
local ConsolePrint = ConsolePrint
local CreateConsole = CreateConsole
local CreateRealTimeThread = CreateRealTimeThread
local CurrentThread = CurrentThread
local DeleteThread = DeleteThread
local GetActionsHost = GetActionsHost
local GetMissionSponsor = GetMissionSponsor
local IsBox = IsBox
local IsPoint = IsPoint
local IsValid = IsValid
local MulDivRound = MulDivRound
local point = point
local RGB = RGB
local RGBA = RGBA
local SetObjDust = SetObjDust
local Sleep = Sleep
local TGetID = TGetID
local WaitWakeup = WaitWakeup

local guim = guim

local UserActions_GetActiveActions = UserActions.GetActiveActions

--~ local g_Classes = g_Classes

--set UI transparency:
local function SetTrans(Obj)
  local trans = ChoGGi.UserSettings.Transparency
  if type(trans) == "table" and Obj and Obj.class and trans[Obj.class] then
    Obj:SetTransparency(trans[Obj.class])
  end
end

do
  SaveOrigFunc("OpenXDialog")
  SaveOrigFunc("ShowConsole")
  SaveOrigFunc("ShowConsoleLog")
  SaveOrigFunc("ShowPopupNotification")
  local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs

  --always able to show console
  function ShowConsole(visible)
  --~     removed from orig func:
  --~     if not Platform.developer and not ConsoleEnabled then
  --~       return
  --~     end
    if visible and not rawget(_G, "dlgConsole") then
      CreateConsole()
    end
    if rawget(_G, "dlgConsole") then
      dlgConsole:Show(visible)
    end
  end
  --convert popups to console text
  function ShowPopupNotification(preset, params, bPersistable, parent)
    --actually actually disable hints
    if ChoGGi.UserSettings.DisableHints and preset == "SuggestedBuildingConcreteExtractor" then
      return
    end

--~     if type(ChoGGi.Temp.Testing) == "function" then
--~     --if ChoGGi.UserSettings.ConvertPopups and type(preset) == "string" and not preset:find("LaunchIssue_") then
--~       if not pcall(function()
--~         local function ColourText(Text,Bool)
--~           if Bool == true then
--~             return Concat("<color 200 200 200>",Text,"</color>")
--~           else
--~             return Concat("<color 75 255 75>",Text,"</color>")
--~           end
--~         end
--~         local function ReplaceParam(Name,Text,SearchName)
--~           SearchName = SearchName or Concat("<",Name,">")
--~           if not Text:find(SearchName) then
--~             return Text
--~           end
--~           return Text:gsub(SearchName,ColourText(T(params[Name])))
--~         end
--~         --show popups in console log
--~         local presettext = DataInstances.PopupNotificationPreset[preset]
--~         --print(Concat(ColourText("Title: ",true),ColourText(T(presettext.title))))
--~         local context = _GetPopupNotificationContext(preset, params or empty_table, bPersistable)
--~         context.parent = parent
--~         if bPersistable then
--~           context.sync_popup_id = SyncPopupId
--~         else
--~           context.async_signal = {}
--~         end
--~         local text = T(presettext.text,context,true)


--~         text = ReplaceParam("number1",text)
--~         text = ReplaceParam("number2",text)
--~         text = ReplaceParam("effect",text)
--~         text = ReplaceParam("reason",text)
--~         text = ReplaceParam("hint",text)
--~         text = ReplaceParam("objective",text)
--~         text = ReplaceParam("target",text)
--~         text = ReplaceParam("timeout",text)
--~         text = ReplaceParam("count",text)
--~         text = ReplaceParam("sponsor_name",text)
--~         text = ReplaceParam("commander_name",text)

--~         --text = Concat(text:gsub("<ColonistName(colonist)>",ColourText("<ColonistName(",T(params.colonist)) ,")>"))

--~         --print(Concat(ColourText("Text: ",true),text))
--~         --print(Concat(ColourText("Voiced Text: ",true),T(presettext.voiced_text)))
--~       end) then
--~         print("<color 255 0 0>Encountered an error trying to convert popup to console msg; showing popup instead (please let me know which popup it is).</color>")
--~         return ChoGGi_OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
--~       end
--~     else
--~       return ChoGGi_OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
--~     end
    return ChoGGi_OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
  end
  --Msg("ColonistDied",UICity.labels.Colonist[1],"low health")
  --local temp = DataInstances.PopupNotificationPreset.FirstColonistDeath

 --UI transparency xdialogs (buildmenu, pins, infopanel)
  function OpenXDialog(...)
    local ret = {ChoGGi_OrigFuncs.OpenXDialog(...)}
    SetTrans(ret)
    return table.unpack(ret)
  end
  --console stuff (it's visible before mods are loaded so I can't use FrameWindow_Init)
  function ShowConsoleLog(...)
    ChoGGi_OrigFuncs.ShowConsoleLog(...)
    SetTrans(dlgConsoleLog)
  end
end
--i use ShowConsoleLog below so local it here instead of at the top
local ShowConsoleLog = ShowConsoleLog

--[[
files to check after update:

CommonLua\Classes\Sequences\SequenceAction.lua
  SA_WaitBase>SA_WaitTime:StopWait
  SA_WaitBase>SA_WaitMarsTime:StopWait
CommonLua\UI\uiUAMenu.lua
  UAMenu:SetBtns
CommonLua\UI\Controls\uiFrameWindow.lua
  FrameWindow:PostInit
  UAMenu>FrameWindow:OnMouseEnter
  UAMenu>FrameWindow:OnMouseLeft
CommonLua\UI\Dev\uiConsole.lua
  Console:Show
  Console:TextChanged
  Console:HistoryDown
  Console:HistoryUp
CommonLua\UI\Dev\uiConsoleLog.lua
  ConsoleLog:ShowBackground
CommonLua\UI\X\XDialog.lua
  OpenXDialog
CommonLua\X\XMenu.lua
  XPopupMenu:RebuildActions

Lua\Construction.lua
  ConstructionController:UpdateConstructionStatuses
  ConstructionController:CreateCursorObj
  TunnelConstructionController:UpdateConstructionStatuses
Lua\Heat.lua
  SubsurfaceHeater:UpdatElectricityConsumption
Lua\MissionGoals.lua
  MG_Colonists:GetProgress
  MG_Martianborn:GetProgress
Lua\RequiresMaintenance.lua
  RequiresMaintenance:AddDust
Lua\SupplyGrid.lua
  SupplyGridElement:SetProduction
Lua\Buildings\BaseRover.lua
  BaseRover:GetCableNearby
Lua\Buildings\BuildingComponents.lua
  BuildingVisualDustComponent:SetDustVisuals
  SingleResourceProducer:Produce
Lua\Buildings\MartianUniversity.lua
  MartianUniversity:OnTrainingCompleted
Lua\Buildings\TriboelectricScrubber.lua
  TriboelectricScrubber:OnPostChangeRange
Lua\Buildings\UIRangeBuilding.lua
  UIRangeBuilding:SetUIRange
Lua\Buildings\Workplace.lua
  Workplace:AddWorker
Lua\UI\PopupNotification.lua
  ShowPopupNotification
Lua\Units\Colonist.lua
  Colonist:ChangeComfort
Lua\X\Infopanel.lua
  InfopanelObj:CreateCheatActions
  InfopanelDlg:Open
--]]


function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesGenerate()
  SaveOrigFunc("UIRangeBuilding","SetUIRange")
  SaveOrigFunc("Workplace","AddWorker")
  SaveOrigFunc("BuildingVisualDustComponent","SetDustVisuals")
  SaveOrigFunc("BaseRover","GetCableNearby")
  local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs

  --larger trib/subsurfheater radius
  function g_Classes.UIRangeBuilding:SetUIRange(radius)
    local rad = ChoGGi.UserSettings.BuildingSettings[self.encyclopedia_id]
    if rad and rad.uirange then
      radius = rad.uirange
    end
    return ChoGGi_OrigFuncs.UIRangeBuilding_SetUIRange(self, radius)
  end

  --block certain traits from workplaces
  function g_Classes.Workplace:AddWorker(worker, shift)
    local ChoGGi = ChoGGi
    local s = ChoGGi.UserSettings.BuildingSettings[self.encyclopedia_id]
    --check that the tables contain at least one trait
    local bt = s and s.blocktraits and type(s.blocktraits) == "table" and next(s.blocktraits) and s.blocktraits
    local rt = s and s.restricttraits and type(s.restricttraits) == "table" and next(s.restricttraits) and s.restricttraits
    if bt or rt then

      local block,restrict = ChoGGi.ComFuncs.RetBuildingPermissions(worker.traits,s)
      if block then
        return
      end
      if restrict then
        self.workers[shift] = self.workers[shift] or empty_table
        self.workers[shift][#self.workers[shift]+1] = worker
        --table.insert(self.workers[shift], worker)
        self:UpdatePerformance()
        self:SetWorkplaceWorking()
        self:UpdateAttachedSigns()
      end

    else
      return ChoGGi_OrigFuncs.Workplace_AddWorker(self, worker, shift)
    end
  end

  --set amount of dust applied
  function g_Classes.BuildingVisualDustComponent:SetDustVisuals(dust, in_dome)
    if ChoGGi.UserSettings.AlwaysDustyBuildings then
      if not self.ChoGGi_AlwaysDust or self.ChoGGi_AlwaysDust < dust then
        self.ChoGGi_AlwaysDust = dust
      end
      dust = self.ChoGGi_AlwaysDust
    end

    local normalized_dust = MulDivRound(dust, 255, self.visual_max_dust)
    ApplyToObjAndAttaches(self, SetObjDust, normalized_dust, in_dome)
  end

  --change dist we can charge from cables
  function g_Classes.BaseRover:GetCableNearby(rad)
    local new_rad = ChoGGi.UserSettings.RCChargeDist
    if new_rad then
      rad = new_rad
    end
    return ChoGGi_OrigFuncs.BaseRover_GetCableNearby(self, rad)
  end

end --OnMsg

--Pre
function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesPreprocess()

  local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
  SaveOrigFunc("InfopanelObj","CreateCheatActions")
  --so we can add hints to info pane cheats
  function g_Classes.InfopanelObj:CreateCheatActions(win)
    --fire orig func to build cheats
    if ChoGGi_OrigFuncs.InfopanelObj_CreateCheatActions(self,win) then
      --then we can add some hints to the cheats
      return ChoGGi.InfoFuncs.SetInfoPanelCheatHints(GetActionsHost(win))
    end
  end

end --OnMsg

--Post
function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesPostprocess()
end --OnMsg

--Built
function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesBuilt()
  SaveOrigFunc("Colonist","ChangeComfort")
  SaveOrigFunc("Console","Exec")
  SaveOrigFunc("Console","HistoryDown")
  SaveOrigFunc("Console","HistoryUp")
  SaveOrigFunc("Console","Show")
  SaveOrigFunc("Console","TextChanged")
  SaveOrigFunc("ConsoleLog","SetVisible")
  SaveOrigFunc("ConsoleLog","ShowBackground")
  SaveOrigFunc("ConstructionController","CreateCursorObj")
  SaveOrigFunc("ConstructionController","UpdateConstructionStatuses")
  SaveOrigFunc("ConstructionController","UpdateCursor")
  SaveOrigFunc("DroneHub","SetWorkRadius")
  SaveOrigFunc("FrameWindow","Init")
  SaveOrigFunc("InfopanelDlg","Open")
  SaveOrigFunc("MartianUniversity","OnTrainingCompleted")
  SaveOrigFunc("MG_Colonists","GetProgress")
  SaveOrigFunc("MG_Martianborn","GetProgress")
  SaveOrigFunc("RCRover","SetWorkRadius")
  SaveOrigFunc("RequiresMaintenance","AddDust")
  SaveOrigFunc("SA_WaitMarsTime","StopWait")
  SaveOrigFunc("SA_WaitTime","StopWait")
  SaveOrigFunc("SingleResourceProducer","Produce")
  SaveOrigFunc("SubsurfaceHeater","UpdatElectricityConsumption")
  SaveOrigFunc("SupplyGridElement","SetProduction")
  SaveOrigFunc("TriboelectricScrubber","OnPostChangeRange")
  SaveOrigFunc("TunnelConstructionController","UpdateConstructionStatuses")
  SaveOrigFunc("UAMenu","CreateBtn")
  SaveOrigFunc("UAMenu","OnDesktopSize")
  SaveOrigFunc("UAMenu","OnMouseEnter")
  SaveOrigFunc("UAMenu","OnMouseLeft")
  SaveOrigFunc("UAMenu","SetBtns")
  SaveOrigFunc("UAMenu","ToggleOpen")
  SaveOrigFunc("XBlinkingButtonWithRMB","SetBlinking")
  SaveOrigFunc("XDesktop","MouseEvent")
  SaveOrigFunc("XMenuEntry","Open")
  SaveOrigFunc("XPopupMenu","Open")
  SaveOrigFunc("XWindow","OnMouseEnter")
  SaveOrigFunc("XWindow","OnMouseLeft")
  SaveOrigFunc("XWindow","SetId")
  local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs

  --I don't need to see the help page that much
  if Platform.editor then
    function GedOpHelpMod()end
    if ChoGGi.Temp.Testing then
      function GedOpUploadMod(socket, root)
        local mod = root[1]
        if IsValidThread(ModUploadThread) then
          socket:ShowMessage(
            T(1000592--[[Error--]]),
            T(1000011--[[There is an active Steam upload--]])
          )
          return
        end
        ModUploadThread = CreateRealTimeThread(function()
          local err, files
          if "ok" ~= socket:WaitQuestion(
            T(1000009--[[Confirmation--]]),
            T({1000012--[[Mod <ModLabel> will be uploaded to Steam--]],mod})
          ) then
            return
          end
          if Platform.steam then
            if mod.steam_id ~= 0 then
              local exists
              local appId = SteamGetAppId()
              local userId = SteamGetUserId64()
              err, exists = AsyncSteamWorkshopUserOwnsItem(userId, appId, mod.steam_id)
              if not err and not exists then
                mod.steam_id = 0
              end
            end
            if not err and mod.steam_id == 0 then
              local item_id, bShowLegalAgreement
              err, item_id, bShowLegalAgreement = AsyncSteamWorkshopCreateItem()
              if not err then
              else
              end
              mod.steam_id = item_id or nil
            end
          end
          local dest = "AppData/ModUpload/"
          if not err then
--~             mod:SaveDef()
--~             mod:SaveItems()
--~             AsyncDeletePath(dest)
--~             AsyncCreatePath(dest)
--~             err, files = AsyncListFiles(mod.path, "*", "recursive,relative")
--~             if not err then
--~               for _, file in ipairs(files or empty_table) do
--~                 local dest_file = dest .. file
--~                 local dir = SplitPath(dest_file)
--~                 AsyncCreatePath(dir)
--~                 err = AsyncCopyFile(mod.path .. file, dest_file, "raw")
--~                 if not err then
--~                 end
--~               end
--~             end
          end
          if not err then
            local os_dest = ConvertToOSPath(dest)
            if Platform.steam then
              err = AsyncSteamWorkshopUpdateItem({
                item_id = mod.steam_id,
                title = mod.title,
                description = mod.description,
                tags = mod:GetTags(),
                content_os_folder = os_dest,
                image_os_filename = mod.image ~= "" and ConvertToOSPath(mod.image) or ""
              })
            else
              err = "no steam"
            end
          end
          local msg, title
          if err then
            msg = local_T({1000013,"Mod <ModLabel> was not uploaded to Steam. Error: <err>",mod,err = Untranslated(err)})
            title = T(1000593--[[Error--]])
          else
            msg = local_T({1000014,"Mod <ModLabel> was successfully uploaded to Steam!",mod})
            title = T(1000015--[[Success--]])
          end
          ModLog(msg)
          socket:ShowMessage(title, msg)
        end)
      end
    end --testing
  end

  --UI transparency "desktop" dialogs (toolbar)
  function g_Classes.FrameWindow:Init(...)
    local ret = {ChoGGi_OrigFuncs.FrameWindow_Init(self,...)}
    SetTrans(self)
    return table.unpack(ret)
  end

  --no more pulsating pin motion
  function g_Classes.XBlinkingButtonWithRMB:SetBlinking(...)
    if ChoGGi.UserSettings.DisablePulsatingPinsMotion then
      self.blinking = false
    else
      return ChoGGi_OrigFuncs.XBlinkingButtonWithRMB_SetBlinking(self,...)
    end
  end

  --no more stuck focus on SingleLineEdits
  function g_Classes.XDesktop:MouseEvent(event, pt, button, time)
    if button == "L" and event == "OnMouseButtonDown" and self.keyboard_focus:IsKindOf("SingleLineEdit") then
      self.focus_log[#self.focus_log-1]:SetFocus()
    end
    return ChoGGi_OrigFuncs.XDesktop_MouseEvent(self, event, pt, button, time)
  end

  --make sure consolelog uses our margin whenever it's visible
  function g_Classes.ConsoleLog:SetVisible(visible)
    local ret = {ChoGGi_OrigFuncs.ConsoleLog_SetVisible(self,visible)}
    if visible then
      self:SetMargins(box(0, 0, 0, 25))
    end
    return table.unpack(ret)
  end

  --rebuild menu items for console script buttons
  function g_Classes.XPopupMenu:Open(...)
    if not self then
      return
    end

    if self.MenuEntries:find("ChoGGi_") then
      local ChoGGi = ChoGGi
      local dlgConsole = dlgConsole
      local host = self.desktop
      --clear out old items
      ChoGGi.ComFuncs.RebuildConsoleToolbar(host)

      --build list of script files
      if self.MenuEntries == "ChoGGi_Scripts" then
        g_Classes.XAction:new({
          ActionId = "ClearLog",
          ActionMenubar = "ChoGGi_Scripts",
          ActionName = T(302535920000734--[[Clear Log--]]),
          OnAction = function()
            ShowConsoleLog(true)
            dlgConsole:Exec("cls()")
          end
        }, dlgConsole)

        g_Classes.XAction:new({
          ActionId = "ChoGGi_ConsoleText",
          ActionMenubar = "ChoGGi_Scripts",
          ActionName = T(302535920000563--[[Copy Log Text--]]),
          OnAction = function()
            local dlgConsoleLog = dlgConsoleLog
            if not dlgConsoleLog then
              return
            end
            local text = dlgConsoleLog.idText:GetText()
            if text:len() == 0 then
              print(T(302535920000692--[[Log is blank.--]]))
              return
            end
            local dialog = g_Classes.ChoGGi_MultiLineText:new({}, terminal.desktop,{
              zorder = 2000001,
              wrap = true,
              text = text,
            })
            dialog:Open()

          end
        }, dlgConsole)

        g_Classes.XAction:new({
          ActionId = Concat("ChoGGi_Spacer_",AsyncRand()),
          ActionMenubar = "ChoGGi_Scripts",
          ActionName = " - "
        }, dlgConsole)

        ChoGGi.ComFuncs.ListScriptFiles(self.MenuEntries,ChoGGi.scripts,true)
      else
        local name = self.MenuEntries:gsub("ChoGGi_","")
        ChoGGi.ComFuncs.ListScriptFiles(self.MenuEntries,Concat(ChoGGi.scripts,"/",name))
      end

      --build history list menu
      if #dlgConsole.history_queue > 0 then
        local history = dlgConsole.history_queue
        for i = 1, #history do
          --these can get long so keep 'em short
          local name = tostring(history[i]):sub(1,ChoGGi.UserSettings.ConsoleHistoryMenuLength or 50)
          g_Classes.XAction:new({
            ActionId = name,
            ActionMenubar = "ChoGGi_History",
            ActionName = name,
            OnAction = function()
              ShowConsoleLog(true)
              dlgConsole:Exec(history[i])
            end
          }, dlgConsole)
        end
      end

      --make the menu start above the button
      self:SetMargins(box(3, 0, 0, 68))
      -- 1 above consolelog
      self:SetZOrder(2000001)
    end

    return ChoGGi_OrigFuncs.XPopupMenu_Open(self, ...)
  end

  --larger and blacker font for Scripts menu items
  function g_Classes.XMenuEntry:Open(...)
    ChoGGi_OrigFuncs.XMenuEntry_Open(self,...)
    if self.parent.parent.MenuEntries:find("ChoGGi_") then
      self:SetTextFont("Editor16Bold")
      self:SetTextColor(RGB(0,0,0))
    end
  end

  --function from github as the actual function has an inf loop (whoopsie)
  if ChoGGi.UserSettings.RoverInfiniteLoopCuriosity then
    function g_Classes.RCRover:ExitAllDrones()
      if self.exit_drones_thread and self.exit_drones_thread ~= CurrentThread() then
        DeleteThread(self.exit_drones_thread)
        self.exit_drones_thread = CurrentThread()
      end

      while #self.attached_drones > 0 and self.siege_state_name == "Siege" do
        local drone = self.attached_drones[#self.attached_drones]
        if IsValid(drone) then
          if drone.command_center ~= self then
            --damage control, this should never happen
            assert(false, "Rover has foreign drones attached")
            drone:Detach()
            assert(drone == table.remove(self.attached_drones))
          else
            while self.guided_drone or #self.embarking_drones > 0 do
              Sleep(1000)
            end
            if IsValid(drone) then
              self.guided_drone = drone
              drone:SetCommand("ExitRover", self)
              while not WaitWakeup(10000) do end
            end
          end
        end
      end

      if self.exit_drones_thread and self.exit_drones_thread == CurrentThread() then
        self.exit_drones_thread = false
      end
    end
  end

  --remove annoying msg that happens everytime you click anything (nice)
  function g_Classes.XWindow:SetId(id)
    local node = self.parent
    while node and not node.IdNode do
      node = node.parent
    end
    if node then
      local old_id = self.Id
      if old_id ~= "" then
        rawset(node, old_id, nil)
      end
      if id ~= "" then
        --local win = rawget(node, id)
        --if win and win ~= self then
        --  printf("[UI WARNING] Assigning window id '%s' of %s to %s", tostring(id), win.class, self.class)
        --end
        rawset(node, id, self)
      end
    end
    self.Id = id
  end

  --limit width of cheats menu till hover
  local UAMenu_cheats_width = 520
  if ChoGGi.UserSettings.ToggleWidthOfCheatsHover then
    UAMenu_cheats_width = 80
    local thread
    function g_Classes.UAMenu:OnMouseEnter(...)
      ChoGGi_OrigFuncs.UAMenu_OnMouseEnter(self,...)
      DeleteThread(thread)
      self:SetSize(point(520,self:GetSize():y()))
    end
    function g_Classes.UAMenu:OnMouseLeft(...)
      ChoGGi_OrigFuncs.UAMenu_OnMouseLeft(self,...)
      thread = CreateRealTimeThread(function()
        Sleep(2500)
      self:SetSize(point(80,self:GetSize():y()))
      end)
    end
  end

  local menuButtons_selected_color = RGB(153, 204, 255)
  local menuButtons_rollover_color = RGB(0, 0, 0)

  --make the buttons open their menus where the menu is, not at the top left
  function g_Classes.UAMenu:CreateBtn(text, path)
    local entry = ChoGGi_OrigFuncs.UAMenu_CreateBtn(self, text, path)
    entry:SetFontStyle("Editor14Bold")
    --higher than the "Move" element
    entry:SetZOrder(9)

    function entry.OnLButtonDown()
      local p = entry:GetPos()
      local pos = point(p:x(), p:y() + entry:GetSize():y() + 1)
      if self.MenuOpen == text then
        self:CloseMenu()
      else
        self:CloseMenu()
        self.MenuOpen = text
        entry:SetTextColor(menuButtons_rollover_color)
        entry:SetBackgroundColor(menuButtons_selected_color)
        self.current_pos = pos
        self:SetMenuPath(path)
      end
      return "break"
    end

    function entry.OnMouseEnter()
      local p = entry:GetPos()
      local pos = point(p:x(), p:y() + entry:GetSize():y() + 1)
      if self.MenuOpen then
        self:CloseMenu()
        self.MenuOpen = text
        entry:SetTextColor(menuButtons_rollover_color)
        entry:SetBackgroundColor(menuButtons_selected_color)
        self.current_pos = pos
        self:SetMenuPath(path)
      else
        entry:SetTextColor(menuButtons_rollover_color)
      end
    end

    return entry
  end

  --default menu width/draggable menu
  function g_Classes.UAMenu:SetBtns()
    local ret = {ChoGGi_OrigFuncs.UAMenu_SetBtns(self)}
    --shrink the width
    self:SetSize(point(UAMenu_cheats_width,self:GetSize():y()))
    --make the menu draggable
    if ChoGGi.UserSettings.DraggableCheatsMenu then
      self:SetMovable(true)
    end
    return table.unpack(ret)
  end --func

  --set menu position
--~   function g_Classes.UAMenu.ToggleOpen()
  function g_Classes.UAMenu.ToggleOpen()
    local UserSettings = ChoGGi.UserSettings

    if dlgUAMenu then
      if UserSettings.KeepCheatsMenuPosition then
        UserSettings.KeepCheatsMenuPosition = dlgUAMenu:GetPos()
      end
      g_Classes.UAMenu.CloseUAMenu()
    else
      dlgUAMenu = g_Classes.UAMenu:new(terminal.desktop)
      g_Classes.UAMenu.UpdateUAMenu(UserActions_GetActiveActions())
      if IsPoint(UserSettings.KeepCheatsMenuPosition) then
        dlgUAMenu:SetPos(UserSettings.KeepCheatsMenuPosition)
      end
    end
  end

  --keep buttons/pos of menu when alt-tabbing
  function g_Classes.UAMenu:OnDesktopSize()

    local ret = {ChoGGi_OrigFuncs.UAMenu_OnDesktopSize(self)}

    if ChoGGi.UserSettings.DraggableCheatsMenu then
      local dlgUAMenu = dlgUAMenu
      local pos = type(self.GetPos) == "function" and self.GetPos(self)
      --if opened then toggle close and open to restore the menu items (not sure why alt-tabbing removes them when i make it movable...)
      if dlgUAMenu then
        self.ToggleOpen(dlgUAMenu)
        self.ToggleOpen(dlgUAMenu)
      end
      --and restore pos
      if pos then
        dlgUAMenu:SetPos(pos)
      end

      --convenience: if console is visible then focus on it
      if dlgConsole.visible then
        dlgConsole.idEdit:SetFocus()
      end
    end

    return table.unpack(ret)
  end

  --removes earthsick effect
  function g_Classes.Colonist:ChangeComfort(amount, reason)
    ChoGGi_OrigFuncs.Colonist_ChangeComfort(self, amount, reason)
    if ChoGGi.UserSettings.NoMoreEarthsick and self.status_effects.StatusEffect_Earthsick then
      self:Affect("StatusEffect_Earthsick", false)
    end
  end

  --make sure heater keeps the powerless setting
  function g_Classes.SubsurfaceHeater:UpdatElectricityConsumption()
    ChoGGi_OrigFuncs.SubsurfaceHeater_UpdatElectricityConsumption(self)
    if self.ChoGGi_mod_electricity_consumption then
      ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
    end
  end
  --same for tribby
  function g_Classes.TriboelectricScrubber:OnPostChangeRange()
    ChoGGi_OrigFuncs.TriboelectricScrubber_OnPostChangeRange(self)
    if self.ChoGGi_mod_electricity_consumption then
      ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
    end
  end

  --remove idiot trait from uni grads (hah!)
  function g_Classes.MartianUniversity:OnTrainingCompleted(unit)
    if ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait then
      unit:RemoveTrait("Idiot")
    end
    ChoGGi_OrigFuncs.MartianUniversity_OnTrainingCompleted(self, unit)
  end

  --used to skip mystery sequences
  local function SkipMystStep(self,MystFunc)
    local ChoGGi = ChoGGi
    local StopWait = ChoGGi.Temp.SA_WaitMarsTime_StopWait
    local p = self.meta.player

    if StopWait and p and StopWait.seed == p.seed then
      --inform user, or if it's a dbl then skip
      if StopWait.skipmsg then
        StopWait.skipmsg = nil
      else
        ChoGGi.ComFuncs.MsgPopup(T(302535920000735--[[Timer delay skipped--]]),T(3486--[[Mystery--]]))
      end

      --only set on first SA_WaitExpression, as there's always a SA_WaitMarsTime after it and if we're skipping then skip...
      if StopWait.again == true then
        StopWait.again = nil
        StopWait.skipmsg = true
      else
        --reset it for next time
        StopWait.seed = false
        StopWait.again = false
      end

      --skip
      return 1
    end

    return ChoGGi_OrigFuncs[MystFunc](self)
  end

  function g_Classes.SA_WaitTime:StopWait()
    SkipMystStep(self,"SA_WaitTime_StopWait")
  end
  function g_Classes.SA_WaitMarsTime:StopWait()
    SkipMystStep(self,"SA_WaitMarsTime_StopWait")
  end

  --some mission goals check colonist amounts
  local MG_target = GetMissionSponsor().goal_target + 1
  function g_Classes.MG_Colonists:GetProgress()
    if ChoGGi.Temp.InstantMissionGoal then
      return MG_target
    else
      return ChoGGi_OrigFuncs.MG_Colonists_GetProgress(self)
    end
  end
  function g_Classes.MG_Martianborn:GetProgress()
    if ChoGGi.Temp.InstantMissionGoal then
      return MG_target
    else
      return ChoGGi_OrigFuncs.MG_Martianborn_GetProgress(self)
    end
  end

  --keep prod at saved values for grid producers (air/water/elec)
  function g_Classes.SupplyGridElement:SetProduction(new_production, new_throttled_production, update)
    local amount = ChoGGi.UserSettings.BuildingSettings[self.building.encyclopedia_id]
    if amount and amount.production then
      --set prod
      new_production = self.building.working and amount.production or 0
      --set displayed prod
      if self:IsKindOf("AirGridFragment") then
        self.building.air_production = self.building.working and amount.production or 0
      elseif self:IsKindOf("WaterGrid") then
        self.building.water_production = self.building.working and amount.production or 0
      elseif self:IsKindOf("ElectricityGrid") then
        self.building.electricity_production = self.building.working and amount.production or 0
      end
    end
    ChoGGi_OrigFuncs.SupplyGridElement_SetProduction(self, new_production, new_throttled_production, update)
  end

  --and for regular producers (factories/extractors)
  function g_Classes.SingleResourceProducer:Produce(amount_to_produce)
    local amount = ChoGGi.UserSettings.BuildingSettings[self.parent.encyclopedia_id]
    if amount and amount.production then
      --set prod
      amount_to_produce = amount.production / guim
      --set displayed prod
      self.production_per_day = amount.production
    end

--~ function SingleResourceProducer:DroneUnloadResource(drone, request, resource, amount)
--~   if resource == self.resource_produced and self.parent and self.parent ~= self then
--~     self.parent:DroneUnloadResource(drone, request, resource, amount)
--~   end
--~ end
    --get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
    if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
      ChoGGi.CodeFuncs.FuckingDrones(self)
    end

    return ChoGGi_OrigFuncs.SingleResourceProducer_Produce(self, amount_to_produce)
  end

  --larger drone work radius
  local function SetHexRadius(OrigFunc,Setting,Obj,OrigRadius)
    local set = ChoGGi.UserSettings[Setting]
    if set then
      return ChoGGi_OrigFuncs[OrigFunc](Obj,set)
    end
    return ChoGGi_OrigFuncs[OrigFunc](Obj,OrigRadius)
  end
  function g_Classes.RCRover:SetWorkRadius(radius)
    SetHexRadius("RCRover_SetWorkRadius","RCRoverMaxRadius",self,radius)
  end
  function g_Classes.DroneHub:SetWorkRadius(radius)
    SetHexRadius("DroneHub_SetWorkRadius","CommandCenterMaxRadius",self,radius)
  end

  --toggle trans on mouseover
  function g_Classes.XWindow:OnMouseEnter(pt, child)
    local ret = {ChoGGi_OrigFuncs.XWindow_OnMouseEnter(self, pt, child)}
    if ChoGGi.UserSettings.TransparencyToggle then
      self:SetTransparency(0)
    end
    return table.unpack(ret)
  end
  function g_Classes.XWindow:OnMouseLeft(pt, child)
    local ret = {ChoGGi_OrigFuncs.XWindow_OnMouseLeft(self, pt, child)}
    if ChoGGi.UserSettings.TransparencyToggle then
      SetTrans(self)
    end
    return table.unpack(ret)
  end

  --remove spire spot limit, and other limits on placing buildings
  function g_Classes.ConstructionController:UpdateCursor(pos, force)
    local UserSettings = ChoGGi.UserSettings
    local function SetDefault(Name)
      self.template_obj[Name] = self.template_obj:GetDefaultPropertyValue(Name)
    end
    local force_override

    if UserSettings.Building_instant_build then
      --instant_build on domes = missing textures on domes
      if self.template_obj.achievement ~= "FirstDome" then
        self.template_obj.instant_build = true
      end
    else
      SetDefault("instant_build")
      --self.template_obj.instant_build = self.template_obj:GetDefaultPropertyValue("instant_build")
    end

    if UserSettings.Building_dome_spot then
      self.template_obj.dome_spot = "none"
      --force_override = true
    else
      SetDefault("dome_spot")
    end

    if UserSettings.RemoveBuildingLimits then
      self.template_obj.dome_required = false
      self.template_obj.dome_forbidden = false
      force_override = true
    else
      SetDefault("dome_required")
      SetDefault("dome_forbidden")
    end

    if force_override then
      return ChoGGi_OrigFuncs.ConstructionController_UpdateCursor(self, pos, false)
    else
      return ChoGGi_OrigFuncs.ConstructionController_UpdateCursor(self, pos, force)
    end

  end

  --add height limits to certain panels (cheats/traits/colonists) till mouseover, and convert workers to vertical list on mouseover if over 14 (visible limit)
  --ex(GetInGameInterface()[6][2])
  -- list control GetInGameInterface()[6][2][3][2]:SetMaxHeight(165)
  function g_Classes.InfopanelDlg:Open(...)
    --fire the orig func so we can edit the dialog (and keep it's return value to pass on later)
    local ret = {ChoGGi_OrigFuncs.InfopanelDlg_Open(self,...)}
    CreateRealTimeThread(function()
      local c = self.idContent

      --see about adding age to colonist info
if type(ChoGGi.Temp.Testing) == "function" then
      if self.context and self.context.class == "Colonist" then
        local con = c[2].idContent
        --con[#con+1] = g_Classes.XText:new()
        con = con[#con]
        --con.text = Concat(con.text,"age: ")
        --ex(con)
      end
end

      --probably don't need this...
      if c then
        --this limits height of traits you can choose to 3 till mouse over
        --7422="Select A Trait"
        if #c > 19 and c[18].idSectionTitle and TGetID(c[18].idSectionTitle.Text) == 7422 then
          --sanitarium
          local idx = 18
          --school
          if TGetID(c[20].idSectionTitle.Text) == 7422 then
            idx = 20
          end
          local function ToggleVis(v,h)
            for i = 6, idx do
              c[i]:SetVisible(v)
              c[i]:SetMaxHeight(h)
            end
          end
          --init set to hidden
          ToggleVis(false,0)
          local visthread

          self.OnMouseEnter = function()
            DeleteThread(visthread)
            ToggleVis(true)
          end
          self.OnMouseLeft = function()
            visthread = CreateRealTimeThread(function()
              Sleep(1000)
              ToggleVis(false,0)
            end)
          end

        end

        --loop all the sections
        for i = 1, #c do
          local section = c[i]
          if section.class == "XSection" then
            local title = section.idSectionTitle.Text
            local content = section.idContent[2]
            --if section.idWorkers and #section.idWorkers > 14 and title == "" then
            if section.idWorkers and #section.idWorkers > 14 then
              --sets height
              content:SetMaxHeight(32)
              local expandthread

              section.OnMouseEnter = function()
                DeleteThread(expandthread)
                content:SetLayoutMethod("HWrap")
                content:SetMaxHeight()
              end
              section.OnMouseLeft = function()
                expandthread = CreateRealTimeThread(function()
                  Sleep(500)
                  content:SetLayoutMethod("HList")
                  content:SetMaxHeight(32)
                end)
              end

            --Cheats
            elseif TGetID(title) == 27 then
              --hides overflow
              content:SetClip(true)
              --sets height
              content:SetMaxHeight(0)
              local expandthread

              section.OnMouseEnter = function()
                DeleteThread(expandthread)
                content:SetMaxHeight()
              end
              section.OnMouseLeft = function()
                expandthread = CreateRealTimeThread(function()
                  Sleep(ChoGGi.UserSettings.CheatsInfoPanelHideDelay or 1500)
                  content:SetMaxHeight(0)
                end)
              end

--~             235=Traits
--~             702480492408=Residents
--~             TranslationTable[27]
            elseif TGetID(title) == 235 or TGetID(title) == 702480492408 then

              --hides overflow
              content:SetClip(true)
              --sets height
              content:SetMaxHeight(256)
              local expandthread

              section.OnMouseEnter = function()
                DeleteThread(expandthread)
                content:SetMaxHeight()
              end
              section.OnMouseLeft = function()
                expandthread = CreateRealTimeThread(function()
                  Sleep(500)
                  content:SetMaxHeight(256)
                end)
              end
            end

          end --if XSection
        end
      end
    end)

    return table.unpack(ret)
  end

  --make the background hide when console not visible (instead of after a second or two)
  function g_Classes.ConsoleLog:ShowBackground(visible, immediate)
    if config.ConsoleDim ~= 0 then
      DeleteThread(self.background_thread)
      if visible or immediate then
        self:SetBackground(RGBA(0, 0, 0, visible and 96 or 0))
      else
        self:SetBackground(RGBA(0, 0, 0, 0))
      end
    end
  end

  --make sure console is focused even when construction is opened
  function g_Classes.Console:Show(show)
    ChoGGi_OrigFuncs.Console_Show(self, show)
    local was_visible = self:GetVisible()
    if show and not was_visible then
      --always on top
      self:SetModal()
    end
    if not show then
      --always on top off
      self:SetModal(false)
    end
    --adding transparency for console stuff (it's always visible so I can't use FrameWindow_PostInit)
    SetTrans(self)
  end

  --kind of an ugly way of making sure console doesn't include ` when using tilde to open console
  function g_Classes.Console:TextChanged()
    ChoGGi_OrigFuncs.Console_TextChanged(self)
    if self.idEdit:GetText() == "`" then
      self.idEdit:SetText("")
    end
  end

  --make it so caret is at the end of the text when you use history
  function g_Classes.Console:HistoryDown()
    ChoGGi_OrigFuncs.Console_HistoryDown(self)
    self.idEdit:SetCursorPos(#self.idEdit:GetText())
  end
  function g_Classes.Console:HistoryUp()
    ChoGGi_OrigFuncs.Console_HistoryUp(self)
    self.idEdit:SetCursorPos(#self.idEdit:GetText())
  end

  --was giving a nil error in log, I assume devs'll fix it one day
  function g_Classes.RequiresMaintenance:AddDust(amount)
    --this wasn't checking if it was a number/point/box so errors in log, now it checks
    if type(amount) == "number" or IsPoint(amount) or IsBox(amount) then
      if self:IsKindOf("Building") then
        amount = MulDivRound(amount, g_Consts.BuildingDustModifier, 100)
      end
      if self.accumulate_dust then
        self:AccumulateMaintenancePoints(amount)
      end
    end
  end

  --set orientation to same as last object
  function g_Classes.ConstructionController:CreateCursorObj(alternative_entity, template_obj, override_palette)
    local ChoGGi = ChoGGi
    local ret = {ChoGGi_OrigFuncs.ConstructionController_CreateCursorObj(self, alternative_entity, template_obj, override_palette)}

    local last = ChoGGi.Temp.LastPlacedObject
    if last and ChoGGi.UserSettings.UseLastOrientation then
      --shouldn't fail anymore, but we'll still pcall
      pcall(function()
        local angle = type(last.GetAngle) == "function" and last:GetAngle()
        if angle and type(ret[1].SetAngle) == "function" then
          ret[1]:SetAngle(angle)
        end
      end)
    end

    return table.unpack(ret)
  end


  --so we can build without (as many) limits
  function g_Classes.ConstructionController:UpdateConstructionStatuses(dont_finalize)
    if ChoGGi.UserSettings.RemoveBuildingLimits then
      --send "dont_finalize" so it comes back here without doing FinalizeStatusGathering
      ChoGGi_OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,"dont_finalize")

      local status = self.construction_statuses

      if self.is_template then
        local cobj = rawget(self.cursor_obj, true)
        local tobj = setmetatable({
          [true] = cobj,
          ["city"] = UICity
        }, {
          __index = self.template_obj
        })
        tobj:GatherConstructionStatuses(self.construction_statuses)
      end

      --remove errors we want to remove
      local statusNew = {}
      local ConstructionStatus = ConstructionStatus
      if type(status) == "table" and next(status) then
        for i = 1, #status do
          if status[i].type == "warning" then
            statusNew[#statusNew+1] = status[i]
          --UnevenTerrain < causes issues when placing buildings (martian ground viagra)
          --ResourceRequired < no point in building an extractor when there's nothing to extract
          --BlockingObjects < place buildings in each other
--NoPlaceForSpire
--PassageTooCloseToLifeSupport
          --PassageAngleToSteep might be needed?
          elseif status[i] == ConstructionStatus.UnevenTerrain then
            statusNew[#statusNew+1] = status[i]
          --probably good to have, but might be fun if it doesn't fuck up?
          elseif status[i] == ConstructionStatus.PassageRequiresDifferentDomes then
            statusNew[#statusNew+1] = status[i]
          end
        end
      end
      --make sure we don't get errors down the line
      if type(statusNew) == "boolean" then
        statusNew = {}
      end

      self.construction_statuses = statusNew
      status = self.construction_statuses

      if not dont_finalize then
        self:FinalizeStatusGathering(status)
      else
        return status
      end
    else
      return ChoGGi_OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,dont_finalize)
    end
  end --ConstructionController:UpdateConstructionStatuses

  --so we can do long spaced tunnels
  function g_Classes.TunnelConstructionController:UpdateConstructionStatuses()
    if ChoGGi.UserSettings.RemoveBuildingLimits then
      local old_t = g_Classes.ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
      self:FinalizeStatusGathering(old_t)
    else
      return ChoGGi_OrigFuncs.TunnelConstructionController_UpdateConstructionStatuses(self)
    end
  end

  --add a bunch of rules to console input
  local ConsoleRules = {
    --print info in log
    {
      "^$(.*)",
      "print(T(%s))"
    },
    {
      "^@(.*)",
      "print(debug.getinfo(%s))"
    },
    {
      "^@@(.*)",
      "print(type(%s))"
    },
    --do something
    {
      "^!(.*)",
      "ChoGGi.CodeFuncs.ViewAndSelectObject(%s)"
    },
    {
      "^~(.*)",
      "OpenExamine(%s)"
    },
    {
      "^!!(.*)",
      "local o = (%s) local attaches = type(o) == 'table' and type(o.GetAttaches) == 'function' and o:GetAttaches() if attaches and #attaches > 0 then OpenExamine(attaches,true) end"
    },
    --built-in
    {
      "^*r%s*(.*)",
      "CreateRealTimeThread(function() %s end) return"
    },
    {
      "^*g%s*(.*)",
      "CreateGameTimeThread(function() %s end) return"
    },
    {
      "^(%a[%w.]*)$",
      "ConsolePrint(print_format(__run(%s)))"
    },
    {
      "(.*)",
      "ConsolePrint(print_format(%s))"
    },

    {"(.*)", "%s"}
  }
  function g_Classes.Console:Exec(text)
    self:AddHistory(text)
    AddConsoleLog("> ", true)
    AddConsoleLog(text, false)
    local err = ConsoleExec(text, ConsoleRules)
    if err then
      ConsolePrint(err)
    end
  end

end --OnMsg
