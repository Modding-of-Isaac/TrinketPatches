TrinketPatches = {
    mod = RegisterMod("TrinketPatches", 1),

    log = function(text)
        if debug then
            print("[TP]"..text.tostring())
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

    game = Game()
}

local files = {
    "trinkets.lua",
    "eid.lua"
}

for _, file in pairs(files) do
    require(file)
end
