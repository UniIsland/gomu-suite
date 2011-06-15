GRMCurrentId, GRMCurrentName, GRMCurrentType = 0, nil, nil

StaticPopupDialogs["GomuRandomMountPrompt"] = {
	text = "\"%s\" is a ... mount?",
	button1 = "Ground",
	button2 = "Marine",
	button3 = "Flying",
	OnAccept = function()
		GRMCurrentType = "ground"
	end,
	OnCancel = function(_, reason)
		if reason == "override" then
			GRMCurrentType = nil
		else 
			GRMCurrentType = "marine"
		end
	end,
	OnAlt = function()
		GRMCurrentType = "flying"
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = false,
}

local function Usage()
	print("GomuRandomMount\nSyntax: /grm [ update | reset | usage ]\nshift/ctrl click to enforce a ground/flying mount.\nalt click to call /grm update")
end

local function Macro()
	while GetMacroIndexByName("grm") ~= 0 do
		DeleteMacro("grm")
	end
	local mId = CreateMacro("grm",53,"/grm",nil,1)
	PickupMacro(mId)
end

local function GRMount(msg)
	if GetMacroIndexByName("grm") == 0 then Macro() end
	local _, _, cmd = msg:lower():find("([%w%p]+)")
	if cmd == "update" or IsAltKeyDown() then
		if GRMCurrentId == 0 then
			GRMProfile.byType = {["flying"]={},["ground"]={},["marine"]={},}
		end
		if GRMCurrentType then
			GRMProfile.byName[GRMCurrentName] = GRMCurrentType
			table.insert(GRMProfile.byType[GRMCurrentType], GRMCurrentId)
			print(GRMCurrentName.." added as "..GRMCurrentType.." mount.")
			GRMCurrentType = nil
		end
		if GRMCurrentId >= GetNumCompanions("MOUNT") then
			print("updating completed.")
			return
		end
		for i = GRMCurrentId + 1, GetNumCompanions("MOUNT") do
			GRMCurrentId = i
			local _, cName = GetCompanionInfo("MOUNT", i)
			if GRMProfile.byName[cName] then
			table.insert(GRMProfile.byType[GRMProfile.byName[cName]],i)
			else
				GRMCurrentName = cName
				StaticPopup_Hide("GomuRandomMountPrompt")
				StaticPopup_Show("GomuRandomMountPrompt", cName)
				return
			end
		end
	elseif cmd == "reset" then
		GRMProfile.byName = {}
		GRMCurrentId, GRMCurrentName, GRMCurrentType = 0, nil, nil
		Macro()
	elseif cmd == "usage" then
		Usage()
	else
		if IsMounted() then Dismount() return end
		if UnitInVehicle("player") and CanExitVehicle() then VehicleExit() return end
		local t
		if strsub(GetMapInfo(),0,7) == "Vashjir" and IsSwimming() and not IsModifierKeyDown() then
			t = GRMProfile.byType.marine
		elseif IsShiftKeyDown() then
			t = GRMProfile.byType.ground
		elseif not IsFlyableArea() then
			t = GRMProfile.byType.ground
			for _, v in ipairs(GRMProfile.byType.flying) do
				table.insert(t, v)
			end
		else
			t = GRMProfile.byType.flying
		end
		if #t == 0 then print("no available mount.") return end
		CallCompanion("MOUNT",t[random(#t)])
	end
end


SlashCmdList["GRMount"] = GRMount;
SLASH_GRMount1 = "/grm";

if GRMProfile == nil then GRMProfile = {} end
if GRMProfile.byName == nil then GRMProfile.byName = {} end
if GRMProfile.byType == nil then GRMProfile.byType = {} end
if GRMProfile.byType.flying == nil then GRMProfile.byType.flying = {} end
if GRMProfile.byType.ground == nil then GRMProfile.byType.ground = {} end
if GRMProfile.byType.marine == nil then GRMProfile.byType.marine = {} end

print("GomuRandomMount is loaded.\ntype \"/grm usage\" to see usage.");
