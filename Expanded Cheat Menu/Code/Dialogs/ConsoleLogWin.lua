-- See LICENSE for terms

-- displays the log in a dialog

local S
local blacklist
local GetParentOfKind

function OnMsg.ClassesGenerate()
	S = ChoGGi.Strings
	blacklist = ChoGGi.blacklist
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
end

local function GetRootDialog(dlg)
	return GetParentOfKind(dlg,"ChoGGi_ConsoleLogWin")
end
DefineClass.ChoGGi_ConsoleLogWin = {
	__parents = {"ChoGGi_Window"},
	transp_mode = false,
	update_thread = false,

	dialog_width = 700.0,
	dialog_height = 500.0,
	title = 302535920001120--[[Console Window--]],
}

function ChoGGi_ConsoleLogWin:Init(parent, context)
	local ChoGGi = ChoGGi
	local g_Classes = g_Classes

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
		Id = "idButtonContainer",
		Dock = "top",
	}, self.idDialog)

	self.idToggleTrans = g_Classes.ChoGGi_CheckButton:new({
		Id = "idToggleTrans",
		Text = S[302535920000865--[[Trans--]]],
		RolloverText = S[302535920001367--[[Toggles--]]] .. " " .. S[302535920000629--[[UI Transparency--]]],
		Dock = "left",
		Margins = box(4,0,0,0),
		OnChange = self.idToggleTransOnChange,
	}, self.idButtonContainer)

	self.idToggleTrans:AddInterpolation{
		type = const.intAlpha,
		startValue = 255,
		flags = const.intfIgnoreParent
	}

	self.idShowFileLog = g_Classes.ChoGGi_Button:new({
		Id = "idShowFileLog",
		Dock = "left",
		Text = S[302535920001026--[[Show File Log--]]],
		RolloverText = S[302535920001091--[[Flushes log to disk and displays in console log.--]]],
		OnPress = self.idShowFileLogOnPress,
	}, self.idButtonContainer)

	self.idShowModsLog = g_Classes.ChoGGi_Button:new({
		Id = "idShowModsLog",
		Dock = "left",
		Text = S[302535920000071--[[Mods Log--]]],
		RolloverText = S[302535920000870--[[Shows any errors from loading mods in console log.--]]],
		OnPress = self.idShowModsLogOnPress,
	}, self.idButtonContainer)

	self.idClearLog = g_Classes.ChoGGi_Button:new({
		Id = "idClearLog",
		Dock = "left",
		Text = S[302535920000734--[[Clear Log--]]],
		RolloverText = S[302535920000477--[[Clear out the windowed console log.--]]],
		OnPress = self.idClearLogOnPress,
	}, self.idButtonContainer)

	self.idCopyText = g_Classes.ChoGGi_Button:new({
		Id = "idCopyText",
		Dock = "left",
		Text = S[302535920000563--[[Copy Log Text--]]],
		RolloverText = S[302535920001154--[[Displays the log text in a window you can copy sections from.--]]],
		OnPress = self.idCopyTextOnPress,
	}, self.idButtonContainer)

	-- text box with log in it
	self:AddScrollText()

	self.idTextInputArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idTextInputArea",
		Dock = "bottom",
	}, self.idDialog)

	self.idTextInput = g_Classes.ChoGGi_TextInput:new({
		Id = "idTextInput",
		OnKbdKeyDown = self.idTextInputOnKbdKeyDown,
		RolloverTemplate = "Rollover",
		RolloverTitle = S[302535920001073--[[Console--]]] .. " " .. S[487939677892--[[Help--]]],
	}, self.idTextInputArea)

	if blacklist then
		self.idTextInput.RolloverText = S[302535920001512--[[You need to have my HelperMod enabled to use these:--]]] .. "\n\n\n" .. S[302535920001440]
		self.idTextInput.Hint = S[302535920001513--[["ex(obj) = examine object, s = SelectedObj, c() = GetTerrainCursor(), restart() = quit(""restart"")"--]]]
	else
		-- add tooltip
		self.idTextInput.RolloverText = S[302535920001440--[["~obj opens object in examine dlg.
~~obj opens object's attachments in examine dlg.

&handle examines object with that handle.

@GetMissionSponsor prints file name and line number of function.

@@EntityData prints type(EntityData).

%""UI/Vignette.tga"" opens image in image viewer.

$123 or $EffectDeposit.display_name prints translated string.

""*r Sleep(1000) print(""sleeping"")"" to wrap in a real time thread (or *g or *m).

!UICity.labels.TerrainDeposit[1] move camera and select obj.

s = SelectedObj, c() = GetTerrainCursor(), restart() = quit(""restart"")"--]]]
		self.idTextInput.Hint = S[302535920001439--[["~obj, @func, @@type, $id, %image, *r/*g/*m threads. Hover mouse for more info."--]]]
	end

	-- look at them sexy internals
	self.transp_mode = ChoGGi.Temp.transp_mode
	self:SetTranspMode(self.transp_mode)

	self:PostInit()
end

function ChoGGi_ConsoleLogWin:idTextInputOnKbdKeyDown(vk,...)
	local dlgConsole = dlgConsole
	if not dlgConsole then
		return ChoGGi_TextInput.OnKbdKeyDown(self,vk,...)
	end
	local input = GetRootDialog(self).idTextInput

	if vk == const.vkEnter then
		local text = input:GetText()
		if text ~= "" then
			dlgConsole:Exec(text)
		end
--~ 		-- clear text
--~ 		text:SetText("")
		return "break"
	elseif vk == const.vkUp then
		if dlgConsole.history_queue_idx + 1 <= #dlgConsole.history_queue then
			dlgConsole.history_queue_idx = dlgConsole.history_queue_idx + 1
		else
			dlgConsole.history_queue_idx = 1
		end
		local text = dlgConsole.history_queue[dlgConsole.history_queue_idx] or ""
		input:SetText(text)
		input:SetCursor(1,#text)
		return "break"
	elseif vk == const.vkDown then
		if dlgConsole.history_queue_idx <= 1 then
			dlgConsole.history_queue_idx = #dlgConsole.history_queue
		else
			dlgConsole.history_queue_idx = dlgConsole.history_queue_idx - 1
		end
		local text = dlgConsole.history_queue[dlgConsole.history_queue_idx] or ""
		input:SetText(text)
		input:SetCursor(1,#text)
		return "break"
	end

	return ChoGGi_TextInput.OnKbdKeyDown(self,vk,...)
end

function ChoGGi_ConsoleLogWin:idToggleTransOnChange()
	self = GetRootDialog(self)
	self.transp_mode = not self.transp_mode
	self:SetTranspMode(self.transp_mode)
end
function ChoGGi_ConsoleLogWin:idShowFileLogOnPress()
	local _,text = ReadLog()
	GetRootDialog(self):UpdateText(text)
end
function ChoGGi_ConsoleLogWin:idShowModsLogOnPress()
	print(ModMessageLog)
end
function ChoGGi_ConsoleLogWin:idClearLogOnPress()
	GetRootDialog(self).idText:SetText("")
end
function ChoGGi_ConsoleLogWin:idCopyTextOnPress()
	ChoGGi.ComFuncs.OpenInMultiLineTextDlg{text = GetRootDialog(self).idText:GetText()}
end

function ChoGGi_ConsoleLogWin:SetTranspMode(toggle)
	self:ClearModifiers()
	if toggle then
		self:AddInterpolation{
			type = const.intAlpha,
			startValue = 32
		}
		self.idToggleTrans:AddInterpolation{
			type = const.intAlpha,
			startValue = 200,
			flags = const.intfIgnoreParent
		}
	end
	-- update global value (for new windows)
	ChoGGi.Temp.transp_mode = toggle
end

function ChoGGi_ConsoleLogWin:UpdateText(text)
	if text then
		self.idText:SetText(text)
		CreateRealTimeThread(function()
			Sleep(10)
			self:ScrollToBottom()
		end)
	end
end

function ChoGGi_ConsoleLogWin:ScrollToBottom()
	local y = Max(0, self.idScrollArea.scroll_range_y - self.idScrollArea.content_box:sizey())
	self.idScrollV:SetScroll(0, y)
	self.idScrollArea:ScrollTo(0, y)
end

dlgChoGGi_ConsoleLogWin = rawget(_G, "dlgChoGGi_ConsoleLogWin") or false
function OnMsg.ConsoleLine(text, bNewLine)
	local dlg = dlgChoGGi_ConsoleLogWin
	if dlg then
		local old_text = dlg.idText:GetText()

		if bNewLine then
			text = old_text .. "\n" .. text
		else
			text = old_text .. text
		end

		dlg:UpdateText(text)
	end
end

function ChoGGi_ConsoleLogWin:Done(result)
	local ChoGGi = ChoGGi
	-- closing means user doesn't want to see it next time (probably)
	ChoGGi.UserSettings.ConsoleHistoryWin = false
	dlgChoGGi_ConsoleLogWin = false
	ChoGGi.SettingFuncs.WriteSettings()
	-- save the dimensions
	ChoGGi.UserSettings.ConsoleLogWin_Pos = self:GetPos()
	ChoGGi.UserSettings.ConsoleLogWin_Size = self:GetSize()
	ChoGGi_Window.Done(self,result)
end
