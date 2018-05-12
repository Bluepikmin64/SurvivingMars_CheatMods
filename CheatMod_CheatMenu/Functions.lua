--[[
Surviving Mars comes with
print(lfs._VERSION) LuaFileSystem 1.2 (which is weird as lfs 1.6.3 is the one with lua 5.3 support)
though SM has a bunch of AsyncFile* functions that should probably be used instead (as you can use AppData with them to specify the profile folder)
lpeg v0.10


socket = require("socket")
print(socket._VERSION)
--]]

function ChoGGi.Funcs.MsgPopup(Msg,Title,Icon,Size)
  pcall(function()
    --returns translated text corresponding to number if we don't do tostring for numbers
    Msg = tostring(Msg)
    Title = Title or "Placeholder"
    Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
    local id = "ChoGGi_" .. AsyncRand()
    local timeout = 8000
    if Size then
      timeout = 15000
    end
    if type(AddCustomOnScreenNotification) == "function" then --if we called it where there ain't no UI
      CreateRealTimeThread(function()
        AddCustomOnScreenNotification(
          id,Title,Msg,Icon,nil,{expiration=timeout}
          --id,Title,Msg,Icon,nil,{expiration=99999999999999999}
        )
        --since I use AsyncRand for the id, I don't want this getting too large.
        g_ShownOnScreenNotifications[id] = nil
        --large amount of text option
        if Size then
          --add some custom settings this way, till i figure out hwo to add them as params
          local osDlg = GetXDialog("OnScreenNotificationsDlg")[1]
          local popup
          for i = 1, #osDlg do
            if osDlg[i].notification_id == id then
              popup = osDlg[i]
              break
            end
          end
          --remove text limit
          --popup.idText.Shorten = false
          --popup.idText.MaxHeight = nil
          popup.idText.Margins = box(0,0,0,-500)
          --resize
          popup.idTitle.Margins = box(0,-20,0,0)
          --image
          Sleep(0)
          popup[1].scale = point(2800,2500)
          popup[1].Margins = box(-5,-30,0,-5)
          --update dialog
          popup:InvalidateMeasure()
  --parent ex(GetXDialog("OnScreenNotificationsDlg")[1])
  --osn GetXDialog("OnScreenNotificationsDlg")[1][1]
        end
      end)
    end
  end)
end


function ChoGGi.Funcs.Dump(Obj,Mode,File,Ext,Skip)
  if Mode == "w" or Mode == "w+" then
    Mode = nil
  else
    Mode = "-1"
  end
  Ext = Ext or "txt"
  File = File or "DumpedText"
  local Filename = "AppData/logs/" .. File .. "." .. Ext

  if pcall(function()
    ThreadLockKey(Filename)
    AsyncStringToFile(Filename,Obj,Mode)
    ThreadUnlockKey(Filename)
  end) then
    if not Skip then
      ChoGGi.Funcs.MsgPopup("Dumped: " .. tostring(Obj),
        Filename,"UI/Icons/Upgrades/magnetic_filtering_04.tga"
      )
    end
  end
end

function ChoGGi.Funcs.DumpLua(Value)
  local which = "TupleToLuaCode"
  if type(Value) == "table" then
    which = "TableToLuaCode"
  elseif type(Value) == "string" then
    which = "StringToLuaCode"
  elseif type(Value) == "userdata" then
    which = "ValueToLuaCode"
  end
  ChoGGi.Funcs.Dump("\r\n" .. _G[which](Value),nil,"DumpedLua","lua")
end

