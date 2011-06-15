local function eventHandler(self, event, ...)
	if (event == "PLAYER_DEAD") and UnitIsPVP("player") and (GetPVPTimer() == 301000) then
		RepopMe();
	elseif (event == "LFG_PROPOSAL_SHOW") then
		PlaySoundFile("Sound\\Creature\\HeadlessHorseman\\Horseman_Laugh_01.ogg");
	end
end

local frame = CreateFrame("FRAME", "GEH");
frame:RegisterEvent("PLAYER_DEAD");
frame:RegisterEvent("LFG_PROPOSAL_SHOW");
frame:SetScript("OnEvent", eventHandler);

print("GomuEventHandler is loaded.");
