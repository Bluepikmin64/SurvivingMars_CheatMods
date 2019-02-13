-- See LICENSE for terms

local default_icon = "UI/Icons/Sections/spaceship.tga"
local type = type

function OnMsg.ClassesGenerate()
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local Trans = ChoGGi.ComFuncs.Translate
	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist

	function ChoGGi.MenuFuncs.ChangeRivalColonies()
--~ 		MarsScreenLandingSpots
		local g_CurrentMissionParams = g_CurrentMissionParams
		local rival_colonies = MissionParams.idRivalColonies.items
		local g_RivalAIs = RivalAIs or empty_table

		local skip = {
			random = true,
			none = true,
			[g_CurrentMissionParams.idMissionSponsor] = true,
		}

		local ItemList = {}
		local c = 0
		for i = 1, #rival_colonies do
			local rival = rival_colonies[i]
			if not skip[rival.id] then
				local existing = g_RivalAIs[rival.id]
				local name = Trans(rival.display_name)
				local initial_res = {}
				for j = 1, #rival.initial_resources do
					local res = rival.initial_resources[j]
					if res.amount then
						initial_res[#initial_res+1] = res.resource .. " " .. res.amount .. "\n"
					end
				end

				c = c + 1
				ItemList[c] = {
					text = existing and (name .. "%s *") or name,
					value = rival.id,
					rival = rival,
					existing = existing,
					hint = S[302535920001461--[[* means it's an active rival you can remove.--]]]
						.. "\n\n"
						.. Trans(rival.description)
						.. "\n\n"
						.. TableConcat(initial_res),
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local add = choice[1].check1
			local remove = choice[1].check2

			-- if it's an old save without rivals added
			if not g_CurrentMissionParams.idRivalColonies then
				local rivals_table = {}
				if add then
					for i = 1, #choice do
						rivals_table[#rivals_table+1] = choice[i].value
					end
					local num = #rivals_table
					if num < 3 then
						for _ = num, 3 - num do
							rivals_table[#rivals_table+1] = "none"
						end
					end
				elseif remove then
					return
				end
				g_CurrentMissionParams.idRivalColonies = rivals_table
				Msg("OurColonyPlaced")
			end
			local g_RivalAIs = RivalAIs

			if add then
				for i = 1, #choice do
					local value = choice[i].value
					-- if it's an actual rival, and not one already added
					if not g_RivalAIs[value] then
						SpawnRivalAI(choice[i].rival)
					end
				end
			elseif remove then
				for i = 1, #choice do
					if choice[i].existing then
						DeleteRivalAI(choice[i].existing)
					end
				end
			end

			MsgPopup(
				tostring(#choice),
				11034--[[Rival Colonies--]]
			)

		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 11034--[[Rival Colonies--]],
			hint = S[302535920001460--[[Add/remove rival colonies.--]]] .. "\n" .. S[302535920001461--[[* means it's an active rival you can remove.--]]],
			multisel = true,
			custom_type = 3,
			check = {
				only_one = true,
				at_least_one = true,
				{
					title = 302535920001183--[[Add--]],
					hint = S[302535920001462--[[%s rival colonies.--]]]:format(S[302535920001183--[[Add--]]]),
					checked = true,
				},
				{
					title = 302535920000281--[[Remove--]],
					hint = S[302535920001462--[[%s rival colonies.--]]]:format(S[302535920000281--[[Remove--]]]),
				},
			},

		}
	end

	function ChoGGi.MenuFuncs.StartChallenge()
		local ItemList = {}
		local challenges = Presets.Challenge.Default
		local DayDuration = const.DayDuration

		for i = 1, #challenges do
			local c = challenges[i]
			ItemList[i] = {
				text = Trans(c.title),
				value = c.id,
				hint = Trans(c.description) .. "\n\n"
					.. S[302535920001415--[[Sols to Complete: %s--]]]:format(c.time_completed / DayDuration)
					.. "\n"
					.. Trans(T{10489--[[<newline>Perfect time: <countdown2>--]],countdown2 = c.time_perfected / DayDuration}),
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			g_CurrentMissionParams.challenge_id = choice[1].value
			-- just in case
			challenges[choice[1].value].TrackProgress = true

			UICity:StartChallenge()

			MsgPopup(
				choice[1].text,
				302535920001247--[[Start Challenge--]]
			)
		end

		local hint
		local thread = UICity.challenge_thread
		if not blacklist and IsValidThread(thread) then
			local _,c = debug.getlocal(thread,1,1)
			hint = S[302535920000106--[[Current--]]] .. ": " .. Trans(c.title) .. ", " .. c.id
		end
		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001247--[[Start Challenge--]],
			hint = hint,
		}
	end

	function ChoGGi.MenuFuncs.InstantMissionGoals()
		local T = T
		local GetGoalDescription = GetGoalDescription
		local SponsorGoalsMap = SponsorGoalsMap
		local SponsorGoalProgress = SponsorGoalProgress

		local ItemList = {}
		local sponsor = GetMissionSponsor()
		local hint_str = "<image %s>\n\n%s: %s\n%s %s"

		for i = 1, 5 do
			-- no sense in showing done ones
			if not SponsorGoalProgress[i].state then
				local reward = sponsor["reward_effect_" .. i]
				ItemList[#ItemList+1] = {
					text = i .. " " .. sponsor["sponsor_goal_" .. i],
					value = i,
					hint = "<image " .. sponsor["goal_image_" .. i] .. ">\n\n"
						.. S[302535920001409--[[Goal--]]] .. ": "
						.. Trans(GetGoalDescription(sponsor, i)) .. "\n"
						.. S[128569337702--[[Reward:--]]] .. " "
						.. Trans(T(reward.Description, reward)),
					reward = reward,
					goal = SponsorGoalsMap[sponsor["sponsor_goal_" .. i]],
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			for i = 1, #choice do
				local goalprog = SponsorGoalProgress[choice[i].value]
				-- you weiner
				goalprog.state = GameTime()
				goalprog.progress = goalprog.target

				local reward = choice[i].reward
				local goal = choice[i].goal
				-- stuff from City:SetGoals()
				reward:Execute()
				AddOnScreenNotification("GoalCompleted", OpenMissionProfileDlg, {reward_description = T(reward.Description, reward), context = context, rollover_title = T(4773, "<em>Goal:</em> "), rollover_text = goal.description})
				Msg("GoalComplete", goal)
				if AreAllSponsorGoalsCompleted() then
					Msg("MissionEvaluationDone")
				end
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000704--[[Instant Mission Goals--]],
			multisel = true,
		}
	end

	function ChoGGi.MenuFuncs.InstantColonyApproval()
		CreateRealTimeThread(WaitPopupNotification, "ColonyViabilityExit_Delay")
		Msg("ColonyApprovalPassed")
		g_ColonyNotViableUntil = -1

		MsgPopup(
			"true",
			302535920000706--[[Instant Colony Approval--]]
		)
	end

	function ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle()
		local ChoGGi = ChoGGi
		local Consts = Consts
		ChoGGi.ComFuncs.SetConstsG("MeteorHealthDamage",ChoGGi.ComFuncs.NumRetBool(Consts.MeteorHealthDamage,0,ChoGGi.Consts.MeteorHealthDamage))
		ChoGGi.ComFuncs.SetSavedSetting("MeteorHealthDamage",Consts.MeteorHealthDamage)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(S[302535920001160--[["%s
	Damage? Total, sir.
	It's what we call a global killer.
	The end of mankind. Doesn't matter where it hits. Nothing would survive, not even bacteria."--]]]:format(ChoGGi.UserSettings.MeteorHealthDamage),
			547--[[Colonists--]],
			"UI/Icons/Notifications/meteor_storm.tga",
			true
		)
	end

	function ChoGGi.MenuFuncs.ChangeSponsor()
		local Presets = Presets

		local ItemList = {}
		local c = 0
		local objs = Presets.MissionSponsorPreset.Default or ""
		for i = 1, #objs do
			local obj = objs[i]
			if obj.id ~= "random" and obj.id ~= "None" then
				local descr = GetSponsorDescr(obj, false, "include rockets", true, true)
				local stats
				-- the one we want is near the end, but there's also a blank item below it
				for j = 1, #descr do
					if type(descr[j]) == "table" then
						stats = descr[j]
					end
				end

				c = c + 1
				ItemList[c] = {
					text = Trans(obj.display_name),
					value = obj.id,
					hint = Trans(T(obj.effect,stats[2]))
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			local g_CurrentMissionParams = g_CurrentMissionParams
			for i = 1, #ItemList do
				-- check to make sure it isn't a fake name (no sense in saving it)
				if ItemList[i].value == value then
					-- new spons
					g_CurrentMissionParams.idMissionSponsor = value
					-- apply tech from new sponsor
					local UICity = UICity
					local sponsor = GetMissionSponsor()
					UICity:GrantTechFromProperties(sponsor)
					sponsor:game_apply(UICity)
					sponsor:EffectsApply(UICity)
					UICity:ApplyModificationsFromProperties()
					-- and bonuses
					UICity:InitMissionBonuses()

					MsgPopup(
						S[302535920001161--[[Sponsor for this save is now %s--]]]:format(choice[1].text),
						302535920001162--[[Sponsor--]],
						default_icon
					)
					break
				end
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000712--[[Set Sponsor--]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. Trans(GetMissionSponsor().display_name),
		}
	end

	function ChoGGi.MenuFuncs.SetSponsorBonus()
		local ChoGGi = ChoGGi
		local Presets = Presets

		local ItemList = {}
		local c = 0
		local objs = Presets.MissionSponsorPreset.Default or ""
		for i = 1, #objs do
			local obj = objs[i]
			if obj.id ~= "random" and obj.id ~= "None" then
				local descr = GetSponsorDescr(obj, false, "include rockets", true, true)
				local stats
				-- the one we want is near the end, but there's also a blank item below it
				for j = 1, #descr do
					if type(descr[j]) == "table" then
						stats = descr[j]
					end
				end

				c = c + 1
				ItemList[c] = {
					text = Trans(obj.display_name),
					value = obj.id,
					hint = Trans(T(obj.effect,stats[2])) .. "\n\n" .. S[302535920001165--[[Enabled Status--]]]
					.. ": " .. ChoGGi.UserSettings["Sponsor" .. obj.id]
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			if choice[1].check2 then
				for i = 1, #ItemList do
					local value = ItemList[i].value
					if type(value) == "string" then
						value = "Sponsor" .. value
						ChoGGi.UserSettings[value] = nil
					end
				end
			else
				for i = 1, #choice do
					for j = 1, #ItemList do
						--check to make sure it isn't a fake name (no sense in saving it)
						local value = choice[i].value
						if ItemList[j].value == value and type(value) == "string" then
							local name = "Sponsor" .. value
							if choice[1].check1 then
								ChoGGi.UserSettings[name] = nil
							else
								ChoGGi.UserSettings[name] = true
							end
							if ChoGGi.UserSettings[name] then
								ChoGGi.ComFuncs.SetSponsorBonuses(value)
							end
						end
					end
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(#choice,302535920001166--[[Bonuses--]]),
				302535920001162--[[Sponsor--]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920001162--[[Sponsor--]]] .. " " .. S[302535920001166--[[Bonuses--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. Trans(GetMissionSponsor().display_name) .. "\n\n" .. S[302535920001168--[[Modded ones are mostly ignored for now (just cargo space/research points).--]]],
			multisel = true,
			check = {
				{
					title = 302535920001169--[[Turn Off--]],
					hint = 302535920001170--[[Turn off selected bonuses (defaults to turning on).--]],
				},
				{
					title = 302535920001171--[[Turn All Off--]],
					hint = 302535920001172--[[Turns off all bonuses.--]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.ChangeCommander()
		local Presets = Presets
		local g_CurrentMissionParams = g_CurrentMissionParams
		local UICity = UICity

		local ItemList = {}
		local objs = Presets.CommanderProfilePreset.Default or ""
		for i = 1, #objs do
			local obj = objs[i]
			if obj.id ~= "random" and obj.id ~= "None" then
				ItemList[#ItemList+1] = {
					text = Trans(obj.display_name),
					value = obj.id,
					hint = Trans(obj.effect)
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			for i = 1, #ItemList do
				--check to make sure it isn't a fake name (no sense in saving it)
				if ItemList[i].value == value then
					-- new comm
					g_CurrentMissionParams.idCommanderProfile = value
					-- apply tech from new commmander
					local comm = GetCommanderProfile()
					local UICity = UICity

					comm:game_apply(UICity)
					comm:OnApplyEffect(UICity)
					UICity:ApplyModificationsFromProperties()

					--and bonuses
					UICity:InitMissionBonuses()

					MsgPopup(
						S[302535920001173--[[Commander for this save is now %s.--]]]:format(choice[1].text),
						302535920001174--[[Commander--]],
						default_icon
					)
					break
				end
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000716--[[Set Commander--]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. Trans(GetCommanderProfile().display_name),
		}
	end

	function ChoGGi.MenuFuncs.SetCommanderBonus()
		local Presets = Presets

		local ItemList = {}
		local objs = Presets.CommanderProfilePreset.Default or ""
		for i = 1, #objs do
			local obj = objs[i]
			if obj.id ~= "random" and obj.id ~= "None" then
				ItemList[#ItemList+1] = {
					text = Trans(obj.display_name),
					value = obj.id,
					hint = Trans(obj.effect) .. "\n\n" .. S[302535920001165--[[Enabled Status--]]] .. ": " .. ChoGGi.UserSettings["Commander" .. obj.id],
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			if choice[1].check2 then
				for i = 1, #ItemList do
					local value = ItemList[i].value
					if type(value) == "string" then
						value = "Commander" .. value
						ChoGGi.UserSettings[value] = nil
					end
				end
			else
				for i = 1, #choice do
					for j = 1, #ItemList do
						--check to make sure it isn't a fake name (no sense in saving it)
						local value = choice[i].value
						if ItemList[j].value == value and type(value) == "string" then
							local name = "Commander" .. value
							if choice[1].check1 then
								ChoGGi.UserSettings[name] = nil
							else
								ChoGGi.UserSettings[name] = true
							end
							if ChoGGi.UserSettings[name] then
								ChoGGi.ComFuncs.SetCommanderBonuses(value)
							end
						end
					end
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(#choice,302535920001166--[[Bonuses--]]),
				302535920001174--[[Commander--]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920001174--[[Commander--]]] .. " " .. S[302535920001166--[[Bonuses--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. Trans(GetCommanderProfile().display_name),
			multisel = true,
			check = {
				{
					title = 302535920001169--[[Turn Off--]],
					hint = 302535920001170--[[Turn off selected bonuses (defaults to turning on).--]],
				},
				{
					title = 302535920001171--[[Turn All Off--]],
					hint = 302535920001172--[[Turns off all bonuses.--]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.ChangeGameLogo()
		local MissionLogoPresetMap = MissionLogoPresetMap
		local GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches
		local RetAllOfClass = ChoGGi.ComFuncs.RetAllOfClass

		local ItemList = {}
		for id,def in pairs(MissionLogoPresetMap) do
			ItemList[#ItemList+1] = {
				text = Trans(def.display_name),
				value = id,
				hint = "<image " .. def.image .. ">",
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			local logo = MissionLogoPresetMap[value]

			-- check if user typed custom name and screwed up
			if logo then
				local entity_name = logo.entity_name

				local function ChangeLogo(label)
					label = RetAllOfClass(label)
					for i = 1, #label do
						local a_list = GetAllAttaches(label[i])
--~ ex(a_list)
--~ break
						for j = 1, #a_list do
							local attach = a_list[j]
							if attach:IsKindOf("Logo") then
								attach:ChangeEntity(entity_name)
							end
						end
					end
				end

				-- for any new objects
				g_CurrentMissionParams.idMissionLogo = value
				-- loop through rockets and change logo
				ChangeLogo("SupplyRocket")
				-- same for any buildings that use the logo
				ChangeLogo("Building")

				MsgPopup(
					choice[1].text,
					302535920001177--[[Logo--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001178--[[Set New Logo--]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. Trans(MissionLogoPresetMap[g_CurrentMissionParams.idMissionLogo].display_name),
			height = 800.0,
			custom_type = 7,
			custom_func = CallBackFunc,
		}
	end

	function ChoGGi.MenuFuncs.SetDisasterOccurrence(sType)
		local mapdata = mapdata

		local ItemList = {{
			text = " " .. S[302535920000036--[[Disabled--]]],
			value = "disabled"
		}}
		local set_name = "MapSettings_" .. sType
		local data = DataInstances[set_name]

		for i = 1, #data do
			ItemList[#ItemList+1] = {
				text = data[i].name,
				value = data[i].name
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value

			mapdata[set_name] = value
			if sType == "Meteor" then
				RestartGlobalGameTimeThread("Meteors")
				RestartGlobalGameTimeThread("MeteorStorm")
			else
				RestartGlobalGameTimeThread(sType)
			end

			MsgPopup(
				S[302535920001179--[[%s occurrence is now: %s--]]]:format(sType,value),
				3983--[[Disasters--]],
				"UI/Icons/Sections/attention.tga"
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000129--[[Set--]]] .. " " .. sType .. " " .. S[302535920001180--[[Disaster Occurrences--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. mapdata[set_name],
		}
	end

	function ChoGGi.MenuFuncs.ChangeRules()
		local GameRulesMap = GameRulesMap
		local g_CurrentMissionParams = g_CurrentMissionParams

		local ItemList = {}
		local c = 0
		for id,def in pairs(GameRulesMap) do
			c = c + 1
			ItemList[c] = {
				text = Trans(def.display_name),
				value = id,
				hint = Trans(def.description) .. "\n" .. Trans(def.flavor) .. "\n"
					.. S[3491--[[Challenge Mod (%)--]]] .. ": " .. def.challenge_mod .. "\n\n"
					.. S[302535920001357--[[Exclusion List--]]] .. ": " .. (def.exclusionlist or ""),
			}
		end


		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local check1 = choice[1].check1
			local check2 = choice[1].check2

			for i = 1, #ItemList do
				-- check to make sure it isn't a fake name (no sense in saving it)
				for j = 1, #choice do
					local value = choice[j].value
					if ItemList[i].value == value then
						--new comm
						if not g_CurrentMissionParams.idGameRules then
							g_CurrentMissionParams.idGameRules = {}
						end
						if check1 then
							g_CurrentMissionParams.idGameRules[value] = true
						elseif check2 then
							g_CurrentMissionParams.idGameRules[value] = nil
						end
					end
				end
			end

			-- apply new rules, something tells me this doesn't disable old rules...
			local rules = GetActiveGameRules()
			local UICity = UICity
			for i = 1, #rules do
				GameRulesMap[rules[i]]:EffectsInit(UICity)
				GameRulesMap[rules[i]]:EffectsApply(UICity)
			end

			MsgPopup(
				ChoGGi.ComFuncs.SettingState(#choice,302535920000129--[[Set--]]),
				302535920001181--[[Rules--]],
				"UI/Icons/Sections/workshifts.tga"
			)
		end

		local hint
		local rules = g_CurrentMissionParams.idGameRules
		if type(rules) == "table" and next(rules) then
			hint = {}
			hint[#hint+1] = S[302535920000106--[[Current--]]]
			hint[#hint+1] = ":"
			for key in pairs(rules) do
				hint[#hint+1] = " "
				hint[#hint+1] = Trans(GameRulesMap[key].display_name)
			end
		end
		if hint then
			hint = TableConcat(hint)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001182--[[Set Game Rules--]],
			hint = hint,
			multisel = true,
			check = {
				only_one = true,
				at_least_one = true,
				{
					title = 302535920001183--[[Add--]],
					hint = 302535920001185--[[Add selected rules--]],
					checked = true,
				},
				{
					title = 302535920000281--[[Remove--]],
					hint = 302535920001186--[[Remove selected rules--]],
				},
			},
		}
	end

end
