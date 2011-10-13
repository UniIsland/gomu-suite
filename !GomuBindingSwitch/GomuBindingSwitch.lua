local function eventHandler(_, _, arg) -- self, event, addon_name
	if arg == '!GomuBindingSwitch' then
		if GBSProfile == nil then
			GBSProfile = {}
		end
		if GBSProfile.ver == nil then
			print("Updating GBS to version 0.0.2.")
			local tmp = GBSProfile
			GBSProfile = {}
			GBSProfile.ver = '0.0.2'
			GBSProfile.data = {}
			for index in pairs(tmp) do
				GBSProfile.data[index] = {}
				for cmd, key in pairs(tmp[index]) do
					GBSProfile.data[index][key] = cmd
				end
			end
			print("Updating GBS to version 0.0.2.")
			tmp = {}
		end
	end
end


local function Usage()
	print("GomuBindingSwitch\nSyntax: </gbsave | /gbload> [profile]\nexisting profiles are:")
	for index in pairs(GBSProfile.data) do
		print(index)
	end
end

local function GBSave(msg)
	local _, _, index = msg:lower():find("([%w%p-]+)")
	if not index then Usage() return end
	GBSProfile.data[index] = {}
	local count, i, cmd, key, key2 = 0
	for i=1, GetNumBindings() do
		cmd,key,key2 = GetBinding(i)
		if key then
			GBSProfile.data[index][key] = cmd
			count = count + 1
		end
		if key2 then
			GBSProfile.data[index][key2] = cmd
			count = count + 1
		end
	end
	print(index..": "..count.." bindings saved.")
end

local function GBLoad(msg)
	local _, _, index = msg:lower():find("([%w%p-]+)")
	if not index then Usage() return end
	if GBSProfile.data[index] == nil then print("profile \""..index.."\" doesn't exist.") return end
	if InCombatLockdown() then print("Cannot modify bindings while in combat.") return end
	local count, i, key, key2, cmd = 0
	for i=1, GetNumBindings() do
		_, key, key2 = GetBinding(i)
		if key then SetBinding(key) end
		if key2 then SetBinding(key2) end
	end
	for key,cmd in pairs(GBSProfile.data[index]) do
		if (SetBinding(key, cmd)) then
			count = count + 1
		else
			print("setting binding pair ("..cmd.." & "..key..") failed.")
		end
	end
	SaveBindings(2)
	print(count.." bindings applied.")
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", eventHandler);

SlashCmdList["GBSave"] = GBSave;
SLASH_GBSave1 = "/gbsave";
SlashCmdList["GBLoad"] = GBLoad;
SLASH_GBLoad1 = "/gbload";


print("GomuBindingSwitch is loaded.\ntype /gbsave and /gbload to see usage.");

