-- load settings before anything else (for anything in /Code that uses them)
local new_settings_file = "AppData/LocalStorage_Settings.lua"
g_LocalStorageFile = new_settings_file
local settings = dofile(new_settings_file)
LocalStorage = settings

-- skip
--~ do return settings end

-- any "mods" that need to be loaded before the game is loaded (skip logos, etc)
dofolder_files("AppData/BinAssets/Code")

-- local some globals
local setmetatable,getmetatable = setmetatable,getmetatable
local pairs,rawget = pairs,rawget
-- a less restrictive env (okay, not at all restrictive)
local orig_G = _G
local mod_env = {
	__index = function(_, key)
		return orig_G[key]
	end,
	__newindex = function(_, key, value)
		orig_G[key] = value
	end,
}
local orig_OnMsg = getmetatable(orig_G.OnMsg)
local function LuaModEnv(env)
  env = env or {}
  env._G = orig_G
	setmetatable(env,mod_env)
	-- for not GP
	if env.OnMsg then
		-- it needs to be cleared first
		setmetatable(env.OnMsg)
		setmetatable(env.OnMsg,orig_OnMsg)
	end
  return env
end

-- thread needed for WaitMsg
CreateRealTimeThread(function()

	-- build a list of ids from lua files in "Mod Ids"
	local mod_ids = {}
	local err, files = AsyncListFiles("AppData/BinAssets/Mod Ids","*.lua")
	if not err and #files > 0 then
		local AsyncFileToString = AsyncFileToString
		for i = 1, #files do
			local err,id = AsyncFileToString(files[i])
			if not err then
				mod_ids[id] = true
			end
		end
	end

	-- needs an inf loop, so it fires whenever mod manager does it's thing.
	while true do
		-- wait till mods are loaded
		WaitMsg("ModDefsLoaded")

		-- remove blacklist for any mods in "Mod Ids"
		for _,mod in pairs(Mods) do
			if mod_ids[mod.steam_id] then
				-- just a little overreaching with that blacklist (yeah yeah, safety first and all that)
				mod.no_blacklist = true
				local env = mod.env
				for key in pairs(env) do
					if key ~= "OnMsg" then
						local g_key = rawget(orig_G,key)
						if g_key then
							env[key] = g_key
						end
					end
				end
				mod.env = LuaModEnv(env)
				-- add a warning to any mods without a blacklist, so user knows something is up
--~ 				mod.title = mod.title .. " (BL)"
				mod.title = mod.title .. " (Warning)"
--~ 				mod.description = mod.description:gsub([[C:\Users\ChoGGi\AppData\Roaming\Surviving Mars\Mods\]],"AppData/Mods/")
				mod.description = [[Warning: The blacklist function has been removed for this mod!
This means it has no limitations and can access your Steam name, Friends list, and run any files on your computer.

]] .. mod.description
			end
		end

		-- just in case anything needs it
		Msg("ChoGGi_Blacklist")
	end
end)

-- and done
return settings
