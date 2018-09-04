TrinketPatches = {
    mod = RegisterMod("TrinketPatches", 1),
	
	debug = true,

    log = function(text)
        if TrinketPatches.debug then
            print("[TP] "..tostring(text))
        end
    end,

    chance = function(x, affectedByLuck)
        -- Takes percentage, i.e. 20 for 20%
        if not affectedByLuck then
            return math.random() < (x / 100)
        else
            local player = Isaac.GetPlayer(0)
            -- +5% chance for every luck up
            local modifier = x + 5 * player.Luck
            return math.random() < (x / 100)
        end
    end,

    game = Game(),
	
	config = require("config.lua")
}

TrinketPatches.mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, TrinketPatches.config.load)
TrinketPatches.mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, TrinketPatches.config.save)

require("eid.lua")

local files = {
	"bloody_crown.lua",
    "bobs_bladder.lua",
    "cancer.lua",
    "equality.lua",
    "match_stick.lua",
    "moms_locket.lua",
    "silver_dollar.lua",
    "stem_cell.lua",
    "tick.lua",
}

for _, file in pairs(files) do
    local funcs = require("trinkets/"..file)
    for fname, func in pairs(funcs) do
        TrinketPatches.mod:AddCallback(ModCallbacks[fname], func)
    end
end
