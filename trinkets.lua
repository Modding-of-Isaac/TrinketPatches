local function saveTrinketProperties()
    local stringified = "<DATA dollar="..tostring(enteredWithSilverDollar)..", crown="..tostring(enteredWithBloodyCrown)..">"
    Isaac.SaveModData(TrinketPatches, stringified)
end

local function loadTrinketProperties()
    local data = Isaac.LoadModData(TrinketPatches)
    enteredWithBloodyCrown = (string.match(data, "crown=(true|false)") == true)
    enteredWithSilverDollar = (string.match(data, "dollar=(true|false)") == true)
end

----- Registry

TrinketPatches.mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, loadTrinketProperties)
TrinketPatches.mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, saveTrinketProperties)

local files = {
    "bloody_crown.lua",
    "cancer.lua",
    "match_stick.lua",
    "silver_dollar.lua",
    "tick.lua",
    "bobs_bladder.lua",
    "equality.lua",
    "moms_locket.lua",
    "stem_cell.lua",
}

for _, file in files do
    local funcs = require("trinkets/"..file)
    for fname, func in pairs(funcs) do
        TrinketPatches.mod:AddCallback(ModCallbacks[fname], func)
    end
end
