local version = "0.0.2"
local name = UnitName("player")
local realm = GetRealmName()

local function Usage()
  print("GomuActionbarSwitch\nSyntax: </gasave | /gaload> [profile]\nexisting profiles are:")
  for index in pairs(GASProfile.data[realm][name]) do
    print(index)
  end
end

local function GASave(msg)
  local _, _, index = msg:lower():find("([%w%p-]+)")
  if not index then Usage() return end
  GASProfile.data[realm][name][index] = {}
  local count, aType, aId = 0
  for i = 1, 120 do
    aType, aId = GetActionInfo(i)
    if aType then count = count + 1 end
    if aType == 'macro' then aId = GetMacroInfo(aId) end
    GASProfile.data[realm][name][index][i] = { aType, aId }
  end
  print(index..": "..count.." action bar slots saved.")
end

local function GALoad(msg)
  local _, _, index = msg:lower():find("([%w%p-]+)")
  if not index then Usage() return end
  if GASProfile.data[realm][name][index] == nil then print("profile \""..index.."\" doesn't exist.") return end
  if InCombatLockdown() then print("Cannot modify actions while in combat.") return end
  local count, aType, aId = 0
  for i = 1, 120 do
    aType, aId = GASProfile.data[realm][name][index][i][1], GASProfile.data[realm][name][index][i][2]
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

local function eventHandler(_, event, arg) -- self, event, arg
  if event == "ADDON_LOADED" and arg == '!GomuActionbarSwitch' then
    if GASProfile == nil then
      GASProfile = {
        ["ver"] = version,
        ["data"] = {},
        }
    end
    if GASProfile.data[realm] == nil then
      GASProfile.data[realm] = {}
    end
    if GASProfile.data[realm][name] == nil then
      GASProfile.data[realm][name] = {}
    end
  elseif event == "PLAYER_LOGOUT" then
    local activeTalentGroup = GetActiveTalentGroup(false, false)
    if activeTalentGroup == 1 then
      GASave("autosave-main")
    else
      GASave("autosave-off")
    end
  end
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", eventHandler);

SlashCmdList["GASave"] = GASave;
SLASH_GASave1 = "/gasave";
SlashCmdList["GALoad"] = GALoad;
SLASH_GALoad1 = "/gaload";

print("GomuActionbarSwitch is loaded.\ntype /gasave and /gaload to see usage.");

