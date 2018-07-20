--See LICENSE for terms

local Concat = FlattenGround.ComFuncs.Concat
local T = FlattenGround.ComFuncs.Trans

local CreateRealTimeThread = CreateRealTimeThread
local DeleteThread = DeleteThread
local DoneObject = DoneObject
local GetTerrainCursor = GetTerrainCursor
local RecalcBuildableGrid = RecalcBuildableGrid

local guic = guic
local white = white
--local TerrainTextures = TerrainTextures

local terrain_GetHeight = terrain.GetHeight
local terrain_SetHeightCircle = terrain.SetHeightCircle
local terrain_SetTypeCircle = terrain.SetTypeCircle
local UserActions_AddActions = UserActions.AddActions
local UserActions_RemoveActions = UserActions.RemoveActions
local UserActions_GetActiveActions = UserActions.GetActiveActions
local UAMenu_UpdateUAMenu = UAMenu.UpdateUAMenu

local g_Classes = g_Classes

local OnMsg = OnMsg
local Msg = Msg

function OnMsg.LoadGame()
  Msg("FlattenGround_Loaded")
end
function OnMsg.CityStart()
  Msg("FlattenGround_Loaded")
end

--fired when game is loaded
function OnMsg.FlattenGround_Loaded()

  UserActions.AddActions({
    [Concat("FlattenGround-",AsyncRand())] = {
      menu = Concat("[102]Debug/",T(302535920000485--[[Flatten Terrain Toggle--]])),
      action = FlattenGround.MenuFuncs.FlattenTerrain_Toggle,
      key = "Shift-F",
      description = T(302535920000486--[[Use the shortcut to turn this on as it will use where your cursor is as the height to flatten to.--]]),
      icon = "FixUnderwaterEdges.tga"
    }
  })

  UserActions.AddActions({
    [Concat("FlattenGround-",AsyncRand())] = {
      menu = Concat("[102]Debug/",T(302535920000864--[[Delete All Rocks--]])),
      action = FlattenGround.MenuFuncs.DeleteAllRocks,
      key = "Ctrl-Shift-F",
      description = T(302535920001238--[[Removes any rocks for that smooth map feel (will take about 30 seconds).--]]),
      icon = "selslope.tga"
    }
  })

end

local function DeleteAllRocks(rock_cls)
  local objs = GetObjects{class = rock_cls} or empty_table
  for i = 1, #objs do
    objs[i]:delete()
  end
end

function FlattenGround.MenuFuncs.DeleteAllRocks()
  local function CallBackFunc(answer)
    if answer then
      DeleteAllRocks("Deposition")
      DeleteAllRocks("WasteRockObstructorSmall")
      DeleteAllRocks("WasteRockObstructor")
    end
  end
  FlattenGround.ComFuncs.QuestionBox(
    Concat(T(6779--[[Warning--]]),"!\n",T(302535920001238--[[Removes any rocks for that smooth map feel (will take about 30 seconds).--]])),
    CallBackFunc,
    Concat(T(6779--[[Warning--]]),": ",T(302535920000855--[[Last chance before deletion!--]]))
  )
end

local are_we_flattening
local visual_circle
local flatten_height

local remove_actions = {
  FlattenGround_RaiseHeight = true,
  FlattenGround_LowerHeight = true,
  FlattenGround_WidenRadius = true,
  FlattenGround_ShrinkRadius = true,
}
local temp_height
local function ToggleHotkeys(bool)
  local FlattenGround = FlattenGround

  if bool then
    UserActions_AddActions({
      FlattenGround_RaiseHeight = {
        key = "Shift-Up",
        action = function()
          temp_height = flatten_height + FlattenGround.FlattenGroundHeightDiff
          --guess i found the ceiling height
          if temp_height > 65535 then
            temp_height = 65535
          end
          flatten_height = temp_height
        end
      },
      FlattenGround_LowerHeight = {
        key = "Shift-Down",
        action = function()
          temp_height = flatten_height - FlattenGround.FlattenGroundHeightDiff
          --and the floor limit (oh look 0 go figure)
          if temp_height < 0 then
            temp_height = 0
          end
          flatten_height = temp_height
        end
      },
      FlattenGround_WidenRadius = {
        key = "Shift-Right",
        action = function()
          FlattenGround.FlattenGroundRadius = FlattenGround.FlattenGroundRadius + FlattenGround.FlattenGroundRadiusDiff

          visual_circle:SetRadius(FlattenGround.FlattenGroundRadius)
          FlattenGround.FlattenGroundRadius = FlattenGround.FlattenGroundRadius * guic
        end
      },
      FlattenGround_ShrinkRadius = {
        key = "Shift-Left",
        action = function()
          FlattenGround.FlattenGroundRadius = FlattenGround.FlattenGroundRadius - FlattenGround.FlattenGroundRadiusDiff

          visual_circle:SetRadius(FlattenGround.FlattenGroundRadius)
          FlattenGround.FlattenGroundRadius = FlattenGround.FlattenGroundRadius * guic
        end
      },
    })
  else
    local UserActions = UserActions
    for k, _ in pairs(UserActions.Actions) do
      if remove_actions[k] then
        UserActions.Actions[k] = nil
      end
    end
  end

  UAMenu_UpdateUAMenu(UserActions_GetActiveActions())
end
local function ToggleCollisions(objs)
  for i = 1, #objs do
    FlattenGround.CodeFuncs.CollisionsObject_Toggle(objs[i],true)
  end
end

function FlattenGround.MenuFuncs.FlattenTerrain_Toggle()
  local FlattenGround = FlattenGround

  if are_we_flattening then
    ToggleHotkeys()
    are_we_flattening = false
    DeleteThread(are_we_flattening)
    DoneObject(visual_circle)
    FlattenGround.ComFuncs.MsgPopup(
      T(302535920001164--[[Flattening has been stopped, now updating buildable.--]]),
      T(904--[[Terrain--]]),
      "UI/Icons/Sections/WasteRock_1.tga"
    )
    -- disable collisions on pipes so they don't get marked as uneven terrain
    local objs = GetObjects{class = "LifeSupportGridElement"} or empty_table
    ToggleCollisions(objs)
    -- update uneven terrain checker thingy
    RecalcBuildableGrid()
    -- turn them back on
    ToggleCollisions(objs)

  else
    ToggleHotkeys(true)
    flatten_height = terrain_GetHeight(GetTerrainCursor())
    FlattenGround.ComFuncs.MsgPopup(
      string.format(T(302535920001163--[[Flatten height has been choosen %s, press shortcut again to update buildable.--]]),flatten_height),
      T(904--[[Terrain--]]),
      "UI/Icons/Sections/warning.tga"
    )

--~     local terrain_type = mapdata.BaseLayer or "SandRed_1"		-- applied terrain type
--~     local terrain_type_idx = table.find(TerrainTextures, "name", terrain_type)
    visual_circle = g_Classes.Circle:new()
    visual_circle:SetRadius(FlattenGround.FlattenGroundRadius)
    visual_circle:SetColor(white)


    are_we_flattening = CreateRealTimeThread(function()
      --thread gets deleted, but just in case
      while are_we_flattening do
        local cursor = GetTerrainCursor()
        visual_circle:SetPos(cursor)
        terrain_SetHeightCircle(cursor, FlattenGround.FlattenGroundRadius, FlattenGround.FlattenGroundRadius, flatten_height)
        --uncomment to change the texture
        --terrain_SetTypeCircle(cursor, radius, terrain.GetTerrainType(cursor))
        Sleep(10)
      end
    end)

  end

end