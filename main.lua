TrinketPatches = {
    mod = RegisterMod("TrinketPatches", 1),

    debug = true,

    util = require("utils.lua"),

    game = Game(),

    config = require("config.lua")
}

-- Register load/save
TrinketPatches.mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function() TrinketPatches.config:load() end)
TrinketPatches.mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function() TrinketPatches.config:save() end)

-- Load EID entries
pcall(require, "eid.lua")

local files = {
    "bloody_crown.lua",
    "bobs_bladder.lua",
    "cancer.lua",
    "equality.lua",
    "match_stick.lua",
    "moms_locket.lua",
    "silver_dollar.lua",
    "stem_cell.lua",
    "tick.lua"
}

-- Load all trinket effects
for _, file in pairs(files) do
    pcall(require, "trinkets/"..file)
end
