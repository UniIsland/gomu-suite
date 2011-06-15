local function Usage()
	print("GomuBindingSwitch\nSyntax: </gbsave | /gbload> [profile]\nexisting profiles are:")
	for index in pairs(GBSProfile) do
		print(index)
	end
end

local function GBSave(msg)
	local _, _, index = msg:lower():find("([%w%p]+)")
	if not index then Usage() return end
	if GBSProfile[index] == nil then GBSProfile[index] = {} end
	local count, cmd, key = 0
	for i=1, GetNumBindings() do
		cmd,key = GetBinding(i)
		if key then
			GBSProfile[index][cmd] = key
			count = count + 1
		end
	end
	print(index..": "..count.." bindings saved.")
end

local function GBLoad(msg)
	local _, _, index = msg:lower():find("([%w%p]+)")
	if not index then Usage() return end
	if GBSProfile[index] == nil then print("profile \""..index.."\" doesn't exist.") return end
	if InCombatLockdown() then print("Cannot modify bindings while in combat.") return end
	local count, key = 0
	for i=1, GetNumBindings() do
		_, key = GetBinding(i)
		if key then SetBinding(key) end
	end
	for cmd,key in pairs(GBSProfile[index]) do
		if (SetBinding(key, cmd)) then
			count = count + 1
		else
			print("setting binding pair ("..cmd.." & "..key..") failed.")
		end
	end
	SaveBindings(2)
	print(count.." bindings applied.")
end


SlashCmdList["GBSave"] = GBSave;
SLASH_GBSave1 = "/gbsave";
SlashCmdList["GBLoad"] = GBLoad;
SLASH_GBLoad1 = "/gbload";

if GBSProfile == nil then GBSProfile = {} end

print("GomuBindingSwitch is loaded.\ntype /gbsave and /gbload to see usage.");
