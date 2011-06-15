function GNPShow()
	GNPFrame:Show();
end

function GNPCalc(msg)
	RunScript("GNPNote.ans = (" .. msg .. ")");
	print(GNPNote.ans);
	GNPNote["="] = GNPNote["="] .. "\n" .. msg .. " = " .. GNPNote.ans;
	if GNPFrameCurrentTab:GetText() == "=" then
		GNPEditBox:SetText(GNPNote["="]);
	end
end

function GNPLoad() 
	SlashCmdList["GNP"] = GNPShow;
	SLASH_GNP1 = "/gnp";
	SlashCmdList["SCALC"] = GNPCalc;
	SLASH_SCALC1 = '/=';
	if GNPNote == nil then
		GNPNote = {
			["0"] = "Click existing text to edit.\nClose or change tab without saving to discard changes.",
			["1"] = "tab1.",
			["2"] = "tab2.",
			["3"] = "tab3.",
			["4"] = "tab4.",
			["5"] = "tab5.",
			["6"] = "tab6.",
			["7"] = "last tab.",
			["="] = "this tab logs the results of ur /= calculations.\n1+1 = 2\n2*2 = 4\nGNPNote.ans + 5 = 9",
		}
	end
	print("GomuNotepad is loaded.\ntype /gnp to show the notepad.\ntype /= to use the calculator.");
end

function GNPEditFrame_OnShow()
	GNPEditBox:SetText(GNPNote[GNPFrameCurrentTab:GetText()]);
end

function GNPEditFrame_OnAccept()
	GNPNote[GNPFrameCurrentTab:GetText()] = GNPEditBox:GetText()
	GNPEditBox:ClearFocus()
end

function GNPCurrentTab_Update(id)
	GNPFrameCurrentTab:SetText(id);
	GNPEditBox:SetText(GNPNote[GNPFrameCurrentTab:GetText()]);
end