--[[
Mode = -1 to append or nil to overwrite (default: -1)
Funcs = true to dump functions as well (default: false)
ChoGGi.Funcs.DumpTable(TechTree)
--]]
function ChoGGi.Funcs.DumpTable(Obj,Mode,Funcs)
  if not Obj then
    ChoGGi.Funcs.MsgPopup("Can't dump nothing",
      "Dump","UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
    return
  end
  Mode = Mode or "-1"
  --make sure it's empty
  ChoGGi.TextFile = ""
  ChoGGi.Funcs.DumpTableFunc(Obj,nil,Funcs)
  AsyncStringToFile("AppData/logs/DumpedTable.txt",ChoGGi.TextFile,Mode)

  ChoGGi.Funcs.MsgPopup("Dumped: " .. tostring(Obj),
    "AppData/logs/DumpedText.txt","UI/Icons/Upgrades/magnetic_filtering_04.tga"
  )
end

function ChoGGi.Funcs.DumpTableFunc(Obj,hierarchyLevel,Funcs)
  if (hierarchyLevel == nil) then
    hierarchyLevel = 0
  elseif (hierarchyLevel == 4) then
    return 0
  end

  if Obj.id then
    ChoGGi.TextFile = ChoGGi.TextFile .. "\n-----------------Obj.id: " .. Obj.id .. " :"
    --ChoGGi.TextFile:write()
  end
  if (type(Obj) == "table") then
    for k,v in pairs(Obj) do
      if (type(v) == "table") then
        ChoGGi.Funcs.DumpTableFunc(v, hierarchyLevel+1)
      else
        if k ~= nil then
          ChoGGi.TextFile = ChoGGi.TextFile .. "\n" .. tostring(k) .. " = "
          --ChoGGi.TextFile:write("\n" .. tostring(k) .. " = ")
        end
--make it add the table index #
--Value: table: 0000000005FD3470
        if v ~= nil then
          ChoGGi.TextFile = ChoGGi.TextFile .. tostring(ChoGGi.Funcs.RetTextForDump(v,Funcs))
          --ChoGGi.TextFile:write(tostring(ChoGGi.Funcs.RetTextForDump(v,Funcs)))
        end
        ChoGGi.TextFile = ChoGGi.TextFile .. "\n"
        --ChoGGi.TextFile:write("\n")
      end
    end
  end
end

--[[
ChoGGi.Funcs.DumpObject(Consts)
ChoGGi.Funcs.DumpObject(const)
if you want to dump functions as well DumpObject(object,true)
--]]
function ChoGGi.Funcs.DumpObject(Obj,Mode,Funcs)
  if not Obj then
    ChoGGi.Funcs.MsgPopup("Can't dump nothing",
      "Dump","UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
    return
  end

  local Text = ""
  for k,v in pairs(Obj) do
    if k ~= nil then
      Text = Text .. "\n" .. tostring(k) .. " = "
    end
    if v ~= nil then
      Text = Text .. tostring(ChoGGi.Funcs.RetTextForDump(v,Funcs))
    end
    --Text = Text .. "\n"
  end
  ChoGGi.Funcs.Dump(Text,Mode)
end

function ChoGGi.Funcs.RetTextForDump(Obj,Funcs)
  if type(Obj) == "userdata" then
    return function()
      _InternalTranslate(Obj)
    end
  elseif Funcs and type(Obj) == "function" then
    return "Func: \n\n" .. string.dump(Obj) .. "\n\n"
  elseif type(Obj) == "table" then
    return tostring(Obj) .. " len: " .. #Obj
  else
    return tostring(Obj)
  end
end

function ChoGGi.Funcs.PrintFiles(Filename,Function,Text,...)
  Text = Text or ""
  --pass ... onto pcall function
  local Vararg = ...
  pcall(function()
    ChoGGi.Funcs.Dump(Text .. Vararg .. "\r\n","a",Filename,"log",true)
  end)
  if type(Function) == "function" then
    Function(...)
  end
end

function ChoGGi.Funcs.QuestionBox(Msg,Function,Title,Ok,Cancel)
  pcall(function()
    Msg = Msg or "Empty"
    Ok = Ok or "Ok"
    Cancel = Cancel or "Cancel"
    Title = Title or "Placeholder"
    CreateRealTimeThread(function()
      if "ok" == WaitQuestion(nil,
        Title,
        Msg,
        Ok,
        Cancel)
      then
        Function()
      end
    end)
  end)
end

-- positive or 1 return TrueVar || negative or 0 return FalseVar
---Consts.XXX = ChoGGi.Funcs.NumRetBool(Consts.XXX,0,ChoGGi.Consts.XXX)
function ChoGGi.Funcs.NumRetBool(Num,TrueVar,FalseVar)
  if type(Num) ~= "number" then
    return
  end
  local Bool = true
  if Num < 1 then
    Bool = nil
  end
  return Bool and TrueVar or FalseVar
end

--return opposite value or first value if neither
function ChoGGi.Funcs.ValueRetOpp(Setting,Value1,Value2)
  if Setting == Value1 then
    return Value2
  elseif Setting == Value2 then
    return Value1
  end
  --just in case
  return Value1
end

--return as num
function ChoGGi.Funcs.BoolRetNum(Bool)
  if Bool == true then
    return 1
  end
  return 0
end

--toggle 0/1
function ChoGGi.Funcs.ToggleBoolNum(Num)
  if Num == 0 then
    return 1
  end
  return 0
end

--return equal or higher amount
function ChoGGi.Funcs.CompareAmounts(iAmtA,iAmtB)
  --if ones missing then just return the other
  if not iAmtA then
    return iAmtB
  elseif not iAmtB then
    return iAmtA
  --else return equal or higher amount
  elseif iAmtA >= iAmtB then
    return iAmtA
  elseif iAmtB >= iAmtA then
    return iAmtB
  end
end

--compares two values, if types are different then makes them both strings
--[[
    if sort[a] and sort[b] then
      return sort[a] < sort[b]
    end
    if sort[a] or sort[b] then
      return sort[a] and true
    end
    return CmpLower(a, b)
--]]

--[[
  table.sort(Items,
    function(a,b)
      return ChoGGi.Funcs.CompareTableNames(a,b,"text")
    end
  )
--]]
function ChoGGi.Funcs.CompareTableNames(a,b,sName)
  if type(a[sName]) == type(b[sName]) then
    return a[sName] < b[sName]
  else
    return tostring(a[sName]) < tostring(b[sName])
  end
end

function ChoGGi.Funcs.WriteLogs_Toggle(Enable)
  if Enable == true then
    --remove old logs
    local logs = "AppData/logs/"
    AsyncFileDelete(logs .. "ConsoleLog.log")
    AsyncFileDelete(logs .. "DebugLog.log")
    AsyncFileRename(logs .. "ConsoleLog.log",logs .. "ConsoleLog.previous.log")
    AsyncFileRename(logs .. "DebugLog.log",logs .. "DebugLog.previous.log")

    --redirect functions
    local function ReplaceFunc(Name,Type)
      ChoGGi.Funcs.SaveOrigFunc(Name)
      _G[Name] = function(...)
        ChoGGi.Funcs.PrintFiles(Type,ChoGGi.OrigFuncs[Name],nil,...)
      end
    end
    ReplaceFunc("AddConsoleLog","ConsoleLog")
    ReplaceFunc("printf","DebugLog")
    ReplaceFunc("DebugPrint","DebugLog")
    ReplaceFunc("OutputDebugString","DebugLog")
  else
    local function ResetFunc(Name)
      if ChoGGi.OrigFuncs[Name] then
        _G[Name] = ChoGGi.OrigFuncs[Name]
        ChoGGi.OrigFuncs[Name] = nil
      end
    end
    ResetFunc("AddConsoleLog")
    ResetFunc("printf")
    ResetFunc("DebugPrint")
    ResetFunc("OutputDebugString")
  end
end

--ChoGGi.Funcs.PrintIds(TechTree)
function ChoGGi.Funcs.PrintIds(Table)
  local text = ""

  for i = 1, #Table do
    text = text .. "----------------- " .. Table[i].id .. ": " .. i .. "\n"
    for j = 1, #Table[i] do
      text = text .. Table[i][j].id .. ": " .. j .. "\n"
    end
  end

  ChoGGi.Funcs.Dump(text)
end

--changes a function to also post a Msg for use with OnMsg
--AddMsgToFunc("CargoShuttle","GameInit","SpawnedShuttle")
function ChoGGi.Funcs.AddMsgToFunc(ClassName,FuncName,sMsg)
  --save orig
  ChoGGi.Funcs.SaveOrigFunc(FuncName,ClassName)
  --redefine it
  _G[ClassName][FuncName] = function(self,...)
    Msg(sMsg,self)
    return ChoGGi.OrigFuncs[ClassName .. "_" .. FuncName](self,...)
  end
end

function ChoGGi.Funcs.SaveOrigFunc(Name,Class)
  if Class then
    local newname = Class .. "_" .. Name
    if not ChoGGi.OrigFuncs[newname] then
      ChoGGi.OrigFuncs[newname] = _G[Class][Name]
    end
  else
    if not ChoGGi.OrigFuncs[Name] then
      ChoGGi.OrigFuncs[Name] = _G[Name]
    end
  end
end

--check for and remove broken objects from UICity.labels
function ChoGGi.Funcs.RemoveMissingLabelObjects(Label)
  local found = true
  while found do
    found = nil
    local tab = UICity.labels[Label] or empty_table
    for i = 1, #tab do
      if tostring(tab[i]:GetPos()) == "(0, 0, 0)" then
        table.remove(UICity.labels[Label],i)
        found = true
        break
      end
    end
  end
end

function ChoGGi.Funcs.RemoveFromLabel(Label,Obj)
  local tab = UICity.labels[Label] or empty_table
  for i = 1, #tab do
    if tab[i].handle == Obj.handle then
      table.remove(UICity.labels[Label],i)
    end
  end
end

function toboolean(Str)
  if Str == "true" then
    return true
  elseif Str == "false" then
    return false
  end
end

--tries to convert "65" to 65, "boolean" to boolean, "nil" to nil
function ChoGGi.Funcs.RetProperType(Value)
  --number?
  local num = tonumber(Value)
  if num then
    return num
  end
  --stringy boolean
  if Value == "true" then
    return true
  elseif Value == "false" then
    return false
  end
  if Value == "nil" then
    return
  end
  --then it's a string (probably)
  return Value
end

--change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function ChoGGi.Funcs.UserAddActions(ActionsToAdd)
  for k, v in pairs(ActionsToAdd) do
    if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
      if v.key ~= nil and v.key ~= "" then
        if type(v.key) == "table" then
          local keys = v.key
          if #keys <= 0 then
            v.description = ""
          else
            v.description = v.description .. " (" .. keys[1]
            for i = 2, #keys do
              v.description = v.description .. " or " .. keys[i]
            end
            v.description = v.description .. ")"
          end
        else
          v.description = tostring(v.description) .. " (" .. v.key .. ")"
        end
      end
      v.id = k
      v.idx = g_idxAction
      g_idxAction = g_idxAction + 1
      UserActions.Actions[k] = v
    else
      UserActions.RejectedActions[k] = v
    end
  end
  UserActions.SetMode(UserActions.mode)
end

function ChoGGi.Funcs.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  if Menu then
    Menu = "/" .. tostring(Menu)
  end
  local name = "NOFUNC"
  if Action then
    local debug_info = debug.getinfo(Action, "Sn")
    name = string.gsub(tostring(debug_info.short_src .. "(" .. debug_info.linedefined .. ")"),ChoGGi.ModPath,"")
  end

--[[
--TEST menu items
  if Menu then
    print(Menu)
  end
  if Action then
    print(Action)
  end
  if Key then
    print(Key)
  end
  if Des then
    print(Des)
  end
  if Icon then
    print(Icon)
  end
print("\n")
--]]

  --_InternalTranslate(T({Number from Game.csv}))
  --UserActions.AddActions({
  --UserActions.RejectedActions()
  ChoGGi.Funcs.UserAddActions({
    ["ChoGGi_" .. name .. AsyncRand()] = {
      menu = Menu,
      action = Action,
      key = Key,
      description = Des or "",
      icon = Icon,
      toolbar = Toolbar,
      mode = Mode,
      xinput = xInput,
      toolbar_default = ToolbarDefault
    }
  })
end

--while ChoGGi.Funcs.CheckForTypeInList(terminal.desktop,"Examine") do
function ChoGGi.Funcs.CheckForTypeInList(List,Type)
  local ret = false
  for i = 1, #List do
    if IsKindOf(List[i],Type) then
      ret = true
    end
  end
  return ret
end

--[[
ChoGGi.Funcs.ReturnTechAmount(Tech,Prop)
returns number from TechTree (so you know how much it changes)
see: Data/TechTree.lua, or examine(TechTree)

ChoGGi.Funcs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
^returns 10
ChoGGi.Funcs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
^ returns 0.7

it returns percentages in decimal for ease of mathing (SM removed the math.functions from lua)
ie: SupportiveCommunity is -70 this returns it as 0.7
it also returns negative amounts as positive (I prefer num - Amt, not num + NegAmt)
--]]
function ChoGGi.Funcs.ReturnTechAmount(Tech,Prop)
  local techdef = TechDef[Tech]

  local tab = techdef or empty_table
  for i = 1, #tab do
    if tab[i].Prop == Prop then
      Tech = tab[i]
      local RetObj = {}

      if Tech.Percent then
        local percent = Tech.Percent
        if percent < 0 then
          percent = percent * -1 -- -50 > 50
        end
        RetObj.p = (percent + 0.0) / 100 -- (50 > 50.0) > 0.50
      end

      if Tech.Amount then
        if Tech.Amount < 0 then
          RetObj.a = Tech.Amount * -1 -- always gotta be positive
        else
          RetObj.a = Tech.Amount
        end
      end

      --With enemies you know where they stand but with Neutrals, who knows?
      if RetObj.a == 0 then
        return RetObj.p
      elseif RetObj.p == 0.0 then
        return RetObj.a
      end
    end
  end
end

--[[
  --need to see if research is unlocked
  if IsResearched and UICity:IsTechResearched(IsResearched) then
    --boolean consts
    Value = ChoGGi.Funcs.ReturnTechAmount(IsResearched,Name)
    --amount
    Consts["TravelTimeMarsEarth"] = Value
  end
--]]
--function ChoGGi.Funcs.SetConstsG(Name,Value,IsResearched)
function ChoGGi.Funcs.SetConstsG(Name,Value)
  --we only want to change it if user set value
  if Value then
    --some mods change Consts or g_Consts, so we'll just do both to be sure
    Consts[Name] = Value
    g_Consts[Name] = Value
  end
end

--if value is the same as stored then make it false instead of default value, so it doesn't apply next time
function ChoGGi.Funcs.SetSavedSetting(Setting,Value)
  --if setting is the same as the default then make it false
  if ChoGGi.Consts[Setting] == Value then
    ChoGGi.UserSettings[Setting] = false
  else
    ChoGGi.UserSettings[Setting] = Value
  end
end

function ChoGGi.Funcs.RetTableNoDupes(Table)
  local tempt = {}
  local dupe = {}

  local tab = Table or empty_table
  for i = 1, #tab do
    if not dupe[tab[i]] then
      tempt[#tempt+1] = tab[i]
      dupe[tab[i]] = true
    end
  end
  return tempt
end

--RemoveFromTable(sometable,"class","SelectionArrow")
function ChoGGi.Funcs.RemoveFromTable(Table,Type,Text)
  local tempt = {}

  local tab = Table or empty_table
  for i = 1, #tab do
    if tab[i][Type] ~= Text then
      tempt[#tempt+1] = tab[i]
    end
  end
  return tempt
end

--ex(NearestObject(GetTerrainCursor(),temptable),20000)
--RemoveFromTable(GetObjects({class="PropertyObject"}),{ParSystem=1,ResourceStockpile=1},"class")
function ChoGGi.Funcs.RemoveFromTable(Table,ExcludeList,Type)
  return FilterObjects({
      filter = function(o)
        if not ExcludeList[o[Type]] then
          return o
        end
      end
    },Table)
end
