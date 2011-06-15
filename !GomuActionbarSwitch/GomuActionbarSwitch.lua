local function Usage()
	print("GomuActionbarSwitch\nSyntax: </gasave | /gaload> [profile]\nexisting profiles are:")
	for index in pairs(GASProfile) do
		print(index)
	end
end

local function GASave(msg)
	local _, _, index = msg:lower():find("([%w%p]+)")
	if not index then Usage() return end
	if GASProfile[index] == nil then GASProfile[index] = {} end
	local count, aType, aId = 0
	for i = 1, 120 do
		aType, aId = GetActionInfo(i)
		if aType then count = count + 1 end
		GASProfile[index][i]={ aType, aId }
	end
	print(index..": "..count.." action bar slots saved.")
end

local function GALoad(msg)
	local _, _, index = msg:lower():find("([%w%p]+)")
	if not index then Usage() return end
	if GASProfile[index] == nil then print("profile \""..index.."\" doesn't exist.") return end
	if InCombatLockdown() then print("Cannot modify actions while in combat.") return end
	local count, aType, aId = 0
	for i = 1, 120 do
		aType, aId = GASProfile[index][i][1], GASProfile[index][i][2]
		count = count + 1
		if aType == nil then
			PickupAction(i)
			ClearCursor()
			count = count - 1
		elseif aType == "spell" or aType == "companion" then
			PickupSpell(aId)
		elseif aType == "macro" then
			PickupMacro(aId)
		elseif aType == "item" then
			PickupItem(aId)
		elseif aType == "equipmentset" then
			PickupEquipmentSetByName(aId)
		elseif aType == "flyout" then
			local n = GetFlyoutInfo(aId)
			print(i..": Flyout not supported: "..n)
			count = count -1
		else
			print(i..": unknown action type: "..aType)
			count = count - 1
		end
		PlaceAction(i)
		ClearCursor()
	end
	print(index..": "..count.." action bar slots applied.")
end

SlashCmdList["GASave"] = GASave;
SLASH_GASave1 = "/gasave";
SlashCmdList["GALoad"] = GALoad;
SLASH_GALoad1 = "/gaload";

if GASProfile == nil then GASProfile = {} end

print("GomuActionbarSwitch is loaded.\ntype /gasave and /gaload to see usage.");
